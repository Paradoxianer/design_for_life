import 'package:equatable/equatable.dart';

enum SessionType {
  lecture,
  groupWork,
  personalReflection,
  prayer,
  other;

  String get displayName {
    switch (this) {
      case SessionType.lecture:
        return 'Lecture';
      case SessionType.groupWork:
        return 'Group Work';
      case SessionType.personalReflection:
        return 'Personal Reflection';
      case SessionType.prayer:
        return 'Prayer';
      case SessionType.other:
        return 'Other';
    }
  }
}

enum SessionStatus {
  notStarted,
  inProgress,
  done,
  locked,
  override;
}

class DflSession extends Equatable {
  final String id;
  final String title;
  final String? description;
  final SessionType type;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? room;
  final String? groupAssignment;
  final SessionStatus status;
  final String moduleId;
  final String? moduleSessionId;

  const DflSession({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.startTime,
    this.endTime,
    this.room,
    this.groupAssignment,
    this.status = SessionStatus.notStarted,
    required this.moduleId,
    this.moduleSessionId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        startTime,
        endTime,
        room,
        groupAssignment,
        status,
        moduleId,
        moduleSessionId,
      ];
}
