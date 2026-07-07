import 'package:equatable/equatable.dart';

/// Organisation: Strukturiert (Pol 1) <-> Unstrukturiert (Pol 6).
/// Energy: Mensch (Pol 1) <-> Aufgabe (Pol 6).
/// Siehe personal_style_question.dart::PersonalStyleQuestion für die
/// konkrete Pol-Zuordnung pro Frage (#50).
enum PersonalStyleDimension { organisation, energy }

/// Eine Frage mit zwei gegensätzlichen Aussagen auf einer 1-6-Skala.
/// [leftLabel] entspricht immer Wert 1, [rightLabel] immer Wert 6 - für
/// Organisation ist links immer der "strukturiert"-Pol, für Energy immer der
/// "Mensch"-Pol, damit die Auswertung ohne Sonderfälle je Frage auskommt.
class PersonalStyleQuestion extends Equatable {
  final String id;
  final PersonalStyleDimension dimension;
  final String leftLabel;
  final String rightLabel;

  const PersonalStyleQuestion({
    required this.id,
    required this.dimension,
    required this.leftLabel,
    required this.rightLabel,
  });

  factory PersonalStyleQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalStyleQuestion(
      id: json['id'] as String,
      dimension: json['dimension'] == 'energy' ? PersonalStyleDimension.energy : PersonalStyleDimension.organisation,
      leftLabel: json['leftLabel'] as String,
      rightLabel: json['rightLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dimension': dimension == PersonalStyleDimension.energy ? 'energy' : 'organisation',
        'leftLabel': leftLabel,
        'rightLabel': rightLabel,
      };

  @override
  List<Object?> get props => [id, dimension, leftLabel, rightLabel];
}

/// Eine der vier Profil-Beschreibungen der 2x2-Matrix (#50).
class PersonalStyleProfile extends Equatable {
  final String title;
  final List<String> traits;

  const PersonalStyleProfile({required this.title, this.traits = const []});

  factory PersonalStyleProfile.fromJson(Map<String, dynamic> json) {
    return PersonalStyleProfile(
      title: json['title'] as String,
      traits: (json['traits'] as List? ?? const []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'traits': traits};

  @override
  List<Object?> get props => [title, traits];
}

/// Der komplette Fragebogen inkl. Profil-Beschreibungen, geladen aus
/// `assets/data/personal_style_questions_<locale>.json` (#50) - analog zum
/// Feedback-Fragebogen (#7), damit Fragen/Profile ohne Code-Änderung
/// angepasst werden können.
class PersonalStyleQuestionnaire extends Equatable {
  final List<PersonalStyleQuestion> questions;
  final Map<String, PersonalStyleProfile> profiles;

  const PersonalStyleQuestionnaire({this.questions = const [], this.profiles = const {}});

  static const empty = PersonalStyleQuestionnaire();

  List<PersonalStyleQuestion> get organisationQuestions =>
      questions.where((q) => q.dimension == PersonalStyleDimension.organisation).toList();

  List<PersonalStyleQuestion> get energyQuestions =>
      questions.where((q) => q.dimension == PersonalStyleDimension.energy).toList();

  factory PersonalStyleQuestionnaire.fromJson(Map<String, dynamic> json) {
    return PersonalStyleQuestionnaire(
      questions: (json['questions'] as List? ?? const [])
          .map((q) => PersonalStyleQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      profiles: (json['profiles'] as Map<String, dynamic>? ?? const {}).map(
        (key, value) => MapEntry(key, PersonalStyleProfile.fromJson(value as Map<String, dynamic>)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'questions': questions.map((q) => q.toJson()).toList(),
        'profiles': profiles.map((key, value) => MapEntry(key, value.toJson())),
      };

  @override
  List<Object?> get props => [questions, profiles];
}
