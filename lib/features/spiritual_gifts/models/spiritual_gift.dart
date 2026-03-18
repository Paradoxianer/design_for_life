import 'package:equatable/equatable.dart';
import 'gift_question.dart';

class SpiritualGift extends Equatable {
  final String id;
  final String name;
  final String originalWord;
  final String meaning;
  final List<String> bibleReferences;
  final String description;
  final List<GiftQuestion> questions;

  const SpiritualGift({
    required this.id,
    required this.name,
    required this.originalWord,
    required this.meaning,
    required this.bibleReferences,
    required this.description,
    required this.questions,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        originalWord,
        meaning,
        bibleReferences,
        description,
        questions,
      ];
}
