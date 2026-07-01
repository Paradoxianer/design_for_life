part of 'goals_bloc.dart';

class GoalsState extends Equatable {
  final Map<String, List<Goal>> goals;
  /// Goal texts mirrored as takeaways (index 0–2 = Goal 1–3).
  /// Kept in sync automatically by GoalsBloc on every UpdateGoalText event.
  final Map<String, List<String>> takeaways;

  const GoalsState({
    this.goals = const {},
    this.takeaways = const {},
  });

  /// A session is considered completed if it has at least one goal with text.
  bool isCompleted(String sessionId) {
    final sessionGoals = goals[sessionId] ?? [];
    return sessionGoals.any((g) => g.text.trim().isNotEmpty);
  }

  @override
  List<Object?> get props => [goals, takeaways];

  GoalsState copyWith({
    Map<String, List<Goal>>? goals,
    Map<String, List<String>>? takeaways,
  }) {
    return GoalsState(
      goals: goals ?? this.goals,
      takeaways: takeaways ?? this.takeaways,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goals': goals.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      'takeaways': takeaways,
    };
  }

  factory GoalsState.fromJson(Map<String, dynamic> json) {
    return GoalsState(
      goals: (json['goals'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => Goal.fromJson(e)).toList(),
        ),
      ),
      takeaways: (json['takeaways'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v)),
          ) ?? {},
    );
  }
}
