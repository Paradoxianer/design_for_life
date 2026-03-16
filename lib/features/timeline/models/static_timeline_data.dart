import 'dfl_session.dart';

class StaticTimelineData {
  static final List<DflSession> sessions = [
    DflSession(
      id: 'session_1',
      title: 'Einheit Eins: Hallo, Guten Abend und Willkommen',
      description: 'Begrüßung und Einführung in das DFL Wochenende.',
      type: SessionType.lecture,
      moduleRoute: 'notes/session_1?title=Einheit Eins',
    ),
    DflSession(
      id: 'session_2',
      title: 'Einheit Zwei: Zurück in die Zukunft',
      description: 'Reflektion über die eigene Geschichte.',
      type: SessionType.lecture,
      moduleRoute: 'notes/session_2?title=Einheit Zwei',
    ),
    DflSession(
      id: 'session_3',
      title: 'Gruppenarbeit – Lebensbaum zeichnen + Auswerten',
      description: 'Erstellung des persönlichen Lebensbaums in der Gruppe.',
      type: SessionType.groupWork,
      moduleRoute: 'life-tree',
    ),
    DflSession(
      id: 'session_4',
      title: 'Hörendes Gebet',
      description: 'Zeit der Stille und des Hörens auf Gottes Stimme.',
      type: SessionType.prayer,
      moduleRoute: 'listening-prayer/session_4?title=Hörendes Gebet',
    ),
  ];
}
