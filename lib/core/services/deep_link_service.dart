import 'dart:async';

import 'package:app_links/app_links.dart';

/// Parsed representation of a supported deep link (#49). Kept intentionally
/// extensible - the planned #42 "Gaben-Referenz" invite/import flow will add
/// further subtypes here without reworking the listening/dispatch plumbing
/// in [DeepLinkService].
sealed class DeepLinkAction {
  const DeepLinkAction();
}

/// `dfl://open?modules=session_1,session_3&date=2026-08-01&location=...`
/// Unlocks the given timeline session IDs and optionally carries event
/// metadata to show in the timeline header.
class UnlockModulesAction extends DeepLinkAction {
  final List<String> sessionIds;
  final String? eventDate;
  final String? eventLocation;

  const UnlockModulesAction(
    this.sessionIds, {
    this.eventDate,
    this.eventLocation,
  });
}

/// Listens for incoming `dfl://` links and turns them into [DeepLinkAction]s.
///
/// Only the custom URI scheme is wired up so far. A `https://paradoxianer
/// .github.io/design_for_life/...` mirror (real Universal/App Links) needs a
/// real Android applicationId + release-keystore SHA256 fingerprint and a
/// real iOS bundle id + Apple Team ID first (both are still Flutter
/// template placeholders, see #37) - once those exist, the same query
/// format can be verified and parsed here too.
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

  static DeepLinkAction? parse(Uri uri) {
    if (uri.scheme != 'dfl') return null;

    final params = uri.queryParameters;
    final modulesParam = params['modules'];
    if (modulesParam == null || modulesParam.isEmpty) return null;

    final sessionIds = modulesParam
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (sessionIds.isEmpty) return null;

    return UnlockModulesAction(
      sessionIds,
      eventDate: params['date'],
      eventLocation: params['location'],
    );
  }
}
