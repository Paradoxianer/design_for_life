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
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.listeningPrayer,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Hier nutzen wir die keys aus dem State, falls vorhanden
        ...impressions.entries.map((entry) => _buildImpressionSection(
          context,
          entry.key, // Oder ein Mapping auf l10n Texte
          entry.value,
        )),
      ],
    );
  }

  Widget _buildImpressionSection(
    BuildContext context,
    String title,
    List<PrayerImpression> items,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.where((e) => e.text.isNotEmpty).map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(item.text)),
            ],
          ),
        )),
      ],
    );
  }
}
