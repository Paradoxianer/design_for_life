import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/prayer_impression.dart';

class ListeningPrayerResult extends StatelessWidget {
  final Map<String, List<PrayerImpression>> impressions;

  const ListeningPrayerResult({
    super.key,
    required this.impressions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.listeningPrayer ?? 'Listening Prayer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...impressions.entries.map((entry) => _buildImpressionSection(
            context,
            entry.key,
            entry.value,
          )),
        ],
      ),
    );
  }

  Widget _buildImpressionSection(
    BuildContext context,
    String title,
    List<PrayerImpression> items,
  ) {
    // Nur fertige Eindrücke mit Inhalt anzeigen
    final completedItems = items.where((e) => e.text.isNotEmpty || e.imagePath != null).toList();
    if (completedItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != 'Eindrücke') // Nur anzeigen, wenn es nicht der Standard-Key ist
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ...completedItems.map((item) => _buildResultEntry(context, item)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultEntry(BuildContext context, PrayerImpression item) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.text.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(item.text, style: theme.textTheme.bodyLarge)),
              ],
            ),
          if (item.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(item.imagePath!),
            ),
          ],
          if (item.authorName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Von: ${item.authorName}',
                style: theme.textTheme.labelSmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb) {
      return Image.network(
        path,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(path),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }
}
