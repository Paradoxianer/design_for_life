import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'timeline_module_filter_event.dart';
part 'timeline_module_filter_state.dart';

/// Restricts the timeline to a subset of sessions, set via deep link (#49).
///
/// This is deliberately not a "locking" mechanism: there's no locked
/// placeholder for hidden sessions, and no indication that other modules
/// exist at all - the goal is a stripped-down DFL where people only ever
/// see the modules they were actually assigned, e.g. for a shortened
/// weekend format. Without such a link (allowedSessionIds == null), the
/// full timeline shows as normal. Persisted so the restriction survives app
/// restarts.
class TimelineModuleFilterBloc
    extends HydratedBloc<TimelineModuleFilterEvent, TimelineModuleFilterState> {
  TimelineModuleFilterBloc() : super(const TimelineModuleFilterState()) {
    on<SetAllowedModules>(_onSetAllowedModules);
  }

  void _onSetAllowedModules(
    SetAllowedModules event,
    Emitter<TimelineModuleFilterState> emit,
  ) {
    emit(
      state.copyWith(
        allowedSessionIds: event.sessionIds.toSet(),
        eventDate: event.eventDate ?? state.eventDate,
        eventLocation: event.eventLocation ?? state.eventLocation,
      ),
    );
  }

  @override
  TimelineModuleFilterState? fromJson(Map<String, dynamic> json) =>
      TimelineModuleFilterState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TimelineModuleFilterState state) =>
      state.toJson();
}
