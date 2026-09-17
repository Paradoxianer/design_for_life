import 'dart:convert';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:design_for_life/core/services/app_backup_service.dart';
import 'package:design_for_life/core/utils/app_logger.dart';
import 'package:design_for_life/core/widgets/restart_widget.dart';
import 'package:design_for_life/features/leader_notes/bloc/leader_mode_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

/// Backup/restore screen (#84): export all local app data as one JSON file,
/// or restore from a previously exported one. Purely local/offline - there's
/// no server to sync to in Release 1, so this file is the only way progress
/// survives a browser-data wipe, reinstall, or device change.
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isExporting = false;
  bool _isImporting = false;

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isExporting = true);
    try {
      final json = AppBackupService.exportJson();
      final bytes = Uint8List.fromList(utf8.encode(json));
      final fileName =
          'dfl_backup_${DateTime.now().toIso8601String().split('T').first}.json';

      // Same cross-platform file-vs-bytes split as ShareImageGenerator:
      // web has no filesystem for XFile.fromData to lean on, everywhere
      // else needs a real path or share_plus drops all but one shared file.
      final XFile file;
      if (kIsWeb) {
        file = XFile.fromData(
          bytes,
          name: fileName,
          mimeType: 'application/json',
        );
      } else {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/$fileName';
        await io.File(path).writeAsBytes(bytes);
        file = XFile(path, mimeType: 'application/json');
      }

      await Share.shareXFiles([file], subject: fileName);
    } catch (e) {
      logError('Backup export failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.backupExportError)));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.single.bytes;
    if (bytes == null) return;

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.backupImportConfirmTitle),
        content: Text(l10n.backupImportConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.backupImportConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isImporting = true);
    try {
      final jsonString = utf8.decode(bytes);
      await AppBackupService.importJson(jsonString);
      if (!mounted) return;
      // The already-running blocs won't see the freshly written storage on
      // their own - RestartWidget rebuilds them from scratch so hydration
      // runs again and picks it up.
      RestartWidget.restartApp(context);
    } on InvalidBackupException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.backupImportInvalidFile)));
      }
    } catch (e) {
      logError('Backup import failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.backupImportError)));
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.backupGuidance, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.backupExportTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.backupExportGuidance),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isExporting ? null : _export,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file_outlined),
                    label: Text(l10n.backupExportButton),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.backupImportTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.backupImportGuidance),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isImporting ? null : _import,
                    icon: _isImporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_outlined),
                    label: Text(l10n.backupImportButton),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<LeaderModeBloc, LeaderModeState>(
            builder: (context, leaderModeState) {
              if (!leaderModeState.isUnlocked) return const SizedBox.shrink();
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.leaderModeSectionTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.leaderModeSectionGuidance),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => context.read<LeaderModeBloc>().add(
                              const LockLeaderMode(),
                            ),
                            icon: const Icon(Icons.lock_outline),
                            label: Text(l10n.leaderModeLockButton),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
