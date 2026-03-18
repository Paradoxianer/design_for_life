part of 'spiritual_gifts_bloc.dart';

abstract class SpiritualGiftsEvent extends Equatable {
  const SpiritualGiftsEvent();

  @override
  List<Object?> get props => [];
}

class AnswerQuestion extends SpiritualGiftsEvent {
  final String questionId;
  final int score;

  const AnswerQuestion({required this.questionId, required this.score});

  @override
  List<Object?> get props => [questionId, score];
}

class ResetTest extends SpiritualGiftsEvent {}
