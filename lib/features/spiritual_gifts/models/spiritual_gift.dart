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

  factory SpiritualGift.fromJson(Map<String, dynamic> json) {
    return SpiritualGift(
      id: json['id'] as String,
      name: json['name'] as String,
      originalWord: json['originalWord'] as String,
      meaning: json['meaning'] as String,
      bibleReferences: List<String>.from(json['bibleReferences'] ?? []),
      description: json['description'] as String,
      questions: (json['questions'] as List)
          .map((q) => GiftQuestion.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalWord': originalWord,
      'meaning': meaning,
      'bibleReferences': bibleReferences,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

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
