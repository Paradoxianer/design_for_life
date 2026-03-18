import 'package:equatable/equatable.dart';

class DflEntry extends Equatable {
  final String id;
  final String text;
  final String? imagePath;
  final String? metadata; // Für "Von: Name" oder ähnliches
  final bool isCompleted;

  const DflEntry({
    required this.id,
    this.text = '',
    this.imagePath,
    this.metadata,
    this.isCompleted = false,
  });

  DflEntry copyWith({
    String? text,
    String? imagePath,
    bool clearImagePath = false,
    String? metadata,
    bool? isCompleted,
  }) {
    return DflEntry(
      id: id,
      text: text ?? this.text,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      metadata: metadata ?? this.metadata,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'metadata': metadata,
      'isCompleted': isCompleted,
    };
  }

  factory DflEntry.fromJson(Map<String, dynamic> json) {
    return DflEntry(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      metadata: json['metadata'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, text, imagePath, metadata, isCompleted];
}
