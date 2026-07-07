import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

/// Lädt den Fragebogen für die aktuelle App-Sprache (#7). forceReload sorgt
/// wie bei den Geistesgaben dafür, dass geänderte JSON-Inhalte auch bei
/// bereits persistiertem State übernommen werden.
class LoadFeedbackQuestionnaire extends FeedbackEvent {
  final String locale;

  const LoadFeedbackQuestionnaire({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class UpdateFeedbackAnswer extends FeedbackEvent {
  final String questionId;
  final Object value;

  const UpdateFeedbackAnswer(this.questionId, this.value);

  @override
  List<Object?> get props => [questionId, value];
}
