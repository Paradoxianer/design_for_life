import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../blocs/language_cubit.dart';
import '../i18n/language_registry.dart';

/// Dialog zur Auswahl der App-Sprache. Zeigt nur Sprachen, die in
/// `assets/config/languages.json` stehen UND von der App unterstützt werden
/// (siehe [AppLocalizations.supportedLocales]). Maschinell übersetzte
/// Sprachen sind als Entwurf markiert.
Future<void> showLanguagePicker(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final cubit = context.read<LanguageCubit>();
  final supported = AppLocalizations.supportedLocales
      .map((l) => l.languageCode)
      .toSet();
  final languages = (await LanguageRegistry.load())
      .where((l) => supported.contains(l.code))
      .toList();
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final current = cubit.state;
      return SimpleDialog(
        title: Text(l10n.languageTitle),
        children: [
          RadioListTile<String?>(
            value: null,
            groupValue: current,
            title: Text(l10n.languageAuto),
            onChanged: (_) {
              cubit.select(null);
              Navigator.pop(dialogContext);
            },
          ),
          for (final language in languages)
            RadioListTile<String?>(
              value: language.code,
              groupValue: current,
              title: Text(language.name),
              subtitle: language.status == LanguageStatus.draft
                  ? Text(l10n.languageDraft)
                  : null,
              onChanged: (_) {
                cubit.select(language.code);
                Navigator.pop(dialogContext);
              },
            ),
        ],
      );
    },
  );
}
