import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/leader_notes/models/leader_note_block.dart';
import 'package:design_for_life/features/leader_notes/repositories/leader_notes_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and parses the real leader_notes_de.json asset', () async {
    final sessions = await LeaderNotesRepository().loadSessions('de');

    expect(sessions, contains('session_1'));
    final session1 = sessions['session_1']!;
    expect(session1.sessionTitle, contains('Einheit Eins'));
    expect(session1.sections, isNotEmpty);

    // Every block type actually used in the source content parses into the
    // right Dart type, not just "didn't crash".
    final allBlocks = session1.sections.expand((s) => s.blocks).toList();
    expect(allBlocks.whereType<LeaderNoteSubheading>(), isNotEmpty);
    expect(allBlocks.whereType<LeaderNoteParagraph>(), isNotEmpty);
    expect(allBlocks.whereType<LeaderNoteBulletList>(), isNotEmpty);
    expect(allBlocks.whereType<LeaderNoteNumberedList>(), isNotEmpty);
    expect(allBlocks.whereType<LeaderNoteQuote>(), isNotEmpty);
    expect(allBlocks.whereType<LeaderNoteQuestion>(), isNotEmpty);
    expect(allBlocks.whereType<LeaderNoteVideo>(), isNotEmpty);

    final firstQuote = allBlocks.whereType<LeaderNoteQuote>().first;
    expect(firstQuote.reference, isNotEmpty);
    expect(firstQuote.text, isNotEmpty);
  });

  test(
    'falls back to German for a locale with no leader notes file yet',
    () async {
      final sessions = await LeaderNotesRepository().loadSessions('en');

      // 'en' has no leader_notes_en.json yet - same fallback rule as
      // GiftsRepository, so this must still return the German content rather
      // than an empty map.
      expect(sessions, contains('session_1'));
    },
  );
}
