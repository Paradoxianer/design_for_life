import 'package:equatable/equatable.dart';
import '../models/prayer_impression.dart';

abstract class ListeningPrayerEvent extends Equatable {
  const ListeningPrayerEvent();

  @override
  List<Object?> get props => [];
}

class UpdateImpression extends ListeningPrayerEvent {
  final String sessionId;
  final String impressionId;
  final String text;

  const UpdateImpression({
    required this.sessionId,
    required this.impressionId,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, impressionId, text];
}

class AddImpression extends ListeningPrayerEvent {
  final String sessionId;

  const AddImpression({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class UpdateHighlight extends ListeningPrayerEvent {
  final String sessionId;
  final int index;
  final String text;

  const UpdateHighlight({
    required this.sessionId,
    required this.index,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, index, text];
}
