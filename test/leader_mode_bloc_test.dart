import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:design_for_life/features/leader_notes/bloc/leader_mode_bloc.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  test('starts locked', () {
    final bloc = LeaderModeBloc();
    expect(bloc.state.isUnlocked, isFalse);
  });

  test('unlocks when the key matches the expected secret', () async {
    final bloc = LeaderModeBloc();
    bloc.add(const UnlockLeaderMode('dfl-leiter-2026'));
    await bloc.stream.first;

    expect(bloc.state.isUnlocked, isTrue);
  });

  test('stays locked when the key does not match', () async {
    final bloc = LeaderModeBloc();
    bloc.add(const UnlockLeaderMode('wrong-key'));

    // No matching state ever gets emitted for a wrong key, so there's
    // nothing to await on bloc.stream - just verify the state never changed.
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.isUnlocked, isFalse);
  });

  test('LockLeaderMode turns an unlocked device back off', () async {
    final bloc = LeaderModeBloc();
    bloc.add(const UnlockLeaderMode('dfl-leiter-2026'));
    await bloc.stream.first;
    expect(bloc.state.isUnlocked, isTrue);

    bloc.add(const LockLeaderMode());
    await bloc.stream.first;

    expect(bloc.state.isUnlocked, isFalse);
  });

  test('round-trips through toJson/fromJson', () {
    const state = LeaderModeState(isUnlocked: true);
    final restored = LeaderModeState.fromJson(state.toJson());
    expect(restored, state);
  });
}
