part of 'timeline_module_filter_bloc.dart';

class TimelineModuleFilterState extends Equatable {
  /// Null means "no restriction" - the full timeline shows as normal. Once
  /// set (via a deep link), only sessions whose id is in this set are shown.
  final Set<String>? allowedSessionIds;
  final String? eventDate;
  final String? eventLocation;

  const TimelineModuleFilterState({
    this.allowedSessionIds,
    this.eventDate,
    this.eventLocation,
  });

  TimelineModuleFilterState copyWith({
    Set<String>? allowedSessionIds,
    String? eventDate,
    String? eventLocation,
  }) {
    return TimelineModuleFilterState(
      allowedSessionIds: allowedSessionIds ?? this.allowedSessionIds,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowedSessionIds': allowedSessionIds?.toList(),
      'eventDate': eventDate,
      'eventLocation': eventLocation,
    };
  }

  factory TimelineModuleFilterState.fromJson(Map<String, dynamic> json) {
    final rawAllowed = json['allowedSessionIds'] as List?;
    return TimelineModuleFilterState(
      allowedSessionIds: rawAllowed?.cast<String>().toSet(),
      eventDate: json['eventDate'] as String?,
      eventLocation: json['eventLocation'] as String?,
    );
  }

  @override
  List<Object?> get props => [allowedSessionIds, eventDate, eventLocation];
}
