import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/models/gift_question.dart';
import 'package:design_for_life/features/spiritual_gifts/models/spiritual_gift.dart';

SpiritualGift _gift(String id) {
  return SpiritualGift(
    id: id,
    name: id,
    originalWord: '',
    meaning: '',
    bibleReferences: const [],
    description: '',
    questions: [
      GiftQuestion(id: '${id}_e1', text: '', type: QuestionType.experience),
      GiftQuestion(id: '${id}_e2', text: '', type: QuestionType.experience),
      GiftQuestion(id: '${id}_e3', text: '', type: QuestionType.experience),
      GiftQuestion(id: '${id}_n1', text: '', type: QuestionType.nature),
      GiftQuestion(id: '${id}_n2', text: '', type: QuestionType.nature),
      GiftQuestion(id: '${id}_f1', text: '', type: QuestionType.feedback),
      GiftQuestion(id: '${id}_f2', text: '', type: QuestionType.feedback),
      GiftQuestion(id: '${id}_r1', text: '', type: QuestionType.reference),
      GiftQuestion(id: '${id}_r2', text: '', type: QuestionType.reference),
    ],
  );
}

void main() {
  final gift = _gift('G01');

  test(
    'self score percent is 100 when every non-reference question scores max',
    () {
      final state = SpiritualGiftsState(
        gifts: [gift],
        answers: const {
          'G01_e1': 5,
          'G01_e2': 5,
          'G01_e3': 5,
          'G01_n1': 5,
          'G01_n2': 5,
          'G01_f1': 5,
          'G01_f2': 5,
        },
      );

      expect(state.getSelfScorePercent(gift), 100);
    },
  );

  test('reference mean is null with no imported references', () {
    final state = SpiritualGiftsState(gifts: [gift]);
    expect(state.getReferenceMeanPercent(gift), isNull);
    expect(state.hasReferences, isFalse);
    expect(state.getBlendedScorePercent(gift), state.getSelfScorePercent(gift));
  });

  test('averages multiple references before blending 50/50 with self', () {
    // Self: 20/35 -> ~57.1%
    final state = SpiritualGiftsState(
      gifts: [gift],
      answers: const {'G01_e1': 5, 'G01_e2': 5, 'G01_n1': 5, 'G01_f1': 5},
      referenceAnswers: const {
        'ref_1': {'G01_r1': 5, 'G01_r2': 5}, // 100%
        'ref_2': {'G01_r1': 0, 'G01_r2': 0}, // 0%
      },
    );

    // Self: 20 points / 35 max = 57.142...%
    final selfPercent = state.getSelfScorePercent(gift);
    expect(selfPercent, closeTo(20 / 35 * 100, 0.001));

    // Reference mean: (100 + 0) / 2 = 50%
    expect(state.getReferenceMeanPercent(gift), 50);

    // Blended: 0.5 * self + 0.5 * 50
    expect(
      state.getBlendedScorePercent(gift),
      closeTo(0.5 * selfPercent + 25, 0.001),
    );
  });

  test('reference answers do not leak into the self score', () {
    final state = SpiritualGiftsState(
      gifts: [gift],
      answers: const {},
      referenceAnswers: const {
        'ref_1': {'G01_r1': 5, 'G01_r2': 5},
      },
    );

    expect(state.getSelfScorePercent(gift), 0);
  });

  test(
    'getReferenceQuestionOrder returns only reference-type questions in gift order',
    () {
      final state = SpiritualGiftsState(gifts: [gift, _gift('G02')]);
      final order = state.getReferenceQuestionOrder();

      expect(order.map((q) => q.id), ['G01_r1', 'G01_r2', 'G02_r1', 'G02_r2']);
      expect(order.every((q) => q.type == QuestionType.reference), isTrue);
    },
  );

  test('getRankedGiftsByMetric sorts by the requested metric', () {
    final giftA = _gift('A');
    final giftB = _gift('B');
    final state = SpiritualGiftsState(
      gifts: [giftA, giftB],
      answers: const {'A_e1': 5, 'A_e2': 5, 'A_n1': 5, 'A_f1': 5, 'B_e1': 0},
      referenceAnswers: const {
        'ref_1': {'A_r1': 0, 'A_r2': 0, 'B_r1': 5, 'B_r2': 5},
      },
    );

    expect(state.getRankedGiftsByMetric(GiftScoreMetric.self).first.id, 'A');
    expect(
      state.getRankedGiftsByMetric(GiftScoreMetric.reference).first.id,
      'B',
    );
  });
}
