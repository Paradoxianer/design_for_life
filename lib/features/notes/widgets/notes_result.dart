import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/key_takeaway_field.dart';

class NotesResult extends StatelessWidget {
  final List<DflEntry> entries;
  final List<String> takeaways;
  final Function(int, String) onUpdate;

  const NotesResult({
    super.key,
    required this.entries,
    required this.takeaways,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final displayEntries = entries.where((e) => e.text.isNotEmpty || e.imagePath != null).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.notes, style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          
          if (displayEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Keine Notizen vorhanden.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          ...displayEntries.map((entry) => _buildResultEntry(context, entry)),
          
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          
          KeyTakeawayField(
            takeaways: takeaways,
            onUpdate: onUpdate,
            isReadOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildResultEntry(BuildContext context, DflEntry item) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.text.isNotEmpty)
            Text(item.text, style: theme.textTheme.bodyLarge),
          if (item.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(item.imagePath!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb) {
      return Image.network(path, width: double.infinity, height: 200, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), width: double.infinity, height: 200, fit: BoxFit.cover);
    }
  }
}
