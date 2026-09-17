import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:design_for_life/features/checklist/bloc/checklist_bloc.dart';
import 'package:design_for_life/features/checklist/models/checklist_item.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  test('starts with the default items, all unchecked', () {
    final bloc = ChecklistBloc();

    expect(
      bloc.state.items.map((item) => item.id),
      ChecklistItem.defaultItemIds,
    );
    expect(bloc.state.items.every((item) => !item.isChecked), isTrue);
    expect(bloc.state.isCompleted, isFalse);
  });

  test('toggles a default item on and off', () async {
    final bloc = ChecklistBloc();

    bloc.add(const ToggleChecklistItem(ChecklistItem.bible));
    await bloc.stream.first;
    expect(
      bloc.state.items.firstWhere((i) => i.id == ChecklistItem.bible).isChecked,
      isTrue,
    );

    bloc.add(const ToggleChecklistItem(ChecklistItem.bible));
    await bloc.stream.first;
    expect(
      bloc.state.items.firstWhere((i) => i.id == ChecklistItem.bible).isChecked,
      isFalse,
    );
  });

  test('isCompleted is true only once every item is checked', () async {
    final bloc = ChecklistBloc();

    for (final id in ChecklistItem.defaultItemIds) {
      bloc.add(ToggleChecklistItem(id));
      await bloc.stream.first;
    }

    expect(bloc.state.isCompleted, isTrue);

    bloc.add(ToggleChecklistItem(ChecklistItem.defaultItemIds.first));
    await bloc.stream.first;
    expect(bloc.state.isCompleted, isFalse);
  });

  test('adds a custom item with the given text', () async {
    final bloc = ChecklistBloc();

    bloc.add(const AddCustomChecklistItem('Sonnencreme'));
    await bloc.stream.first;

    final added = bloc.state.items.last;
    expect(added.customText, 'Sonnencreme');
    expect(added.isCustom, isTrue);
    expect(added.isChecked, isFalse);
    expect(bloc.state.items.length, ChecklistItem.defaultItemIds.length + 1);
  });

  test('ignores a custom item that is blank after trimming', () async {
    final bloc = ChecklistBloc();

    bloc.add(const AddCustomChecklistItem('   '));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.items.length, ChecklistItem.defaultItemIds.length);
  });

  test('removes a custom item by id', () async {
    final bloc = ChecklistBloc();

    bloc.add(const AddCustomChecklistItem('Sonnencreme'));
    await bloc.stream.first;
    final addedId = bloc.state.items.last.id;

    bloc.add(RemoveChecklistItem(addedId));
    await bloc.stream.first;

    expect(bloc.state.items.length, ChecklistItem.defaultItemIds.length);
    expect(bloc.state.items.any((item) => item.id == addedId), isFalse);
  });

  test('round-trips through toJson/fromJson', () {
    final state = ChecklistState(
      items: [
        const ChecklistItem(id: ChecklistItem.bible, isChecked: true),
        const ChecklistItem(id: 'custom_1', customText: 'Sonnencreme'),
      ],
    );
    final restored = ChecklistState.fromJson(state.toJson());

    expect(restored, state);
  });

  test('fromJson falls back to the default items when the list is empty', () {
    final restored = ChecklistState.fromJson({'items': []});

    expect(restored.items.map((item) => item.id), ChecklistItem.defaultItemIds);
  });
}
