part of 'timeline_unlock_bloc.dart';

abstract class TimelineUnlockEvent extends Equatable {
  const TimelineUnlockEvent();

  @override
  List<Object?> get props => [];
}

class UnlockTimelineSessions extends TimelineUnlockEvent {
  final List<String> sessionIds;
  final String? eventDate;
  final String? eventLocation;

  const UnlockTimelineSessions(
    this.sessionIds, {
    this.eventDate,
    this.eventLocation,
  });

  @override
  List<Object?> get props => [sessionIds, eventDate, eventLocation];
}
