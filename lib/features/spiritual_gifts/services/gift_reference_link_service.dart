import '../models/gift_question.dart';

/// Builds and parses the two deep links that make up the external
/// "Referenz" (R) assessment flow (#42):
///
/// - Invite: `dfl://open?flow=gift-reference&assessmentId=...`
/// - Result: `dfl://open?flow=gift-reference-result&assessmentId=...
///   &answers=count:digits&label=...`
///
/// There is no backend (see #49's design notes), so the reviewer's answers
/// have to travel entirely inside the result link itself. Answers are
/// encoded as one digit (0-5) per question, in the deterministic order the
/// questions were presented in (see SpiritualGiftsState.
/// getReferenceQuestionOrder) - far more compact than JSON/base64, and
/// still plain ASCII so no extra encoding step is needed. The leading
/// `count:` prefix is a cheap guard against decoding against a mismatched
/// question set (e.g. the gifts data changed between invite and import).
class GiftReferenceLinkService {
  const GiftReferenceLinkService._();

  static String buildInviteLink(String assessmentId) {
    return Uri(
      scheme: 'dfl',
      host: 'open',
      queryParameters: {'flow': 'gift-reference', 'assessmentId': assessmentId},
    ).toString();
  }

  static String buildResultLink({
    required String assessmentId,
    required List<GiftQuestion> questionOrder,
    required Map<String, int> answers,
    String? label,
  }) {
    return Uri(
      scheme: 'dfl',
      host: 'open',
      queryParameters: {
        'flow': 'gift-reference-result',
        'assessmentId': assessmentId,
        'answers': encodeAnswers(questionOrder, answers),
        if (label != null && label.isNotEmpty) 'label': label,
      },
    ).toString();
  }

  static String encodeAnswers(
    List<GiftQuestion> questionOrder,
    Map<String, int> answers,
  ) {
    final digits = questionOrder.map((q) {
      final score = answers[q.id];
      return (score == null || score < 0 || score > 5) ? 'x' : score.toString();
    }).join();
    return '${questionOrder.length}:$digits';
  }

  /// Returns null if the payload is malformed or its question count doesn't
  /// match [questionOrder] - a sign the link was generated against a
  /// different app/data version, so it's safer to reject than guess.
  static Map<String, int>? decodeAnswers(
    String payload,
    List<GiftQuestion> questionOrder,
  ) {
    final separatorIndex = payload.indexOf(':');
    if (separatorIndex == -1) return null;

    final count = int.tryParse(payload.substring(0, separatorIndex));
    final digits = payload.substring(separatorIndex + 1);
    if (count == null ||
        count != questionOrder.length ||
        digits.length != count) {
      return null;
    }

    final answers = <String, int>{};
    for (var i = 0; i < questionOrder.length; i++) {
      final digit = digits[i];
      if (digit == 'x') continue;
      final score = int.tryParse(digit);
      if (score == null || score < 0 || score > 5) return null;
      answers[questionOrder[i].id] = score;
    }
    return answers;
  }
}
