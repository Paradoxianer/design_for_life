part of 'spiritual_gifts_bloc.dart';

class SpiritualGiftsState extends Equatable {
  final List<SpiritualGift> gifts;
  final Map<String, int> answers; // questionId -> score (0-5)
  final List<String> questionOrder; // Liste der IDs in zufälliger Reihenfolge
  final int currentQuestionIndex;
  final String? currentSessionId;
  final Map<String, List<String>> takeaways;

  const SpiritualGiftsState({
    this.gifts = const [],
    this.answers = const {},
    this.questionOrder = const [],
    this.currentQuestionIndex = 0,
    this.currentSessionId,
    this.takeaways = const {},
  });

  bool get isLoaded => gifts.isNotEmpty;
  
  /// General test completion: All questions answered.
  bool get isCompleted => questionOrder.isNotEmpty && answers.length >= questionOrder.length;

  /// Full module completion for a specific session: Test done AND takeaways set.
  bool isSessionCompleted(String sessionId) {
    final allAnswered = isCompleted;
    final sessionTakeaways = takeaways[sessionId] ?? [];
    final hasTakeaways = sessionTakeaways.length >= 3 && 
                         sessionTakeaways.take(3).every((t) => t.trim().isNotEmpty);
    
    return allAnswered && hasTakeaways;
  }

  double get progress => questionOrder.isEmpty ? 0 : (answers.length / questionOrder.length).clamp(0.0, 1.0);

  int get firstUnansweredIndex {
    for (int i = 0; i < questionOrder.length; i++) {
      if (!answers.containsKey(questionOrder[i])) return i;
    }
    return questionOrder.isEmpty ? 0 : questionOrder.length - 1;
  }

  SpiritualGiftsState copyWith({
    List<SpiritualGift>? gifts,
    Map<String, int>? answers,
    List<String>? questionOrder,
    int? currentQuestionIndex,
    String? currentSessionId,
    Map<String, List<String>>? takeaways,
  }) {
    return SpiritualGiftsState(
      gifts: gifts ?? this.gifts,
      answers: answers ?? this.answers,
      questionOrder: questionOrder ?? this.questionOrder,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      takeaways: takeaways ?? this.takeaways,
    );
  }

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

  List<SpiritualGift> getRankedGifts() {
    final scores = getScoresPerGift();
    final sortedGifts = List<SpiritualGift>.from(gifts);
    sortedGifts.sort((a, b) {
      final scoreA = scores[a.id] ?? 0;
      final scoreB = scores[b.id] ?? 0;
      if (scoreA == scoreB) return a.name.compareTo(b.name);
      return scoreB.compareTo(scoreA);
    });
    return sortedGifts;
  }

  Map<String, dynamic> toJson() {
    return {
      'gifts': gifts.map((g) => g.toJson()).toList(),
      'answers': answers,
      'questionOrder': questionOrder,
      'currentQuestionIndex': currentQuestionIndex,
      'currentSessionId': currentSessionId,
      'takeaways': takeaways,
    };
  }

  factory SpiritualGiftsState.fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState(
      gifts: (json['gifts'] as List? ?? []).map((g) => SpiritualGift.fromJson(g as Map<String, dynamic>)).toList(),
      answers: Map<String, int>.from(json['answers'] ?? {}),
      questionOrder: List<String>.from(json['questionOrder'] ?? []),
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
      currentSessionId: json['currentSessionId'] as String?,
      takeaways: (json['takeaways'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v as List)),
          ) ??
          const {},
    );
  }

  @override
  List<Object?> get props => [gifts, answers, questionOrder, currentQuestionIndex, currentSessionId, takeaways];
}
