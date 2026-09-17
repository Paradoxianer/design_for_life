import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/leader_note_session.dart';

/// Loads leader-only session content (#83) from `assets/data/leader_notes_
/// $locale.json`, keyed by the same session ids used in
/// `assets/config/timeline_config.json` (e.g. "session_1").
///
/// Same locale-fallback rule as [GiftsRepository]: the Leiterheft this is
/// transcribed from only exists in German today, so an English asset file
/// may be incomplete or absent for a while - falling back to German rather
/// than showing nothing keeps leader notes usable in the meantime.
class LeaderNotesRepository {
  Map<String, LeaderNoteSession>? _cached;
  String? _cachedLocale;

  Future<Map<String, LeaderNoteSession>> loadSessions(
    String locale, {
    bool forceReload = false,
  }) async {
    if (!forceReload && _cached != null && _cachedLocale == locale) {
      return _cached!;
    }

    try {
      String response;
      try {
        response = await rootBundle.loadString(
          'assets/data/leader_notes_$locale.json',
        );
        _cachedLocale = locale;
      } catch (_) {
        response = await rootBundle.loadString(
          'assets/data/leader_notes_de.json',
        );
        _cachedLocale = 'de';
      }

      final Map<String, dynamic> data = json.decode(response);
      final sessions = <String, LeaderNoteSession>{};
      data.forEach((sessionId, value) {
        // Keys starting with "_" are file-level metadata (e.g. a translation
        // note), not a session - JSON has no native comment syntax.
        if (sessionId.startsWith('_')) return;
        sessions[sessionId] = LeaderNoteSession.fromJson(
          value as Map<String, dynamic>,
        );
      });
      _cached = sessions;
      return _cached!;
    } catch (_) {
      return {};
    }
  }
}
