part of 'spiritual_gifts_bloc.dart';

/// Which score to rank/sort gifts by in the result view (#42): the
/// self-assessment alone, the external "Referenz" average alone, or the
/// blended 50/50 score.
enum GiftScoreMetric { self, reference, blended }

class SpiritualGiftsState extends Equatable {
  final List<SpiritualGift> gifts;
  final Map<String, int> answers; // questionId -> score (0-5)
  final List<String> questionOrder; // Liste der IDs in zufälliger Reihenfolge
  final int currentQuestionIndex;
  final String? currentSessionId;
  final Map<String, List<String>> takeaways;

  /// External "Referenz" (R) assessments (#42), keyed by assessmentId so
  /// multiple references don't overwrite each other. Each entry is that
  /// reviewer's questionId -> score (0-5) map for the R-type questions only.
  final Map<String, Map<String, int>> referenceAnswers;

  /// Optional display label per assessmentId (e.g. a name the reviewer
  /// entered), purely local - never shared back out.
  final Map<String, String> referenceLabels;

  /// assessmentIds this device has issued a "Referenz" invite for (#70) -
  /// the allowlist a gift-reference-result import is checked against, so an
  /// accidentally-opened result link that was never invited by this device
  /// (e.g. one of two people's exchanged links being mixed up) is rejected
  /// instead of silently merged in.
  final Set<String> issuedReferenceInviteIds;

  const SpiritualGiftsState({
    this.gifts = const [],
    this.answers = const {},
    this.questionOrder = const [],
    this.currentQuestionIndex = 0,
    this.currentSessionId,
    this.takeaways = const {},
    this.referenceAnswers = const {},
    this.referenceLabels = const {},
    this.issuedReferenceInviteIds = const {},
  });

  bool get isLoaded => gifts.isNotEmpty;

  /// General test completion: All questions answered.
  bool get isCompleted =>
      questionOrder.isNotEmpty && answers.length >= questionOrder.length;

  /// Full module completion for a specific session: the quiz is done, which
  /// determines the top gifts - the primary output of this module. Writing
  /// takeaways/reflections afterwards is a separate, later step and isn't
  /// required for the timeline checkmark (#57).
  bool isSessionCompleted(String sessionId) => isCompleted;

  double get progress => questionOrder.isEmpty
      ? 0
      : (answers.length / questionOrder.length).clamp(0.0, 1.0);

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
    Map<String, Map<String, int>>? referenceAnswers,
    Map<String, String>? referenceLabels,
    Set<String>? issuedReferenceInviteIds,
  }) {
    return SpiritualGiftsState(
      gifts: gifts ?? this.gifts,
      answers: answers ?? this.answers,
      questionOrder: questionOrder ?? this.questionOrder,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      takeaways: takeaways ?? this.takeaways,
      referenceAnswers: referenceAnswers ?? this.referenceAnswers,
      referenceLabels: referenceLabels ?? this.referenceLabels,
      issuedReferenceInviteIds:
          issuedReferenceInviteIds ?? this.issuedReferenceInviteIds,
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

  /// Whether at least one external "Referenz" (R) assessment has been
  /// imported (#42) - the result view only shows the Fremd/Gesamt columns
  /// once this is true, to avoid clutter for the common case of nobody
  /// having used the feature yet.
  bool get hasReferences => referenceAnswers.isNotEmpty;

  /// All R-type questions across all gifts, in a deterministic order
  /// (gift order as loaded, then question order within the gift) - used
  /// both for the external mini-flow and as the index basis for the compact
  /// answers= encoding on the gift-reference-result deep link.
  List<GiftQuestion> getReferenceQuestionOrder() {
    return gifts
        .expand(
          (gift) =>
              gift.questions.where((q) => q.type == QuestionType.reference),
        )
        .toList();
  }

  int _maxScore(SpiritualGift gift, bool Function(QuestionType) matches) {
    return gift.questions.where((q) => matches(q.type)).length * 5;
  }

  double? _percentFor(
    SpiritualGift gift,
    Map<String, int> answerSource,
    bool Function(QuestionType) matches,
  ) {
    final maxScore = _maxScore(gift, matches);
    if (maxScore == 0) return null;
    final raw = gift.questions
        .where((q) => matches(q.type))
        .fold<int>(0, (sum, q) => sum + (answerSource[q.id] ?? 0));
    return raw / maxScore * 100;
  }

  /// Self-assessment score for [gift] as a percentage of its max (0-100).
  double getSelfScorePercent(SpiritualGift gift) {
    return _percentFor(gift, answers, (t) => t != QuestionType.reference) ?? 0;
  }

  /// Average external "Referenz" score for [gift] across all imported
  /// assessments, as a percentage of max (0-100). Null if there are none.
  double? getReferenceMeanPercent(SpiritualGift gift) {
    if (referenceAnswers.isEmpty) return null;
    final percents = referenceAnswers.values
        .map(
          (oneReference) => _percentFor(
            gift,
            oneReference,
            (t) => t == QuestionType.reference,
          ),
        )
        .whereType<double>()
        .toList();
    if (percents.isEmpty) return null;
    return percents.reduce((a, b) => a + b) / percents.length;
  }

  /// Blended score for [gift]: half self-assessment, half the average of
  /// all external references (if any exist) - both normalized to percent
  /// first, since self has far more questions (and thus a higher raw max)
  /// than a single Referenz assessment.
  double getBlendedScorePercent(SpiritualGift gift) {
    final selfPercent = getSelfScorePercent(gift);
    final referencePercent = getReferenceMeanPercent(gift);
    if (referencePercent == null) return selfPercent;
    return 0.5 * selfPercent + 0.5 * referencePercent;
  }

  double _scoreForMetric(SpiritualGift gift, GiftScoreMetric metric) {
    switch (metric) {
      case GiftScoreMetric.self:
        return getSelfScorePercent(gift);
      case GiftScoreMetric.reference:
        return getReferenceMeanPercent(gift) ?? 0;
      case GiftScoreMetric.blended:
        return getBlendedScorePercent(gift);
    }
  }

  /// Gifts ranked by the chosen [metric] (#42) - the sort control in the
  /// result view switches between these.
  List<SpiritualGift> getRankedGiftsByMetric(GiftScoreMetric metric) {
    final sortedGifts = List<SpiritualGift>.from(gifts);
    sortedGifts.sort((a, b) {
      final scoreA = _scoreForMetric(a, metric);
      final scoreB = _scoreForMetric(b, metric);
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
      'referenceAnswers': referenceAnswers,
      'referenceLabels': referenceLabels,
      'issuedReferenceInviteIds': issuedReferenceInviteIds.toList(),
    };
  }

  factory SpiritualGiftsState.fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState(
      gifts: (json['gifts'] as List? ?? [])
          .map((g) => SpiritualGift.fromJson(g as Map<String, dynamic>))
          .toList(),
      answers: Map<String, int>.from(json['answers'] ?? {}),
      questionOrder: List<String>.from(json['questionOrder'] ?? []),
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
      currentSessionId: json['currentSessionId'] as String?,
      takeaways:
          (json['takeaways'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v as List)),
          ) ??
          const {},
      referenceAnswers:
          (json['referenceAnswers'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, Map<String, int>.from(v as Map)),
          ) ??
          const {},
      referenceLabels:
          (json['referenceLabels'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          const {},
      issuedReferenceInviteIds: Set<String>.from(
        json['issuedReferenceInviteIds'] ?? const [],
      ),
    );
  }

  @override
  List<Object?> get props => [
    gifts,
    answers,
    questionOrder,
    currentQuestionIndex,
    currentSessionId,
    takeaways,
    referenceAnswers,
    referenceLabels,
    issuedReferenceInviteIds,
  ];
}
