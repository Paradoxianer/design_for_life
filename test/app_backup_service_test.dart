import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:design_for_life/core/services/app_backup_service.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late MockStorage storage;

  setUp(() {
    storage = MockStorage();
    HydratedBloc.storage = storage;
  });

  group('exportJson', () {
    test('bundles every known bloc key that has stored data', () {
      // Everything else: never hydrated, storage has nothing for it yet.
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.read('NotesBloc')).thenReturn({
        'entries': {
          'session_1': [
            {'id': 'e1', 'text': 'hello'},
          ],
        },
      });
      when(() => storage.read('ValuesBloc')).thenReturn({'allValues': []});

      final json = AppBackupService.exportJson();

      expect(json, contains('"app": "design_for_life"'));
      expect(
        json,
        contains('"schemaVersion": ${AppBackupService.schemaVersion}'),
      );
      expect(json, contains('"NotesBloc"'));
      expect(json, contains('"hello"'));
      expect(json, contains('"ValuesBloc"'));
      // Keys with null storage never got hydrated - shouldn't appear at all,
      // to keep the backup file free of noise.
      expect(json, isNot(contains('"GoalsBloc"')));
    });

    test(
      'produces a valid, empty-but-well-formed backup when nothing was ever hydrated',
      () {
        when(() => storage.read(any())).thenReturn(null);

        final json = AppBackupService.exportJson();

        expect(json, contains('"blocs": {}'));
      },
    );
  });

  group('importJson', () {
    test('writes every recognized bloc entry back into storage', () async {
      when(() => storage.write(any(), any())).thenAnswer((_) async {});
      const json = '''
      {
        "app": "design_for_life",
        "schemaVersion": 1,
        "exportedAt": "2026-01-01T00:00:00.000Z",
        "blocs": {
          "NotesBloc": {"entries": {"session_1": []}},
          "ValuesBloc": {"allValues": []}
        }
      }
      ''';

      await AppBackupService.importJson(json);

      final captured = verify(
        () => storage.write(captureAny(), captureAny()),
      ).captured;
      final writtenKeys = captured.whereType<String>().toList();
      expect(writtenKeys, containsAll(['NotesBloc', 'ValuesBloc']));
    });

    test('ignores bloc keys the app does not recognize', () async {
      when(() => storage.write(any(), any())).thenAnswer((_) async {});
      const json = '''
      {
        "app": "design_for_life",
        "schemaVersion": 1,
        "exportedAt": "2026-01-01T00:00:00.000Z",
        "blocs": {
          "SomeFutureBlocThisVersionDoesNotKnow": {"foo": "bar"}
        }
      }
      ''';

      await AppBackupService.importJson(json);

      verifyNever(
        () => storage.write('SomeFutureBlocThisVersionDoesNotKnow', any()),
      );
    });

    test(
      'rejects a file from a different app without writing anything',
      () async {
        const json = '''
      {
        "app": "some_other_app",
        "schemaVersion": 1,
        "blocs": {"NotesBloc": {}}
      }
      ''';

        await expectLater(
          () => AppBackupService.importJson(json),
          throwsA(isA<InvalidBackupException>()),
        );
        verifyNever(() => storage.write(any(), any()));
      },
    );

    test(
      'rejects an unsupported schema version without writing anything',
      () async {
        const json = '''
      {
        "app": "design_for_life",
        "schemaVersion": 999,
        "blocs": {"NotesBloc": {}}
      }
      ''';

        await expectLater(
          () => AppBackupService.importJson(json),
          throwsA(isA<InvalidBackupException>()),
        );
        verifyNever(() => storage.write(any(), any()));
      },
    );

    test('rejects malformed JSON without writing anything', () async {
      await expectLater(
        () => AppBackupService.importJson('not valid json at all {{{'),
        throwsA(isA<InvalidBackupException>()),
      );
      verifyNever(() => storage.write(any(), any()));
    });

    test('rejects a file with no blocs map without writing anything', () async {
      const json = '''
      {
        "app": "design_for_life",
        "schemaVersion": 1
      }
      ''';

      await expectLater(
        () => AppBackupService.importJson(json),
        throwsA(isA<InvalidBackupException>()),
      );
      verifyNever(() => storage.write(any(), any()));
    });
  });
}
