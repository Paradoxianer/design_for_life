import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/spiritual_gifts/models/gift_question.dart';
import 'package:design_for_life/features/spiritual_gifts/services/gift_reference_link_service.dart';

void main() {
  final questions = [
    const GiftQuestion(id: 'G01_r1', text: '', type: QuestionType.reference),
    const GiftQuestion(id: 'G01_r2', text: '', type: QuestionType.reference),
    const GiftQuestion(id: 'G02_r1', text: '', type: QuestionType.reference),
  ];

  test('round-trips answers through encode/decode', () {
    final answers = {'G01_r1': 5, 'G01_r2': 0, 'G02_r1': 3};
    final encoded = GiftReferenceLinkService.encodeAnswers(questions, answers);

    expect(encoded, '3:503');
    expect(GiftReferenceLinkService.decodeAnswers(encoded, questions), answers);
  });

  test('marks unanswered questions with x and skips them on decode', () {
    final encoded = GiftReferenceLinkService.encodeAnswers(questions, {
      'G01_r1': 2,
    });
    expect(encoded, '3:2xx');
    expect(GiftReferenceLinkService.decodeAnswers(encoded, questions), {
      'G01_r1': 2,
    });
  });

  test('rejects a payload whose count does not match the question order', () {
    expect(GiftReferenceLinkService.decodeAnswers('2:55', questions), isNull);
  });

  test('rejects malformed payloads', () {
    expect(
      GiftReferenceLinkService.decodeAnswers('not-a-payload', questions),
      isNull,
    );
    expect(GiftReferenceLinkService.decodeAnswers('3:5x', questions), isNull);
  });

  test('builds invite and result links as valid dfl:// URIs', () {
    final invite = GiftReferenceLinkService.buildInviteLink('ref_123');
    final inviteUri = Uri.parse(invite);
    expect(inviteUri.scheme, 'dfl');
    expect(inviteUri.queryParameters['flow'], 'gift-reference');
    expect(inviteUri.queryParameters['assessmentId'], 'ref_123');

    final result = GiftReferenceLinkService.buildResultLink(
      assessmentId: 'ref_123',
      questionOrder: questions,
      answers: const {'G01_r1': 5, 'G01_r2': 0, 'G02_r1': 3},
      label: 'Anna',
    );
    final resultUri = Uri.parse(result);
    expect(resultUri.queryParameters['flow'], 'gift-reference-result');
    expect(resultUri.queryParameters['answers'], '3:503');
    expect(resultUri.queryParameters['label'], 'Anna');

    final decoded = GiftReferenceLinkService.decodeAnswers(
      resultUri.queryParameters['answers']!,
      questions,
    );
    expect(decoded, const {'G01_r1': 5, 'G01_r2': 0, 'G02_r1': 3});
  });
}
