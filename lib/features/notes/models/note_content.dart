import 'package:equatable/equatable.dart';
import 'note_entry.dart';

class NoteContent extends Equatable {
  final String sessionId;
  final List<NoteEntry> entries;
  final List<String> takeaways;

  const NoteContent({
    required this.sessionId,
    this.entries = const [],
    this.takeaways = const ['', '', ''],
  });

  NoteContent copyWith({
    List<NoteEntry>? entries,
    List<String>? takeaways,
  }) {
    return NoteContent(
      sessionId: sessionId,
      entries: entries ?? this.entries,
      takeaways: takeaways ?? this.takeaways,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'entries': entries.map((e) => e.toJson()).toList(),
      'takeaways': takeaways,
    };
  }

  factory NoteContent.fromJson(Map<String, dynamic> json) {
    return NoteContent(
      sessionId: json['sessionId'] as String,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => NoteEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      takeaways: (json['takeaways'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['', '', ''],
    );
  }

  @override
  List<Object?> get props => [sessionId, entries, takeaways];
}
