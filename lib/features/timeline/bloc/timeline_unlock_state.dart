part of 'timeline_unlock_bloc.dart';

class TimelineUnlockState extends Equatable {
  final Set<String> unlockedSessionIds;
  final String? eventDate;
  final String? eventLocation;

  const TimelineUnlockState({
    this.unlockedSessionIds = const {},
    this.eventDate,
    this.eventLocation,
  });

  TimelineUnlockState copyWith({
    Set<String>? unlockedSessionIds,
    String? eventDate,
    String? eventLocation,
  }) {
    return TimelineUnlockState(
      unlockedSessionIds: unlockedSessionIds ?? this.unlockedSessionIds,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unlockedSessionIds': unlockedSessionIds.toList(),
      'eventDate': eventDate,
      'eventLocation': eventLocation,
    };
  }

  factory TimelineUnlockState.fromJson(Map<String, dynamic> json) {
    return TimelineUnlockState(
      unlockedSessionIds: ((json['unlockedSessionIds'] as List?) ?? const [])
          .cast<String>()
          .toSet(),
      eventDate: json['eventDate'] as String?,
      eventLocation: json['eventLocation'] as String?,
    );
  }

  @override
  List<Object?> get props => [unlockedSessionIds, eventDate, eventLocation];
}
