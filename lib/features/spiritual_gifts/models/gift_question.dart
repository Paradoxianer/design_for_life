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

  @override
  List<Object?> get props => [id, text, type];
}
