import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Rejected because [jsonString] isn't a backup this app version can
/// restore - message is a translation key, not user-facing text (the
/// caller resolves it via l10n so this stays UI-framework-free).
class InvalidBackupException implements Exception {
  final String messageKey;
  const InvalidBackupException(this.messageKey);
}

/// Reads/writes all local app data as one JSON document (#84) - the only
/// way to carry progress across a browser-data wipe, reinstall, or device
/// change, since Release 1 is local-first with no server sync.
///
/// Every module is a [HydratedBloc], each hydrating itself from
/// `HydratedBloc.storage` under its own key - by default just the bloc's
/// class name (see `HydratedMixin.storagePrefix`/`storageToken`), since none
/// of this app's blocs override it. That makes a full backup possible
/// without each bloc needing its own export/import event: read every known
/// key's raw stored value, bundle it, and on import write the same keys
/// back - already-running bloc instances then need [RestartWidget] to
/// re-hydrate from the new data (see main.dart).
class AppBackupService {
  const AppBackupService._();

  static const int schemaVersion = 1;

  static const List<String> _blocKeys = [
    'NotesBloc',
    'ListeningPrayerBloc',
    'GoalsBloc',
    'SpiritualGiftsBloc',
    'GiftReferenceAnswerBloc',
    'ValuesBloc',
    'FeedbackBloc',
    'PersonalStyleBloc',
    'ImagineBloc',
    'LifeTreeBloc',
    'SynthesisBloc',
    'GroupPhotoBloc',
    'TimelineModuleFilterBloc',
  ];

  static String exportJson() {
    final blocs = <String, dynamic>{};
    for (final key in _blocKeys) {
      final value = HydratedBloc.storage.read(key);
      if (value != null) blocs[key] = value;
    }
    final bundle = {
      'app': 'design_for_life',
      'schemaVersion': schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'blocs': blocs,
    };
    return const JsonEncoder.withIndent('  ').convert(bundle);
  }

  /// Writes every recognized bloc's data back into storage. Throws
  /// [InvalidBackupException] without writing anything if [jsonString]
  /// isn't a well-formed backup from this app - never partially applies a
  /// broken file.
  static Future<void> importJson(String jsonString) async {
    final dynamic decoded = _tryDecode(jsonString);
    if (decoded is! Map ||
        decoded['app'] != 'design_for_life' ||
        decoded['schemaVersion'] != schemaVersion ||
        decoded['blocs'] is! Map) {
      throw const InvalidBackupException('backupImportInvalidFile');
    }

    final blocs = decoded['blocs'] as Map;
    for (final key in _blocKeys) {
      final value = blocs[key];
      if (value is Map) {
        await HydratedBloc.storage.write(key, value);
      }
    }
  }

  static dynamic _tryDecode(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } on FormatException {
      return null;
    }
  }
}
