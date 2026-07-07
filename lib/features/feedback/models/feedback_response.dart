import 'package:equatable/equatable.dart';

/// Generische Antworten: Skalen-Fragen speichern einen int (1-6), Freitext-
/// Fragen einen String, jeweils unter der Frage-Id aus dem geladenen
/// [FeedbackQuestionnaire]. Das Fragenset selbst ist nicht mehr hartkodiert
/// (siehe feedback_question.dart), daher hier keine festen Felder mehr (#7).
class FeedbackResponse extends Equatable {
  final Map<String, Object> answers;

  const FeedbackResponse({this.answers = const {}});

  int? scaleAnswer(String questionId) => answers[questionId] as int?;

  String textAnswer(String questionId) => answers[questionId] as String? ?? '';

  FeedbackResponse copyWithAnswer(String questionId, Object value) {
    final updated = Map<String, Object>.from(answers)..[questionId] = value;
    return FeedbackResponse(answers: updated);
  }

  Map<String, dynamic> toJson() => {'answers': answers};

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['answers'] as Map<String, dynamic>? ?? const {};
    return FeedbackResponse(answers: Map<String, Object>.from(raw));
  }

  @override
  List<Object?> get props => [answers];
}
