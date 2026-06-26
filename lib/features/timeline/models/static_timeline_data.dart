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
        moduleRoute: 'notes/session_1?title=${l10n.session1Title}',
      ),
      DflSession(
        id: 'session_2',
        title: l10n.session2Title,
        description: l10n.session2Desc,
        type: SessionType.lecture,
        moduleRoute: 'notes/session_2?title=${l10n.session2Title}',
      ),
      DflSession(
        id: 'session_3',
        title: l10n.session3Title,
        description: l10n.session3Desc,
        type: SessionType.groupWork,
        moduleRoute: 'life-tree/session_3?title=${l10n.lifeTreeTitle}',
      ),
      DflSession(
        id: 'session_4',
        title: l10n.session4Title,
        description: l10n.session4Desc,
        type: SessionType.lecture,
        moduleRoute: 'notes/session_3?title=${l10n.session4Title}',
      ),
      DflSession(
        id: 'session_5',
        title: l10n.session5Title,
        description: l10n.session5Desc,
        type: SessionType.groupWork,
        moduleRoute: 'spiritual-gifts/session_5?title=${l10n.session5Title}',
      ),
      DflSession(
        id: 'session_6',
        title: l10n.session6Title,
        description: l10n.session6Desc,
        type: SessionType.groupWork,
        moduleRoute: 'values',
      ),
      DflSession(
        id: 'session_7',
        title: l10n.session7Title,
        description: l10n.session7Desc,
        type: SessionType.prayer,
        moduleRoute: 'listening-prayer/session_7?title=${l10n.session7Title}',
      ),
      DflSession(
        id: 'session_8',
        title: l10n.session8Title,
        description: l10n.session8Desc,
        type: SessionType.groupWork,
        moduleRoute: 'collage',
      ),
      DflSession(
        id: 'session_9',
        title: l10n.session9Title,
        description: l10n.session9Desc,
        type: SessionType.lecture,
        moduleRoute: 'notes/session_5?title=${l10n.session9Title}',
      ),
      DflSession(
        id: 'session_10',
        title: l10n.session10Title,
        description: l10n.session10Desc,
        type: SessionType.personalReflection,
        moduleRoute: 'goals/session_10?title=${l10n.session10Title}',
      ),
      DflSession(
        id: 'session_11',
        title: l10n.session11Title,
        type: SessionType.other,
        moduleRoute: 'group-photo',
      ),
      DflSession(
        id: 'session_12',
        title: l10n.session12Title,
        type: SessionType.other,
        moduleRoute: 'feedback',
      ),
    ];
  }
}
