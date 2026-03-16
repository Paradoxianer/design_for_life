import 'package:equatable/equatable.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateGoalText extends GoalsEvent {
  final String sessionId;
  final int index;
  final String text;

  const UpdateGoalText({
    required this.sessionId,
    required this.index,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, index, text];
}

class ToggleSmartCriterion extends GoalsEvent {
  final String sessionId;
  final int index;
  final String criterion; // 'S', 'M', 'A', 'R', 'T'

  const ToggleSmartCriterion({
    required this.sessionId,
    required this.index,
    required this.criterion,
  });

  @override
  List<Object?> get props => [sessionId, index, criterion];
}
