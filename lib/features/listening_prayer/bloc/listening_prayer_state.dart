import 'package:equatable/equatable.dart';
import '../models/prayer_impression.dart';

class ListeningPrayerState extends Equatable {
  final Map<String, List<PrayerImpression>> impressions;
  final Map<String, List<String>> highlights;

  const ListeningPrayerState({
    this.impressions = const {},
    this.highlights = const {},
  });

  @override
  List<Object?> get props => [impressions, highlights];

  ListeningPrayerState copyWith({
    Map<String, List<PrayerImpression>>? impressions,
    Map<String, List<String>>? highlights,
  }) {
    return ListeningPrayerState(
      impressions: impressions ?? this.impressions,
      highlights: highlights ?? this.highlights,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'impressions': impressions.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      'highlights': highlights,
    };
  }

  factory ListeningPrayerState.fromJson(Map<String, dynamic> json) {
    return ListeningPrayerState(
      impressions: (json['impressions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => PrayerImpression.fromJson(e)).toList(),
        ),
      ),
      highlights: (json['highlights'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }
}
