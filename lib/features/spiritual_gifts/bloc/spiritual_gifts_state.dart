part of 'spiritual_gifts_bloc.dart';

class SpiritualGiftsState extends Equatable {
  final Map<String, int> answers; // questionId -> score (0-5)
  final List<String> questionOrder; // Liste der IDs in zufälliger Reihenfolge
  final int currentQuestionIndex;

  const SpiritualGiftsState({
    this.answers = const {},
    this.questionOrder = const [],
    this.currentQuestionIndex = 0,
  });

  bool get isCompleted => questionOrder.isNotEmpty && currentQuestionIndex >= questionOrder.length;
  double get progress => questionOrder.isEmpty ? 0 : currentQuestionIndex / questionOrder.length;

  SpiritualGiftsState copyWith({
    Map<String, int>? answers,
    List<String>? questionOrder,
    int? currentQuestionIndex,
  }) {
    return SpiritualGiftsState(
      answers: answers ?? this.answers,
      questionOrder: questionOrder ?? this.questionOrder,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }

  // Berechnet die Summe pro Gabe basierend auf den Antworten
  Map<String, int> getScoresPerGift() {
    final scores = <String, int>{};
    for (final gift in GiftData.allGifts) {
      int total = 0;
      for (final question in gift.questions) {
        total += answers[question.id] ?? 0;
      }
      scores[gift.id] = total;
    }
    return scores;
  }

  // Liefert alle Gaben sortiert nach Punktzahl
  List<SpiritualGift> getRankedGifts() {
    final scores = getScoresPerGift();
    final sortedGifts = List<SpiritualGift>.from(GiftData.allGifts);
    sortedGifts.sort((a, b) {
      final scoreA = scores[a.id] ?? 0;
      final scoreB = scores[b.id] ?? 0;
      return scoreB.compareTo(scoreA); // Absteigend
    });
    return sortedGifts;
  }

  Map<String, dynamic> toJson() {
    return {
      'answers': answers,
      'questionOrder': questionOrder,
      'currentQuestionIndex': currentQuestionIndex,
    };
  }

  factory SpiritualGiftsState.fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState(
      answers: Map<String, int>.from(json['answers'] ?? {}),
      questionOrder: List<String>.from(json['questionOrder'] ?? []),
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [answers, questionOrder, currentQuestionIndex];
}
