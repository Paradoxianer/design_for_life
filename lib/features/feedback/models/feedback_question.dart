import 'package:equatable/equatable.dart';

enum FeedbackQuestionType { scale, text }

class FeedbackQuestion extends Equatable {
  final String id;
  final FeedbackQuestionType type;
  final String label;

  const FeedbackQuestion({required this.id, required this.type, required this.label});

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type == FeedbackQuestionType.text ? 'text' : 'scale',
        'label': label,
      };

  factory FeedbackQuestion.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestion(
      id: json['id'] as String,
      type: json['type'] == 'text' ? FeedbackQuestionType.text : FeedbackQuestionType.scale,
      label: json['label'] as String,
    );
  }

  @override
  List<Object?> get props => [id, type, label];
}

class FeedbackCategory extends Equatable {
  final String id;
  final String title;
  final List<FeedbackQuestion> questions;

  const FeedbackCategory({required this.id, required this.title, required this.questions});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  factory FeedbackCategory.fromJson(Map<String, dynamic> json) {
    return FeedbackCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List? ?? const [])
          .map((q) => FeedbackQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, title, questions];
}

/// Der komplette Feedback-Fragebogen, geladen aus
/// `assets/data/feedback_questions_<locale>.json` (#7) statt hartkodierter
/// Felder - so kann das Fragenset geändert werden, ohne den Code anzufassen.
class FeedbackQuestionnaire extends Equatable {
  final List<String> scaleLabels;
  final List<FeedbackCategory> categories;

  const FeedbackQuestionnaire({this.scaleLabels = const [], this.categories = const []});

  static const empty = FeedbackQuestionnaire();

  List<FeedbackQuestion> get allQuestions => categories.expand((c) => c.questions).toList();

  List<FeedbackQuestion> get scaleQuestions =>
      allQuestions.where((q) => q.type == FeedbackQuestionType.scale).toList();

  Map<String, dynamic> toJson() => {
        'scaleLabels': scaleLabels,
        'categories': categories.map((c) => c.toJson()).toList(),
      };

  factory FeedbackQuestionnaire.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestionnaire(
      scaleLabels: (json['scaleLabels'] as List? ?? const []).cast<String>(),
      categories: (json['categories'] as List? ?? const [])
          .map((c) => FeedbackCategory.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [scaleLabels, categories];
}
