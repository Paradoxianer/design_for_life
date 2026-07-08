import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/core/services/deep_link_service.dart';

void main() {
  test('parses modules, date and location from a dfl:// open link', () {
    final action = DeepLinkService.parse(
      Uri.parse(
        'dfl://open?modules=session_1,session_3&date=2026-08-01&location=Tagungshaus',
      ),
    );

    expect(action, isA<UnlockModulesAction>());
    final unlock = action as UnlockModulesAction;
    expect(unlock.sessionIds, ['session_1', 'session_3']);
    expect(unlock.eventDate, '2026-08-01');
    expect(unlock.eventLocation, 'Tagungshaus');
  });

  test('trims whitespace and drops empty module ids', () {
    final action = DeepLinkService.parse(
      Uri.parse('dfl://open?modules=session_1,%20,%20session_2'),
    );

    expect(action, isA<UnlockModulesAction>());
    expect((action as UnlockModulesAction).sessionIds, [
      'session_1',
      'session_2',
    ]);
  });

  test('date and location are optional', () {
    final action = DeepLinkService.parse(
      Uri.parse('dfl://open?modules=session_1'),
    );

    expect(action, isA<UnlockModulesAction>());
    final unlock = action as UnlockModulesAction;
    expect(unlock.eventDate, isNull);
    expect(unlock.eventLocation, isNull);
  });

  test('ignores links with a different scheme', () {
    expect(
      DeepLinkService.parse(
        Uri.parse('https://example.com/open?modules=session_1'),
      ),
      isNull,
    );
  });

  test('ignores dfl:// links without a modules parameter', () {
    expect(
      DeepLinkService.parse(Uri.parse('dfl://open?date=2026-08-01')),
      isNull,
    );
  });

  test('ignores dfl:// links with an empty modules parameter', () {
    expect(DeepLinkService.parse(Uri.parse('dfl://open?modules=')), isNull);
  });

  test('parses a gift-reference invite link', () {
    final action = DeepLinkService.parse(
      Uri.parse('dfl://open?flow=gift-reference&assessmentId=ref_123'),
    );

    expect(action, isA<GiftReferenceInviteAction>());
    expect((action as GiftReferenceInviteAction).assessmentId, 'ref_123');
  });

  test('ignores a gift-reference invite link without an assessmentId', () {
    expect(
      DeepLinkService.parse(Uri.parse('dfl://open?flow=gift-reference')),
      isNull,
    );
  });

  test(
    'parses a gift-reference-result link with its raw answers payload and optional label',
    () {
      final action = DeepLinkService.parse(
        Uri.parse(
          'dfl://open?flow=gift-reference-result&assessmentId=ref_123&answers=3:503&label=Anna',
        ),
      );

      expect(action, isA<GiftReferenceResultAction>());
      final result = action as GiftReferenceResultAction;
      expect(result.assessmentId, 'ref_123');
      expect(result.answersPayload, '3:503');
      expect(result.label, 'Anna');
    },
  );

  test('gift-reference-result label is optional', () {
    final action = DeepLinkService.parse(
      Uri.parse(
        'dfl://open?flow=gift-reference-result&assessmentId=ref_123&answers=3:503',
      ),
    );
    expect((action as GiftReferenceResultAction).label, isNull);
  });

  test(
    'ignores a gift-reference-result link missing assessmentId or answers',
    () {
      expect(
        DeepLinkService.parse(
          Uri.parse('dfl://open?flow=gift-reference-result&answers=3:503'),
        ),
        isNull,
      );
      expect(
        DeepLinkService.parse(
          Uri.parse(
            'dfl://open?flow=gift-reference-result&assessmentId=ref_123',
          ),
        ),
        isNull,
      );
    },
  );
}
