part of 'leader_mode_bloc.dart';

class LeaderModeState extends Equatable {
  final bool isUnlocked;

  const LeaderModeState({this.isUnlocked = false});

  LeaderModeState copyWith({bool? isUnlocked}) {
    return LeaderModeState(isUnlocked: isUnlocked ?? this.isUnlocked);
  }

  Map<String, dynamic> toJson() => {'isUnlocked': isUnlocked};

  factory LeaderModeState.fromJson(Map<String, dynamic> json) {
    return LeaderModeState(isUnlocked: json['isUnlocked'] as bool? ?? false);
  }

  @override
  List<Object?> get props => [isUnlocked];
}
