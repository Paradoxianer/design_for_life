part of 'gift_reference_answer_bloc.dart';

abstract class GiftReferenceAnswerEvent extends Equatable {
  const GiftReferenceAnswerEvent();

  @override
  List<Object?> get props => [];
}

class AnswerReferenceQuestion extends GiftReferenceAnswerEvent {
  final String assessmentId;
  final String questionId;
  final int score;

  const AnswerReferenceQuestion({
    required this.assessmentId,
    required this.questionId,
    required this.score,
  });

  @override
  List<Object?> get props => [assessmentId, questionId, score];
}

class ClearReferenceAssessment extends GiftReferenceAnswerEvent {
  final String assessmentId;

  const ClearReferenceAssessment(this.assessmentId);

  @override
  List<Object?> get props => [assessmentId];
}
