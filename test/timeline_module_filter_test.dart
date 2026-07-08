import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:design_for_life/features/timeline/bloc/timeline_module_filter_bloc.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  test('defaults to no restriction (full timeline)', () {
    final bloc = TimelineModuleFilterBloc();
    expect(bloc.state.allowedSessionIds, isNull);
  });

  test(
    'SetAllowedModules restricts to exactly the given session ids',
    () async {
      final bloc = TimelineModuleFilterBloc();
      bloc.add(const SetAllowedModules(['session_1', 'session_3']));
      await bloc.stream.first;

      expect(bloc.state.allowedSessionIds, {'session_1', 'session_3'});
    },
  );

  test(
    'a second SetAllowedModules replaces, it does not merge with the previous list',
    () async {
      final bloc = TimelineModuleFilterBloc();
      bloc.add(const SetAllowedModules(['session_1', 'session_3']));
      await bloc.stream.first;
      bloc.add(const SetAllowedModules(['session_5']));
      await bloc.stream.first;

      expect(bloc.state.allowedSessionIds, {'session_5'});
    },
  );

  test(
    'event date/location persist across a later restriction that omits them',
    () async {
      final bloc = TimelineModuleFilterBloc();
      bloc.add(
        const SetAllowedModules(
          ['session_1'],
          eventDate: '2026-08-01',
          eventLocation: 'Tagungshaus',
        ),
      );
      await bloc.stream.first;
      bloc.add(const SetAllowedModules(['session_5']));
      await bloc.stream.first;

      expect(bloc.state.allowedSessionIds, {'session_5'});
      expect(bloc.state.eventDate, '2026-08-01');
      expect(bloc.state.eventLocation, 'Tagungshaus');
    },
  );

  test('round-trips through toJson/fromJson', () {
    const state = TimelineModuleFilterState(
      allowedSessionIds: {'session_1', 'session_3'},
      eventDate: '2026-08-01',
      eventLocation: 'Tagungshaus',
    );

    final restored = TimelineModuleFilterState.fromJson(state.toJson());
    expect(restored, state);
  });

  test(
    'fromJson defaults to no restriction when allowedSessionIds is absent',
    () {
      final restored = TimelineModuleFilterState.fromJson({});
      expect(restored.allowedSessionIds, isNull);
    },
  );
}
