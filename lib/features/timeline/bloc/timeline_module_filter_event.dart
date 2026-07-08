part of 'timeline_module_filter_bloc.dart';

abstract class TimelineModuleFilterEvent extends Equatable {
  const TimelineModuleFilterEvent();

  @override
  List<Object?> get props => [];
}

/// Replaces the visible-modules restriction with exactly [sessionIds] -
/// each new deep link fully replaces the previous list, it does not merge
/// with it.
class SetAllowedModules extends TimelineModuleFilterEvent {
  final List<String> sessionIds;
  final String? eventDate;
  final String? eventLocation;

  const SetAllowedModules(
    this.sessionIds, {
    this.eventDate,
    this.eventLocation,
  });

  @override
  List<Object?> get props => [sessionIds, eventDate, eventLocation];
}
