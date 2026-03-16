import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/goal.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends HydratedBloc<GoalsEvent, GoalsState> {
  GoalsBloc() : super(const GoalsState()) {
    on<UpdateGoalText>(_onUpdateGoalText);
    on<ToggleSmartCriterion>(_onToggleSmartCriterion);
  }

  void _onUpdateGoalText(UpdateGoalText event, Emitter<GoalsState> emit) {
    final sessionGoals = List<Goal>.from(
      state.goals[event.sessionId] ?? const [Goal(), Goal(), Goal()],
    );

    if (event.index < sessionGoals.length) {
      sessionGoals[event.index] = sessionGoals[event.index].copyWith(text: event.text);
      final newGoals = Map<String, List<Goal>>.from(state.goals);
      newGoals[event.sessionId] = sessionGoals;
      emit(state.copyWith(goals: newGoals));
    }
  }

  void _onToggleSmartCriterion(ToggleSmartCriterion event, Emitter<GoalsState> emit) {
    final sessionGoals = List<Goal>.from(
      state.goals[event.sessionId] ?? const [Goal(), Goal(), Goal()],
    );

    if (event.index < sessionGoals.length) {
      final goal = sessionGoals[event.index];
      Goal updatedGoal;

      switch (event.criterion) {
        case 'S':
          updatedGoal = goal.copyWith(isSpecific: !goal.isSpecific);
          break;
        case 'M':
          updatedGoal = goal.copyWith(isMeasurable: !goal.isMeasurable);
          break;
        case 'A':
          updatedGoal = goal.copyWith(isAchievable: !goal.isAchievable);
          break;
        case 'R':
          updatedGoal = goal.copyWith(isRelevant: !goal.isRelevant);
          break;
        case 'T':
          updatedGoal = goal.copyWith(isTimeBound: !goal.isTimeBound);
          break;
        default:
          updatedGoal = goal;
      }

      sessionGoals[event.index] = updatedGoal;
      final newGoals = Map<String, List<Goal>>.from(state.goals);
      newGoals[event.sessionId] = sessionGoals;
      emit(state.copyWith(goals: newGoals));
    }
  }

  @override
  GoalsState? fromJson(Map<String, dynamic> json) => GoalsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(GoalsState state) => state.toJson();
}
