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

  test('toggle ticks and unticks, reset clears all ticks', () {
    final cubit = LeaderChecklistCubit();
    final key = LeaderChecklistCubit.keyFor('Material', 'Stifte');

    cubit.toggle(key);
    expect(cubit.state.checked, {key});
    cubit.toggle(key);
    expect(cubit.state.checked, isEmpty);

    cubit.toggle(key);
    cubit.reset();
    expect(cubit.state.checked, isEmpty);
  });

  test('custom items can be added, ticked, removed; reset keeps them', () {
    final cubit = LeaderChecklistCubit();
    final list = LeaderChecklistCubit.listKey('Material', 2);

    cubit.addItem(list, '  Beamer  ');
    cubit.addItem(list, 'Beamer'); // duplicate
    cubit.addItem(list, '   '); // empty
    expect(cubit.state.custom[list], ['Beamer']);

    final key = LeaderChecklistCubit.keyFor(list, 'Beamer');
    cubit.toggle(key);
    cubit.reset();
    expect(cubit.state.checked, isEmpty);
    expect(cubit.state.custom[list], ['Beamer']);

    cubit.toggle(key);
    cubit.removeItem(list, 'Beamer');
    expect(cubit.state.custom, isEmpty);
    expect(cubit.state.checked, isEmpty);
  });

  test('survives a JSON round trip', () {
    final cubit = LeaderChecklistCubit();
    const state = LeaderChecklistState(
      checked: {'a|b', 'c|d'},
      custom: {
        'x#1': ['eins', 'zwei'],
      },
    );
    expect(cubit.fromJson(cubit.toJson(state)!), state);
  });

  test('reads the old format without custom items', () {
    final cubit = LeaderChecklistCubit();
    final restored = cubit.fromJson({
      'checked': ['a|b'],
    });
    expect(restored?.checked, {'a|b'});
    expect(restored?.custom, isEmpty);
  });

  test('the leader checklist session uses tickable lists', () async {
    final sessions = await LeaderNotesRepository().loadSessions('de');
    final blocks = sessions['session_checklist']!.sections
        .expand((s) => s.blocks)
        .toList();
    expect(blocks.whereType<LeaderNoteChecklist>(), isNotEmpty);
  });
}
