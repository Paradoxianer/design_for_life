part of 'spiritual_gifts_bloc.dart';

class SpiritualGiftsState extends Equatable {
  final List<SpiritualGift> gifts;
  final Map<String, int> answers; // questionId -> score (0-5)
  final List<String> questionOrder; // Liste der IDs in zufälliger Reihenfolge
  final int currentQuestionIndex;
  final Map<String, List<String>> takeaways; // sessionId -> list of takeaways

  const SpiritualGiftsState({
    this.gifts = const [],
    this.answers = const {},
    this.questionOrder = const [],
    this.currentQuestionIndex = 0,
    this.takeaways = const {},
  });

  bool get isLoaded => gifts.isNotEmpty;
  bool get isCompleted => questionOrder.isNotEmpty && currentQuestionIndex >= questionOrder.length;
  double get progress => questionOrder.isEmpty ? 0 : (currentQuestionIndex / questionOrder.length).clamp(0.0, 1.0);

  SpiritualGiftsState copyWith({
    List<SpiritualGift>? gifts,
    Map<String, int>? answers,
    List<String>? questionOrder,
    int? currentQuestionIndex,
    Map<String, List<String>>? takeaways,
  }) {
    return SpiritualGiftsState(
      gifts: gifts ?? this.gifts,
      answers: answers ?? this.answers,
      questionOrder: questionOrder ?? this.questionOrder,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      takeaways: takeaways ?? this.takeaways,
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
      'takeaways': takeaways,
    };
  }

  factory SpiritualGiftsState.fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState(
      gifts: (json['gifts'] as List? ?? []).map((g) => SpiritualGift.fromJson(g as Map<String, dynamic>)).toList(),
      answers: Map<String, int>.from(json['answers'] ?? {}),
      questionOrder: List<String>.from(json['questionOrder'] ?? []),
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
      takeaways: (json['takeaways'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v as List)),
          ) ??
          const {},
    );
  }

  @override
  List<Object?> get props => [gifts, answers, questionOrder, currentQuestionIndex, takeaways];
}
