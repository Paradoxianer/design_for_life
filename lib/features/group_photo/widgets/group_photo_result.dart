import 'package:flutter/material.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/result_image_thumbnail.dart';

class GroupPhotoResult extends StatelessWidget {
  final List<DflEntry> entries;

  const GroupPhotoResult({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final displayEntries = entries.where((e) => e.text.isNotEmpty || e.imagePath != null).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.session11Title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          if (displayEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.groupPhotoEmptyState,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ...displayEntries.map((entry) => _buildResultEntry(context, entry)),
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
              child: ResultImageThumbnail(imagePath: item.imagePath!),
            ),
          ],
        ],
      ),
    );
  }
}
