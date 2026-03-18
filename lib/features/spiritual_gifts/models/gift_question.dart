import 'package:equatable/equatable.dart';

enum QuestionType {
  experience, // 'E' in CSV
  nature,     // 'N' in CSV
  feedback    // 'F' in CSV
}

class GiftQuestion extends Equatable {
  final String id;
  final String text;
  final QuestionType type;

  const GiftQuestion({
    required this.id,
    required this.text,
    required this.type,
  });

  factory GiftQuestion.fromJson(Map<String, dynamic> json) {
    return GiftQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => QuestionType.experience,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
    };
  }

  @override
  List<Object?> get props => [id, text, type];
}
