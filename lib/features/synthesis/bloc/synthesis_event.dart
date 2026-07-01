part of 'synthesis_bloc.dart';

abstract class SynthesisEvent extends Equatable {
  const SynthesisEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSynthesis extends SynthesisEvent {
  final Map<String, List<String>> sourceTakeaways;
  final bool force;

  const InitializeSynthesis({
    required this.sourceTakeaways,
    this.force = false,
  });

  @override
  List<Object?> get props => [sourceTakeaways, force];
}

class MoveSynthesisCard extends SynthesisEvent {
  final String fromColumn;
  final int fromIndex;
  final String toColumn;
  final int toIndex;

  const MoveSynthesisCard({
    required this.fromColumn,
    required this.fromIndex,
    required this.toColumn,
    required this.toIndex,
  });

  @override
  List<Object?> get props => [fromColumn, fromIndex, toColumn, toIndex];
}

class SetSynthesisCardTag extends SynthesisEvent {
  final String cardId;
  final String tag;

  const SetSynthesisCardTag(this.cardId, this.tag);

  @override
  List<Object?> get props => [cardId, tag];
}

class UpdateSynthesisTakeaway extends SynthesisEvent {
  final int index;
  final String value;

  const UpdateSynthesisTakeaway(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}
