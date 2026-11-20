import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../../../core/utils/app_logger.dart';
import '../bloc/leader_mode_bloc.dart';
import '../repositories/leader_notes_repository.dart';
import '../services/leader_booklet_pdf.dart';
import '../services/leader_templates_pdf.dart';

/// Leiter-Material (nur im Leitermodus): Leiterheft als PDF sowie Vorlagen
/// (Urkunde, Zeitpläne), die in der Sprache der App als PDF erzeugt werden.
class LeaderMaterialsScreen extends StatefulWidget {
  const LeaderMaterialsScreen({super.key});

  @override
  State<LeaderMaterialsScreen> createState() => _LeaderMaterialsScreenState();
}

class _LeaderMaterialsScreenState extends State<LeaderMaterialsScreen> {
  bool _isGenerating = false;

  Future<void> _run(
    Future<void> Function() action,
    String errorText,
  ) async {
    setState(() => _isGenerating = true);
    try {
      await action();
    } catch (e) {
      logError('Leader material failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText)));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _shareBooklet() {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return _run(() async {
      final sessions = await LeaderNotesRepository().loadSessions(locale);
      final bytes = await LeaderBookletPdf.build(
        sessions,
        title: '${l10n.appTitle} – ${l10n.leaderBookletTitle}',
      );
      await Printing.sharePdf(bytes: bytes, filename: 'dfl_leiterheft.pdf');
    }, l10n.leaderBookletError);
  }

  Future<void> _shareSchedules() {
    final l10n = AppLocalizations.of(context);
    return _run(() async {
      final bytes = await LeaderTemplatesPdf.schedules(l10n);
      await Printing.sharePdf(bytes: bytes, filename: 'dfl_zeitplaene.pdf');
    }, l10n.leaderTemplateError);
  }

  Future<void> _askAndShareCertificates() async {
    final l10n = AppLocalizations.of(context);
    final names = TextEditingController();
    final place = TextEditingController();
    final date = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.leaderTemplateCertificateTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: names,
                minLines: 3,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: l10n.leaderCertificateNames,
                  helperText: l10n.leaderCertificateNamesHint,
                  helperMaxLines: 2,
                ),
              ),
              TextField(
                controller: place,
                decoration: InputDecoration(
                  labelText: l10n.leaderCertificatePlace,
                ),
              ),
              TextField(
                controller: date,
                decoration: InputDecoration(
                  labelText: l10n.leaderCertificateDate,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.leaderCertificateCreate),
          ),
        ],
      ),
    );
    final nameList = names.text.split('\n');
    final placeText = place.text;
    final dateText = date.text;
    names.dispose();
    place.dispose();
    date.dispose();
    if (confirmed != true || !mounted) return;
    await _run(() async {
      final bytes = await LeaderTemplatesPdf.certificates(
        l10n,
        names: nameList,
        place: placeText,
        date: dateText,
      );
      await Printing.sharePdf(bytes: bytes, filename: 'dfl_urkunde.pdf');
    }, l10n.leaderTemplateError);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unlocked = context.watch<LeaderModeBloc>().state.isUnlocked;

    Widget tile(
      IconData icon,
      String title,
      String description,
      VoidCallback onTap,
    ) {
      return Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(description),
          trailing: _isGenerating
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.picture_as_pdf_outlined),
          onTap: _isGenerating ? null : onTap,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaderMaterialsTitle)),
      // Wird der Leitermodus währenddessen deaktiviert, ist nichts mehr zu
      // sehen - das Material ist nur für Leiter gedacht.
      body: !unlocked
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                tile(
                  Icons.menu_book_outlined,
                  l10n.leaderBookletTitle,
                  l10n.leaderBookletDescription,
                  _shareBooklet,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.leaderTemplatesTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                tile(
                  Icons.schedule_outlined,
                  l10n.leaderTemplateSchedulesTitle,
                  l10n.leaderTemplateSchedulesDescription,
                  _shareSchedules,
                ),
                tile(
                  Icons.workspace_premium_outlined,
                  l10n.leaderTemplateCertificateTitle,
                  l10n.leaderTemplateCertificateDescription,
                  _askAndShareCertificates,
                ),
              ],
            ),
    );
  }
}
