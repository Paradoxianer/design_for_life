import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'timeline_unlock_event.dart';
part 'timeline_unlock_state.dart';

/// Holds which locked timeline sessions have been unlocked via deep link
/// (see #49), plus optional event metadata (date/location) carried by that
/// link. Persisted so an unlock survives app restarts - the deep link is a
/// one-time "ticket", not something the user has to re-open every time.
class TimelineUnlockBloc
    extends HydratedBloc<TimelineUnlockEvent, TimelineUnlockState> {
  TimelineUnlockBloc() : super(const TimelineUnlockState()) {
    on<UnlockTimelineSessions>(_onUnlockTimelineSessions);
  }

  void _onUnlockTimelineSessions(
    UnlockTimelineSessions event,
    Emitter<TimelineUnlockState> emit,
  ) {
    final unlocked = Set<String>.from(state.unlockedSessionIds)
      ..addAll(event.sessionIds);
    emit(
      state.copyWith(
        unlockedSessionIds: unlocked,
        eventDate: event.eventDate ?? state.eventDate,
        eventLocation: event.eventLocation ?? state.eventLocation,
      ),
    );
  }

  @override
  TimelineUnlockState? fromJson(Map<String, dynamic> json) =>
      TimelineUnlockState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TimelineUnlockState state) => state.toJson();
}
