import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:design_for_life/features/leader_notes/bloc/leader_checklist_cubit.dart';
import 'package:design_for_life/features/leader_notes/models/leader_note_block.dart';
import 'package:design_for_life/features/leader_notes/repositories/leader_notes_repository.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  test('toggle ticks and unticks, reset clears all', () {
    final cubit = LeaderChecklistCubit();
    final key = LeaderChecklistCubit.keyFor('Material', 'Stifte');

    cubit.toggle(key);
    expect(cubit.state, {key});
    cubit.toggle(key);
    expect(cubit.state, isEmpty);

    cubit.toggle(key);
    cubit.reset();
    expect(cubit.state, isEmpty);
  });

  test('survives a JSON round trip', () {
    final cubit = LeaderChecklistCubit();
    final json = cubit.toJson({'a|b', 'c|d'})!;
    expect(cubit.fromJson(json), {'a|b', 'c|d'});
  });

  test('the leader checklist session uses tickable lists', () async {
    final sessions = await LeaderNotesRepository().loadSessions('de');
    final blocks = sessions['session_checklist']!.sections
        .expand((s) => s.blocks)
        .toList();
    expect(blocks.whereType<LeaderNoteChecklist>(), isNotEmpty);
  });
}
