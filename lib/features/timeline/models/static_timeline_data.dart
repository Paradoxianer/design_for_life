import 'package:design_for_life/l10n/generated/app_localizations.dart';

import 'dfl_session.dart';

class StaticTimelineData {
  static List<DflSession> getSessions(AppLocalizations l10n) {
    return [
      DflSession(
        id: 'session_1',
        title: l10n.session1Title,
        description: l10n.session1Desc,
        type: SessionType.lecture,
        moduleId: 'module_notes',
        moduleSessionId: 'session_1',
      ),
      DflSession(
        id: 'session_2',
        title: l10n.session2Title,
        description: l10n.session2Desc,
        type: SessionType.lecture,
        moduleId: 'module_notes',
        moduleSessionId: 'session_2',
      ),
      DflSession(
        id: 'session_3',
        title: l10n.session3Title,
        description: l10n.session3Desc,
        type: SessionType.groupWork,
        moduleId: 'module_life_tree',
        moduleSessionId: 'session_3',
      ),
      DflSession(
        id: 'session_4',
        title: l10n.session4Title,
        description: l10n.session4Desc,
        type: SessionType.lecture,
        moduleId: 'module_notes',
        moduleSessionId: 'session_3',
      ),
      DflSession(
        id: 'session_5',
        title: l10n.session5Title,
        description: l10n.session5Desc,
        type: SessionType.groupWork,
        moduleId: 'module_spiritual_gifts',
        moduleSessionId: 'session_5',
      ),
      DflSession(
        id: 'session_6',
        title: l10n.session6Title,
        description: l10n.session6Desc,
        type: SessionType.groupWork,
        moduleId: 'module_values',
      ),
      DflSession(
        id: 'session_7',
        title: l10n.session7Title,
        description: l10n.session7Desc,
        type: SessionType.prayer,
        moduleId: 'module_listening_prayer',
        moduleSessionId: 'session_7',
      ),
      DflSession(
        id: 'session_synthesis',
        title: l10n.timelineSynthesisTitle,
        description: l10n.timelineSynthesisDesc,
        type: SessionType.groupWork,
        moduleId: 'module_synthesis',
        moduleSessionId: 'session_synthesis',
      ),
      DflSession(
        id: 'session_imagine',
        title: l10n.timelineImagineTitle,
        description: l10n.timelineImagineDesc,
        type: SessionType.groupWork,
        moduleId: 'module_imagine',
        moduleSessionId: 'session_imagine',
      ),
      DflSession(
        id: 'session_9',
        title: l10n.session9Title,
        description: l10n.session9Desc,
        type: SessionType.lecture,
        moduleId: 'module_notes',
        moduleSessionId: 'session_5',
      ),
      DflSession(
        id: 'session_10',
        title: l10n.session10Title,
        description: l10n.session10Desc,
        type: SessionType.personalReflection,
        moduleId: 'module_goals',
        moduleSessionId: 'session_10',
      ),
      DflSession(
        id: 'session_11',
        title: l10n.session11Title,
        type: SessionType.other,
        moduleId: 'module_group_photo',
      ),
      DflSession(
        id: 'session_12',
        title: l10n.session12Title,
        type: SessionType.other,
        moduleId: 'module_feedback',
      ),
      DflSession(
        id: 'session_13',
        title: l10n.session13Title,
        description: l10n.session13Desc,
        type: SessionType.personalReflection,
        moduleId: 'module_personal_style',
        moduleSessionId: 'session_13',
      ),
    ];
  }
}
