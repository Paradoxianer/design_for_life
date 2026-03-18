part of 'spiritual_gifts_bloc.dart';

class SpiritualGiftsState extends Equatable {
  final Map<String, int> answers; // questionId -> score (0-3)

  const SpiritualGiftsState({
    this.answers = const {},
  });

  SpiritualGiftsState copyWith({
    Map<String, int>? answers,
  }) {
    return SpiritualGiftsState(
      answers: answers ?? this.answers,
    );
  }

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

  List<SpiritualGift> getTopGifts(int count) {
    final scores = getScoresPerGift();
    final sortedIds = scores.keys.toList()
      ..sort((a, b) => scores[b]!.compareTo(scores[a]!));
    
    return sortedIds
        .take(count)
        .map((id) => GiftData.allGifts.firstWhere((g) => g.id == id))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'answers': answers,
    };
  }

  factory SpiritualGiftsState.fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState(
      answers: Map<String, int>.from(json['answers'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [answers];
}
