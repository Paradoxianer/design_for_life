import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Parsed representation of a supported deep link (#49): either restricting
/// the visible timeline modules, or one of the two "Gaben-Referenz"
/// invite/import actions (#42).
sealed class DeepLinkAction {
  const DeepLinkAction();
}

/// `?modules=session_1,session_3&date=2026-08-01&location=...` - restricts
/// the timeline to only the given session IDs (a stripped-down DFL for a
/// shortened format), replacing any previous restriction. Not a "locking"
/// mechanism: sessions outside the list aren't shown at all, not shown as
/// locked placeholders - people shouldn't need to know what else exists.
/// Also optionally carries event metadata to show in the timeline header.
class ShowOnlyModulesAction extends DeepLinkAction {
  final List<String> sessionIds;
  final String? eventDate;
  final String? eventLocation;

  const ShowOnlyModulesAction(
    this.sessionIds, {
    this.eventDate,
    this.eventLocation,
  });
}

/// `dfl://open?flow=gift-reference&assessmentId=...` (#42) - opens the
/// external "Referenz" mini-flow for the given assessment.
class GiftReferenceInviteAction extends DeepLinkAction {
  final String assessmentId;

  const GiftReferenceInviteAction(this.assessmentId);
}

/// `dfl://open?flow=gift-reference-result&assessmentId=...&answers=...`
/// (#42) - carries a reviewer's raw, still-encoded answers payload back to
/// the inviter. Decoding needs the current gifts data (for the question
/// order), which this gift-agnostic service doesn't own, so that happens
/// where the action is handled (see GiftReferenceLinkService.decodeAnswers).
class GiftReferenceResultAction extends DeepLinkAction {
  final String assessmentId;
  final String answersPayload;
  final String? label;

  const GiftReferenceResultAction(
    this.assessmentId,
    this.answersPayload, {
    this.label,
  });
}

/// `?leaderKey=...` (#83) - unlocks leader-only content (Sprechernotizen)
/// on this device. Whether [key] is actually correct is checked downstream
/// by LeaderModeBloc, which owns the secret - this service just extracts
/// the raw value, same as it does for e.g. GiftReferenceInviteAction's
/// assessmentId.
class LeaderKeyAction extends DeepLinkAction {
  final String key;

  const LeaderKeyAction(this.key);
}

/// Listens for incoming `dfl://` links and turns them into [DeepLinkAction]s.
///
/// `http`/`https` are also accepted (same query format): on Flutter Web,
/// app_links reports the page's own URL (there is no OS-level dispatch to
/// intercept, see app_links_web), so this is what makes the whole flow
/// testable in a browser - just append e.g. `?modules=...` to the app's dev
/// URL and reload. On Android/iOS this branch is currently unreachable in
/// practice, since no `https://` intent-filter/associated domain is
/// registered yet - that needs a real Android applicationId + release-
/// keystore SHA256 fingerprint and a real iOS bundle id + Apple Team ID
/// first (both are still Flutter template placeholders, see #37).
class DeepLinkService {
  final AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  DeepLinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  /// The link the app was cold-started with, if any.
  Future<DeepLinkAction?> getInitialAction() async {
    final uri = await _appLinks.getInitialLink();
    if (uri == null) return null;
    return parse(uri);
  }

  /// Links received while the app is already running.
  void listen(void Function(DeepLinkAction action) onAction) {
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      final action = parse(uri);
      if (action != null) onAction(action);
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  static const _supportedSchemes = {'dfl', 'http', 'https'};

  static DeepLinkAction? parse(Uri uri) {
    if (!_supportedSchemes.contains(uri.scheme)) return null;

    final params = uri.queryParameters;
    final flow = params['flow'];

    if (flow == 'gift-reference') {
      final assessmentId = params['assessmentId'];
      if (assessmentId == null || assessmentId.isEmpty) return null;
      return GiftReferenceInviteAction(assessmentId);
    }

    if (flow == 'gift-reference-result') {
      final assessmentId = params['assessmentId'];
      final answers = params['answers'];
      if (assessmentId == null ||
          assessmentId.isEmpty ||
          answers == null ||
          answers.isEmpty) {
        return null;
      }
      return GiftReferenceResultAction(
        assessmentId,
        answers,
        label: params['label'],
      );
    }

    final leaderKey = params['leaderKey'];
    if (leaderKey != null && leaderKey.isNotEmpty) {
      return LeaderKeyAction(leaderKey);
    }

    final modulesParam = params['modules'];
    if (modulesParam == null || modulesParam.isEmpty) return null;

    final sessionIds = modulesParam
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (sessionIds.isEmpty) return null;

    return ShowOnlyModulesAction(
      sessionIds,
      eventDate: params['date'],
      eventLocation: params['location'],
    );
  }

  /// Fallback link base while there's no native app-store presence yet
  /// (#37): the GitHub Pages web build (auto-deployed on every push to
  /// `main` via .github/workflows/deploy.yml) works everywhere - a browser,
  /// no OS-level install or Universal Link verification needed. Swap this
  /// for a `dfl://` (or a verified `https://`) base once native
  /// distribution exists.
  ///
  /// On Flutter Web this is only used if the running page's own address
  /// can't serve as a base (see [resolveWebLinkBase]); native builds always
  /// use it.
  static const String webLinkBase =
      'https://paradoxianer.github.io/design_for_life/';

  /// Works out the base URL that links should be built on.
  ///
  /// When the app runs in a browser ([runningAt] is the page's own address,
  /// i.e. `Uri.base`), links point back to wherever the app is actually
  /// hosted - so a copy on e.g. `https://dfl.heilsarmee.de/` creates links
  /// to itself instead of to GitHub Pages. Only scheme, host, port and the
  /// directory part of the path are kept; query, fragment (hash routing)
  /// and a trailing file name such as `index.html` are dropped.
  ///
  /// Returns the [webLinkBase] fallback when [runningAt] is null or isn't an
  /// http(s) address with a host (native apps, tests, `file://`).
  static Uri resolveWebLinkBase(Uri? runningAt) {
    if (runningAt == null ||
        (runningAt.scheme != 'http' && runningAt.scheme != 'https') ||
        runningAt.host.isEmpty) {
      return Uri.parse(webLinkBase);
    }
    final path = runningAt.path;
    final directory = path.substring(0, path.lastIndexOf('/') + 1);
    return Uri(
      scheme: runningAt.scheme,
      host: runningAt.host,
      port: runningAt.hasPort ? runningAt.port : null,
      path: directory.isEmpty ? '/' : directory,
    );
  }

  /// Builds a link with [queryParameters] on the current web base (see
  /// [resolveWebLinkBase]). [runningAt] defaults to the page's own address on
  /// Web and to null elsewhere; it only needs to be passed in tests.
  static Uri buildWebLink(
    Map<String, String> queryParameters, {
    Uri? runningAt,
  }) {
    final base = resolveWebLinkBase(runningAt ?? (kIsWeb ? Uri.base : null));
    return base.replace(queryParameters: queryParameters);
  }
}
