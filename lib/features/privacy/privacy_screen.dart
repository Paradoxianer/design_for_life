import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:design_for_life/core/utils/app_logger.dart';
import 'package:design_for_life/core/widgets/restart_widget.dart';
import 'package:design_for_life/features/privacy/legal_texts.dart';
import 'package:design_for_life/features/privacy/privacy_notice_gate.dart';
import 'package:design_for_life/features/privacy/privacy_texts.dart';

/// Löscht alle lokal gespeicherten Einträge und startet die App neu.
Future<void> confirmAndDeleteAllData(BuildContext context) async {
  final t = PrivacyTexts.forLanguage(Localizations.localeOf(context).languageCode);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.deleteConfirmTitle),
      content: Text(t.deleteConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(t.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(t.deleteConfirmAction),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  try {
    await HydratedBloc.storage.clear();
  } catch (e) {
    logError('Delete all data failed: $e');
    return;
  }
  if (context.mounted) RestartWidget.restartApp(context);
}

/// Datenschutz-Hinweise, Impressum-Links und "Alle Daten löschen".
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = PrivacyTexts.forLanguage(Localizations.localeOf(context).languageCode);
    return Scaffold(
      appBar: AppBar(title: Text(t.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelectableText(t.intro, style: theme.textTheme.bodyLarge),
          for (final (heading, body) in t.sections) ...[
            const SizedBox(height: 20),
            Text(
              heading,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(body),
          ],
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push('/imprint'),
            icon: const Icon(Icons.gavel_outlined),
            label: Text(t.imprintLink),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/privacy-policy'),
            icon: const Icon(Icons.policy_outlined),
            label: Text(t.privacyLink),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.deleteTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(t.deleteGuidance),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    ),
                    onPressed: () => confirmAndDeleteAllData(context),
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: Text(t.deleteButton),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Impressum bzw. Datenschutzerklärung als eigene Seite.
class LegalDocumentScreen extends StatelessWidget {
  final bool imprint;
  const LegalDocumentScreen({super.key, required this.imprint});

  @override
  Widget build(BuildContext context) {
    final t = LegalTexts.forLanguage(
      Localizations.localeOf(context).languageCode,
    );
    final doc = imprint ? t.imprint : t.privacyPolicy;
    return Scaffold(
      appBar: AppBar(title: Text(doc.title)),
      body: LegalDocumentView(document: doc),
    );
  }
}
