import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/leader_notes/repositories/leader_notes_repository.dart';
import 'package:design_for_life/features/leader_notes/services/leader_booklet_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('orders sessions numerically with the checklist first', () async {
    final sessions = await LeaderNotesRepository().loadSessions('de');
    final ids = LeaderBookletPdf.orderedSessions(
      sessions,
    ).map((e) => e.key).toList();

    expect(ids.first, 'session_checklist');
    expect(ids.indexOf('session_2'), lessThan(ids.indexOf('session_10')));
    expect(ids.indexOf('session_9'), lessThan(ids.indexOf('session_10')));
  });

  test('builds a non-empty PDF from the real leader notes', () async {
    final sessions = await LeaderNotesRepository().loadSessions('de');
    final bytes = await LeaderBookletPdf.build(sessions, title: 'Leiterheft');

    expect(bytes.length, greaterThan(1000));
    // PDF-Dateien beginnen mit der Signatur "%PDF".
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
