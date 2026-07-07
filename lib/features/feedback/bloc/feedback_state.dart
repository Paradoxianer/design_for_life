import 'package:equatable/equatable.dart';
import '../models/feedback_question.dart';
import '../models/feedback_response.dart';

class FeedbackState extends Equatable {
  final FeedbackResponse response;
  final FeedbackQuestionnaire questionnaire;
  final bool isSubmitted;

  const FeedbackState({
    this.response = const FeedbackResponse(),
    this.questionnaire = FeedbackQuestionnaire.empty,
    this.isSubmitted = false,
  });

  /// Vollständig ist der Bogen, sobald jede Skalen-Frage (1-6) beantwortet
  /// ist - Freitextfelder bleiben optional, wie schon vor #7.
  bool get isCompleted =>
      questionnaire.scaleQuestions.isNotEmpty &&
      questionnaire.scaleQuestions.every((q) => response.answers[q.id] != null);

  FeedbackState copyWith({
    FeedbackResponse? response,
    FeedbackQuestionnaire? questionnaire,
    bool? isSubmitted,
  }) {
    return FeedbackState(
      response: response ?? this.response,
      questionnaire: questionnaire ?? this.questionnaire,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response.toJson(),
      // Wird mitpersistiert (wie SpiritualGiftsState.gifts), damit
      // isCompleted auch ohne erneutes Öffnen des Screens korrekt aus dem
      // Timeline-Registry berechnet werden kann.
      'questionnaire': questionnaire.toJson(),
      'isSubmitted': isSubmitted,
    };
  }

  factory FeedbackState.fromJson(Map<String, dynamic> json) {
    return FeedbackState(
      response: FeedbackResponse.fromJson(json['response'] as Map<String, dynamic>? ?? const {}),
      questionnaire: json['questionnaire'] != null
          ? FeedbackQuestionnaire.fromJson(json['questionnaire'] as Map<String, dynamic>)
          : FeedbackQuestionnaire.empty,
      isSubmitted: json['isSubmitted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [response, questionnaire, isSubmitted];
}
