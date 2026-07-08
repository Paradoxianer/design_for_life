import 'package:design_for_life/l10n/generated/app_localizations.dart';

import 'dfl_session.dart';

class TimelineConfigSession {
  final String id;
  final String moduleId;
  final String? moduleSessionId;
  final int order;
  final String titleKey;
  final String? descriptionKey;
  final SessionType type;
  final bool enabled;
  final bool locked;

  const TimelineConfigSession({
    required this.id,
    required this.moduleId,
    this.moduleSessionId,
    required this.order,
    required this.titleKey,
    this.descriptionKey,
    required this.type,
    this.enabled = true,
    this.locked = false,
  });

  factory TimelineConfigSession.fromJson(Map<String, dynamic> json) {
    return TimelineConfigSession(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      moduleSessionId: json['moduleSessionId'] as String?,
      order: json['order'] as int,
      titleKey: json['titleKey'] as String,
      descriptionKey: json['descriptionKey'] as String?,
      type: _sessionTypeFromString(json['type'] as String? ?? 'other'),
      enabled: json['enabled'] as bool? ?? true,
      locked: json['locked'] as bool? ?? false,
    );
  }

  DflSession toSession(AppLocalizations l10n) {
    return DflSession(
      id: id,
      title: _localizedValue(l10n, titleKey),
      description: descriptionKey == null ? null : _localizedValue(l10n, descriptionKey!),
      type: type,
      moduleId: moduleId,
      moduleSessionId: moduleSessionId,
      locked: locked,
    );
  }

  static SessionType _sessionTypeFromString(String value) {
    switch (value) {
      case 'lecture':
        return SessionType.lecture;
      case 'groupWork':
        return SessionType.groupWork;
      case 'personalReflection':
        return SessionType.personalReflection;
      case 'prayer':
        return SessionType.prayer;
      default:
        return SessionType.other;
    }
  }

  static String _localizedValue(AppLocalizations l10n, String key) {
    // Generated localization classes expose typed getters instead of string lookups,
    // and Flutter does not provide reflection for these accessors in release builds.
    // Keeping the mapping explicit preserves type safety for config-driven session labels.
    // Add any new timeline title/description keys here when extending the config schema.
    switch (key) {
      case 'session1Title':
        return l10n.session1Title;
      case 'session1Desc':
        return l10n.session1Desc;
      case 'session2Title':
        return l10n.session2Title;
      case 'session2Desc':
        return l10n.session2Desc;
      case 'session3Title':
        return l10n.session3Title;
      case 'session3Desc':
        return l10n.session3Desc;
      case 'session4Title':
        return l10n.session4Title;
      case 'session4Desc':
        return l10n.session4Desc;
      case 'session5Title':
        return l10n.session5Title;
      case 'session5Desc':
        return l10n.session5Desc;
      case 'session6Title':
        return l10n.session6Title;
      case 'session6Desc':
        return l10n.session6Desc;
      case 'session7Title':
        return l10n.session7Title;
      case 'session7Desc':
        return l10n.session7Desc;
      case 'timelineSynthesisTitle':
        return l10n.timelineSynthesisTitle;
      case 'timelineSynthesisDesc':
        return l10n.timelineSynthesisDesc;
      case 'timelineImagineTitle':
        return l10n.timelineImagineTitle;
      case 'timelineImagineDesc':
        return l10n.timelineImagineDesc;
      case 'session9Title':
        return l10n.session9Title;
      case 'session9Desc':
        return l10n.session9Desc;
      case 'session10Title':
        return l10n.session10Title;
      case 'session10Desc':
        return l10n.session10Desc;
      case 'session11Title':
        return l10n.session11Title;
      case 'session12Title':
        return l10n.session12Title;
      case 'session13Title':
        return l10n.session13Title;
      case 'session13Desc':
        return l10n.session13Desc;
      default:
        return key;
    }
  }
}
