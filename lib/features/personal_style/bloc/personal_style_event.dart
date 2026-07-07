import 'package:equatable/equatable.dart';

abstract class PersonalStyleEvent extends Equatable {
  const PersonalStyleEvent();

  @override
  List<Object?> get props => [];
}

/// Lädt den Fragebogen für die aktuelle App-Sprache (#50), analog zu
/// InitTest bei den Geistesgaben.
class InitPersonalStyleAssessment extends PersonalStyleEvent {
  final String locale;

  const InitPersonalStyleAssessment({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class AnswerPersonalStyleQuestion extends PersonalStyleEvent {
  final String sessionId;
  final String questionId;
  final int value;

  const AnswerPersonalStyleQuestion(this.sessionId, this.questionId, this.value);

  @override
  List<Object?> get props => [sessionId, questionId, value];
}

class UpdatePersonalStyleTakeaway extends PersonalStyleEvent {
  final String sessionId;
  final int index;
  final String text;

  const UpdatePersonalStyleTakeaway(this.sessionId, this.index, this.text);

  @override
  List<Object?> get props => [sessionId, index, text];
}
