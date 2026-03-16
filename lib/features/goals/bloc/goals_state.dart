part of 'goals_bloc.dart';

class GoalsState extends Equatable {
  final Map<String, List<Goal>> goals;

  const GoalsState({
    this.goals = const {},
  });

  @override
  List<Object?> get props => [goals];

  GoalsState copyWith({
    Map<String, List<Goal>>? goals,
  }) {
    return GoalsState(
      goals: goals ?? this.goals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goals': goals.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
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
    );
  }
}
