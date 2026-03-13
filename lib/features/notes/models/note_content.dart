import 'package:equatable/equatable.dart';

class NoteContent extends Equatable {
  final String sessionId;
  final String text;
  final List<String> takeaways;

  const NoteContent({
    required this.sessionId,
    this.text = '',
    this.takeaways = const ['', '', ''],
  });

  NoteContent copyWith({
    String? text,
    List<String>? takeaways,
  }) {
    return NoteContent(
      sessionId: sessionId,
      text: text ?? this.text,
      takeaways: takeaways ?? this.takeaways,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'text': text,
      'takeaways': takeaways,
    };
  }

  factory NoteContent.fromJson(Map<String, dynamic> json) {
    return NoteContent(
      sessionId: json['sessionId'] as String,
      text: json['text'] as String? ?? '',
      takeaways: (json['takeaways'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const ['', '', ''],
    );
  }

  @override
  List<Object?> get props => [sessionId, text, takeaways];
}
