import 'package:equatable/equatable.dart';

class PrayerImpression extends Equatable {
  final String id;
  final String text;
  final String? imagePath;
  final String? assignedTo;
  final bool isReceived;

  const PrayerImpression({
    required this.id,
    this.text = '',
    this.imagePath,
    this.assignedTo,
    this.isReceived = false,
  });

  PrayerImpression copyWith({
    String? text,
    String? imagePath,
    String? assignedTo,
    bool? isReceived,
  }) {
    return PrayerImpression(
      id: id,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      assignedTo: assignedTo ?? this.assignedTo,
      isReceived: isReceived ?? this.isReceived,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'assignedTo': assignedTo,
      'isReceived': isReceived,
    };
  }

  factory PrayerImpression.fromJson(Map<String, dynamic> json) {
    return PrayerImpression(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      assignedTo: json['assignedTo'] as String?,
      isReceived: json['isReceived'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, text, imagePath, assignedTo, isReceived];
}
