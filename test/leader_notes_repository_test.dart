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

  test('covers every session id that has Leiterheft content today', () async {
    final sessions = await LeaderNotesRepository().loadSessions('de');

    // Matches assets/config/timeline_config.json's session ids - every
    // "Einheit" from the Leiterheft plus the modules it interleaves with
    // (Lebensbaum, Gaben, Werte). Sessions without printed leader notes
    // (Gruppenfoto, Feedback, Persönlichkeitsprofil, Imagine, Verknüpfungen)
    // are intentionally absent rather than present-but-empty.
    expect(sessions.keys.toSet(), {
      'session_1',
      'session_2',
      'session_3',
      'session_4',
      'session_5',
      'session_6',
      'session_7',
      'session_9',
      'session_10',
    });

    for (final entry in sessions.entries) {
      expect(
        entry.value.sections,
        isNotEmpty,
        reason: '${entry.key} has a title but no content',
      );
    }
  });

  test('loads the real English translation, not the German fallback', () async {
    final sessions = await LeaderNotesRepository().loadSessions('en');

    expect(sessions.keys.toSet(), {
      'session_1',
      'session_2',
      'session_3',
      'session_4',
      'session_5',
      'session_6',
      'session_7',
      'session_9',
      'session_10',
    });
    expect(sessions['session_1']!.sessionTitle, contains('Session One'));
    // A file-level metadata key (translation caveat, no native JSON comment
    // syntax) must not be mistaken for a session.
    expect(sessions.keys, isNot(contains('_note')));
  });

  test(
    'falls back to German for a locale with no leader notes file at all',
    () async {
      final sessions = await LeaderNotesRepository().loadSessions('fr');

      // Same fallback rule as GiftsRepository: an unknown locale still
      // returns usable (German) content rather than an empty map.
      expect(sessions, contains('session_1'));
      expect(sessions['session_1']!.sessionTitle, contains('Einheit Eins'));
    },
  );
}
