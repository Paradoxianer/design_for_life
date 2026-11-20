import 'dart:io' as io;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../../../core/utils/app_logger.dart';
import '../bloc/leader_mode_bloc.dart';
import '../repositories/leader_notes_repository.dart';
import '../services/leader_booklet_pdf.dart';

/// Leiter-Material (nur im Leitermodus): Leiterheft als PDF und Vorlagen
/// (Zeitpläne, Urkunde) als Originaldateien zum Weiterbearbeiten.
class LeaderMaterialsScreen extends StatefulWidget {
  const LeaderMaterialsScreen({super.key});

  @override
  State<LeaderMaterialsScreen> createState() => _LeaderMaterialsScreenState();
}

class _Template {
  final String asset;
  final String fileName;
  final String mimeType;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) description;
  final IconData icon;

  const _Template({
    required this.asset,
    required this.fileName,
    required this.mimeType,
    required this.title,
    required this.description,
    required this.icon,
  });
}

final List<_Template> _templates = [
  _Template(
    asset: 'assets/templates/DFL_Zeitplaene_Hoerendes_Gebet_Gespraeche.docx',
    fileName: 'DFL_Zeitplaene_Hoerendes_Gebet_Gespraeche.docx',
    mimeType:
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    title: (l) => l.leaderTemplateSchedulesTitle,
    description: (l) => l.leaderTemplateSchedulesDescription,
    icon: Icons.schedule_outlined,
  ),
  _Template(
    asset: 'assets/templates/DFL_Urkunde.odt',
    fileName: 'DFL_Urkunde.odt',
    mimeType: 'application/vnd.oasis.opendocument.text',
    title: (l) => l.leaderTemplateCertificateTitle,
    description: (l) => l.leaderTemplateCertificateDescription,
    icon: Icons.workspace_premium_outlined,
  ),
];

class _LeaderMaterialsScreenState extends State<LeaderMaterialsScreen> {
  bool _isGenerating = false;

  Future<void> _shareBooklet() async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    setState(() => _isGenerating = true);
    try {
      final sessions = await LeaderNotesRepository().loadSessions(locale);
      final bytes = await LeaderBookletPdf.build(
        sessions,
        title: '${l10n.appTitle} – ${l10n.leaderBookletTitle}',
      );
      await Printing.sharePdf(bytes: bytes, filename: 'dfl_leiterheft.pdf');
    } catch (e) {
      logError('Leader booklet PDF failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.leaderBookletError)));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _shareTemplate(_Template template) async {
    final l10n = AppLocalizations.of(context);
    try {
      final data = await rootBundle.load(template.asset);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      // Gleiche Aufteilung wie beim Backup: im Web gibt es kein Dateisystem,
      // sonst braucht share_plus einen echten Pfad.
      final XFile file;
      if (kIsWeb) {
        file = XFile.fromData(
          bytes,
          name: template.fileName,
          mimeType: template.mimeType,
        );
      } else {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/${template.fileName}';
        await io.File(path).writeAsBytes(bytes);
        file = XFile(path, mimeType: template.mimeType);
      }
      await Share.shareXFiles([file], subject: template.fileName);
    } catch (e) {
      logError('Template share failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.leaderTemplateError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unlocked = context.watch<LeaderModeBloc>().state.isUnlocked;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaderMaterialsTitle)),
      // Wird der Leitermodus währenddessen deaktiviert, ist nichts mehr zu
      // sehen - das Material ist nur für Leiter gedacht.
      body: !unlocked
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf_outlined),
                    title: Text(l10n.leaderBookletTitle),
                    subtitle: Text(l10n.leaderBookletDescription),
                    trailing: _isGenerating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_outlined),
                    onTap: _isGenerating ? null : _shareBooklet,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.leaderTemplatesTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                for (final template in _templates)
                  Card(
                    child: ListTile(
                      leading: Icon(template.icon),
                      title: Text(template.title(l10n)),
                      subtitle: Text(template.description(l10n)),
                      trailing: const Icon(Icons.download_outlined),
                      onTap: () => _shareTemplate(template),
                    ),
                  ),
              ],
            ),
    );
  }
}
