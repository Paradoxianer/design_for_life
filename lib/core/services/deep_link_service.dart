import 'dart:async';

import 'package:app_links/app_links.dart';

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

  const GiftReferenceResultAction(this.assessmentId, this.answersPayload, {this.label});
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
      if (assessmentId == null || assessmentId.isEmpty || answers == null || answers.isEmpty) {
        return null;
      }
      return GiftReferenceResultAction(assessmentId, answers, label: params['label']);
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

  /// Standard link base while there's no native app-store presence yet
  /// (#37): the GitHub Pages web build (auto-deployed on every push to
  /// `main` via .github/workflows/deploy.yml) works everywhere - a browser,
  /// no OS-level install or Universal Link verification needed. Swap this
  /// for a `dfl://` (or a verified `https://`) base once native
  /// distribution exists.
  static const String webLinkBase = 'https://paradoxianer.github.io/design_for_life/';

  static Uri buildWebLink(Map<String, String> queryParameters) {
    return Uri.parse(webLinkBase).replace(queryParameters: queryParameters);
  }
}
