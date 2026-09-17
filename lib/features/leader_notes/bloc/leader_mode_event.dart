part of 'leader_mode_bloc.dart';

abstract class LeaderModeEvent extends Equatable {
  const LeaderModeEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched when a `?leaderKey=...` deep link arrives. Unlocking only
/// actually happens if [key] matches the bloc's own secret - see
/// [LeaderModeBloc._secret].
class UnlockLeaderMode extends LeaderModeEvent {
  final String key;

  const UnlockLeaderMode(this.key);

  @override
  List<Object?> get props => [key];
}

/// Turns leader mode back off on this device (e.g. before handing it to a
/// participant).
class LockLeaderMode extends LeaderModeEvent {
  const LockLeaderMode();
}
