import 'package:equatable/equatable.dart';

class PrayerImpression extends Equatable {
  final String id;
  final String text;
  final String? imagePath;
  final String? authorName; // Name der Person, die den Eindruck hatte
  final bool isCompleted;
  final bool isReceived;

  const PrayerImpression({
    required this.id,
    this.text = '',
    this.imagePath,
    this.authorName,
    this.isCompleted = false,
    this.isReceived = false,
  });

  PrayerImpression copyWith({
    String? text,
    String? imagePath,
    String? authorName,
    bool? isCompleted,
    bool? isReceived,
  }) {
    return PrayerImpression(
      id: id,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      authorName: authorName ?? this.authorName,
      isCompleted: isCompleted ?? this.isCompleted,
      isReceived: isReceived ?? this.isReceived,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'authorName': authorName,
      'isCompleted': isCompleted,
      'isReceived': isReceived,
    };
  }

  factory PrayerImpression.fromJson(Map<String, dynamic> json) {
    return PrayerImpression(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      authorName: json['authorName'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isReceived: json['isReceived'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, text, imagePath, authorName, isCompleted, isReceived];
}
