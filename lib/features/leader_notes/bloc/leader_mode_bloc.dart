import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'leader_mode_event.dart';
part 'leader_mode_state.dart';

/// Whether this device may see leader-only content (#83): the Sprechernotizen
/// from the Leiterheft, shown inside each module once unlocked.
///
/// Deliberately no settings-screen code entry - unlocked purely via a
/// `?leaderKey=...` deep link (see DeepLinkService), same local-first,
/// no-backend mechanism as the existing module-filter and gift-reference
/// links (#49, #42). [_secret] only has to keep casual participants from
/// stumbling onto it; like those other links it's not real access control
/// (the value ships inside the app bundle), so don't rely on it to protect
/// anything actually sensitive.
class LeaderModeBloc extends HydratedBloc<LeaderModeEvent, LeaderModeState> {
  static const String _secret = 'dfl-leiter-2026';

  LeaderModeBloc() : super(const LeaderModeState()) {
    on<UnlockLeaderMode>((event, emit) {
      if (event.key == _secret) {
        emit(state.copyWith(isUnlocked: true));
      }
    });
    on<LockLeaderMode>((event, emit) {
      emit(state.copyWith(isUnlocked: false));
    });
  }

  @override
  LeaderModeState? fromJson(Map<String, dynamic> json) =>
      LeaderModeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(LeaderModeState state) => state.toJson();
}
