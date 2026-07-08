part of 'spiritual_gifts_bloc.dart';

abstract class SpiritualGiftsEvent extends Equatable {
  const SpiritualGiftsEvent();

  @override
  List<Object?> get props => [];
}

class InitTest extends SpiritualGiftsEvent {
  final String locale;
  final String sessionId;
  const InitTest({required this.locale, required this.sessionId});

  @override
  List<Object?> get props => [locale, sessionId];
}

class AnswerQuestion extends SpiritualGiftsEvent {
  final String questionId;
  final int score;

  const AnswerQuestion({required this.questionId, required this.score});

  @override
  List<Object?> get props => [questionId, score];
}

class PreviousQuestion extends SpiritualGiftsEvent {}

class ResetTest extends SpiritualGiftsEvent {}

class UpdateTakeaways extends SpiritualGiftsEvent {
  final String sessionId;
  final List<String> takeaways;

  const UpdateTakeaways({required this.sessionId, required this.takeaways});

  @override
  List<Object?> get props => [sessionId, takeaways];
}

/// Stores one external "Referenz" (R) assessment (#42) - either freshly
/// answered on this device or imported from a gift-reference-result deep
/// link. Keyed by assessmentId so multiple references don't overwrite each
/// other and can each be weighted into the blended score.
class SubmitReferenceAssessment extends SpiritualGiftsEvent {
  final String assessmentId;
  final Map<String, int> answers;
  final String? label;

  const SubmitReferenceAssessment({
    required this.assessmentId,
    required this.answers,
    this.label,
  });

  @override
  List<Object?> get props => [assessmentId, answers, label];
}
