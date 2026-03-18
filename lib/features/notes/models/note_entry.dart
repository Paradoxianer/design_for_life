import 'package:equatable/equatable.dart';

class NoteEntry extends Equatable {
  final String id;
  final String text;
  final String? imagePath;
  final bool isCompleted;

  const NoteEntry({
    required this.id,
    this.text = '',
    this.imagePath,
    this.isCompleted = false,
  });

  NoteEntry copyWith({
    String? text,
    String? imagePath,
    bool? isCompleted,
  }) {
    return NoteEntry(
      id: id,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'isCompleted': isCompleted,
    };
  }

  factory NoteEntry.fromJson(Map<String, dynamic> json) {
    return NoteEntry(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, text, imagePath, isCompleted];
}
