import 'package:equatable/equatable.dart';
import '../models/personal_style_question.dart';
import '../models/personal_style_result.dart';

class PersonalStyleState extends Equatable {
  final PersonalStyleQuestionnaire questionnaire;
  final Map<String, int> answers; // questionId -> 1..6
  final Map<String, List<String>> takeaways;

  const PersonalStyleState({
    this.questionnaire = PersonalStyleQuestionnaire.empty,
    this.answers = const {},
    this.takeaways = const {},
  });

  bool get isLoaded => questionnaire.questions.isNotEmpty;

  bool get isCompleted =>
      questionnaire.questions.isNotEmpty && questionnaire.questions.every((q) => answers.containsKey(q.id));

  /// Modul-Vollständigkeit für die Timeline: das Ergebnis (Quadrant) steht
  /// fest, sobald alle Fragen beantwortet sind - die primäre Ausgabe dieses
  /// Moduls (analog zu #57: "top-3 gefunden = fertig" bei anderen Modulen).
  bool isSessionCompleted(String sessionId) => isCompleted;

  double get progress =>
      questionnaire.questions.isEmpty ? 0 : (answers.length / questionnaire.questions.length).clamp(0.0, 1.0);

  int get organisationScore =>
      questionnaire.organisationQuestions.fold(0, (sum, q) => sum + (answers[q.id] ?? 0));

  int get energyScore => questionnaire.energyQuestions.fold(0, (sum, q) => sum + (answers[q.id] ?? 0));

  /// null, solange der Bogen nicht vollständig beantwortet ist.
  PersonalStyleQuadrant? get quadrant {
    if (!isCompleted) return null;
    return determinePersonalStyleQuadrant(
      organisationScore: organisationScore,
      organisationQuestionCount: questionnaire.organisationQuestions.length,
      energyScore: energyScore,
      energyQuestionCount: questionnaire.energyQuestions.length,
    );
  }

  PersonalStyleProfile? get profile {
    final q = quadrant;
    if (q == null) return null;
    return questionnaire.profiles[q.profileKey];
  }

  PersonalStyleState copyWith({
    PersonalStyleQuestionnaire? questionnaire,
    Map<String, int>? answers,
    Map<String, List<String>>? takeaways,
  }) {
    return PersonalStyleState(
      questionnaire: questionnaire ?? this.questionnaire,
      answers: answers ?? this.answers,
      takeaways: takeaways ?? this.takeaways,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Wird mitpersistiert (wie SpiritualGiftsState.gifts / FeedbackState.
      // questionnaire), damit isSessionCompleted auch ohne erneutes Öffnen
      // des Screens korrekt berechnet werden kann.
      'questionnaire': questionnaire.toJson(),
      'answers': answers,
      'takeaways': takeaways,
    };
  }

  factory PersonalStyleState.fromJson(Map<String, dynamic> json) {
    return PersonalStyleState(
      questionnaire: json['questionnaire'] != null
          ? PersonalStyleQuestionnaire.fromJson(json['questionnaire'] as Map<String, dynamic>)
          : PersonalStyleQuestionnaire.empty,
      answers: Map<String, int>.from(json['answers'] as Map? ?? const {}),
      takeaways: (json['takeaways'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v as List)),
          ) ??
          const {},
    );
  }

  @override
  List<Object?> get props => [questionnaire, answers, takeaways];
}
