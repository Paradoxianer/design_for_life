part of 'spiritual_gifts_bloc.dart';

class SpiritualGiftsState extends Equatable {
  final List<SpiritualGift> gifts;
  final Map<String, int> answers; // questionId -> score (0-5)
  final List<String> questionOrder; // Liste der IDs in zufälliger Reihenfolge
  final int currentQuestionIndex;

  const SpiritualGiftsState({
    this.gifts = const [],
    this.answers = const {},
    this.questionOrder = const [],
    this.currentQuestionIndex = 0,
  });

  bool get isLoaded => gifts.isNotEmpty;
  bool get isCompleted => questionOrder.isNotEmpty && currentQuestionIndex >= questionOrder.length;
  double get progress => questionOrder.isEmpty ? 0 : currentQuestionIndex / questionOrder.length;

  SpiritualGiftsState copyWith({
    List<SpiritualGift>? gifts,
    Map<String, int>? answers,
    List<String>? questionOrder,
    int? currentQuestionIndex,
  }) {
    return SpiritualGiftsState(
      gifts: gifts ?? this.gifts,
      answers: answers ?? this.answers,
      questionOrder: questionOrder ?? this.questionOrder,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }

  // Berechnet die Summe pro Gabe basierend auf den Antworten
  Map<String, int> getScoresPerGift() {
    final scores = <String, int>{};
    for (final gift in gifts) {
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
    final sortedGifts = List<SpiritualGift>.from(gifts);
    sortedGifts.sort((a, b) {
      final scoreA = scores[a.id] ?? 0;
      final scoreB = scores[b.id] ?? 0;
      if (scoreA == scoreB) return a.name.compareTo(b.name);
      return scoreB.compareTo(scoreA); // Absteigend
    });
    return sortedGifts;
  }

  Map<String, dynamic> toJson() {
    return {
      'gifts': gifts.map((g) => g.toJson()).toList(),
      'answers': answers,
      'questionOrder': questionOrder,
      'currentQuestionIndex': currentQuestionIndex,
    };
  }

  factory SpiritualGiftsState.fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState(
      gifts: (json['gifts'] as List? ?? []).map((g) => SpiritualGift.fromJson(g)).toList(),
      answers: Map<String, int>.from(json['answers'] ?? {}),
      questionOrder: List<String>.from(json['questionOrder'] ?? []),
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [gifts, answers, questionOrder, currentQuestionIndex];
}
