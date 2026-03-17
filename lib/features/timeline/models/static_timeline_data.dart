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
      moduleRoute: 'life-tree', // Hinweis: Muss in main.dart noch definiert werden
    ),
    DflSession(
      id: 'session_4',
      title: 'Einheit Drei: Das Hier und Jetzt',
      description: 'Gegenwart und Identität.',
      type: SessionType.lecture,
      moduleRoute: 'notes/session_3?title=Einheit Drei',
    ),
    DflSession(
      id: 'session_5',
      title: 'Gaben (Auswertung, Austausch)',
      description: 'Entdeckung und Einordnung der geistlichen Gaben.',
      type: SessionType.groupWork,
      moduleRoute: 'spiritual-gifts',
    ),
    DflSession(
      id: 'session_6',
      title: 'Werte (Alle Aufgaben Im Heft fertig + Austausch)',
      description: 'Zusammenhänge zu den Gaben + Lebensbaum.',
      type: SessionType.groupWork,
      moduleRoute: 'values',
    ),
    DflSession(
      id: 'session_7',
      title: 'Einheit Vier: Bete, Träume, Höre! (Hörendes Gebet)',
      description: 'Praktische Einführung und Zeit des hörenden Gebets.',
      type: SessionType.prayer,
      moduleRoute: 'listening-prayer/session_7?title=Hörendes Gebet',
    ),
    DflSession(
      id: 'session_8',
      title: 'Entwicklung einer Zukunftidee',
      description: 'The Big Picture I (Collage) aus Lebensbaum, Gaben, Werten und hörendem Gebet.',
      type: SessionType.groupWork,
      moduleRoute: 'collage',
    ),
    DflSession(
      id: 'session_9',
      title: 'Einheit Fünf: Weißt Du den Weg nach San Jose',
      description: 'Ausblick und nächste Schritte.',
      type: SessionType.lecture,
      moduleRoute: 'notes/session_5?title=Einheit Fünf',
    ),
    DflSession(
      id: 'session_10',
      title: '3 Ziele festlegen',
      description: 'Persönliche Zielsetzung in Einzelgesprächen.',
      type: SessionType.personalReflection,
      moduleRoute: 'goals/session_10?title=Ziele',
    ),
    DflSession(
      id: 'session_11',
      title: 'Gruppenfoto',
      type: SessionType.other,
      moduleRoute: 'group-photo',
    ),
    DflSession(
      id: 'session_12',
      title: 'Feedbackbogen',
      type: SessionType.other,
      moduleRoute: 'feedback',
    ),
  ];
}
