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
}
