import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../models/dfl_session.dart';
import '../models/static_timeline_data.dart';
import '../models/timeline_config_session.dart';

class TimelineConfigRepository {
  static const String _assetPath = 'assets/config/timeline_config.json';

  const TimelineConfigRepository();

  Future<List<DflSession>> loadSessions(AppLocalizations l10n) async {
    try {
      final rawConfig = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(rawConfig);
      if (decoded is! Map<String, dynamic>) {
        return StaticTimelineData.getSessions(l10n);
      }

      final sessionsJson = decoded['sessions'];
      if (sessionsJson is! List) {
        return StaticTimelineData.getSessions(l10n);
      }

      final sessions = sessionsJson
          .map((item) => TimelineConfigSession.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((session) => session.enabled)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      return sessions.map((session) => session.toSession(l10n)).toList();
    } catch (_) {
      return StaticTimelineData.getSessions(l10n);
    }
  }
}
