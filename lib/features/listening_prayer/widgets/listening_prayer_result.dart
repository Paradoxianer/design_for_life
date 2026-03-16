import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/widgets/key_takeaway_field.dart';
import '../models/prayer_impression.dart';
import 'prayer_impression_card.dart';

class ListeningPrayerResult extends StatelessWidget {
  final List<PrayerImpression> impressions;
  final List<String> takeaways;

  const ListeningPrayerResult({
    super.key,
    required this.impressions,
    required this.takeaways,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final ownImpressions = impressions.where((i) => !i.isReceived && i.text.isNotEmpty).toList();
    final receivedImpressions = impressions.where((i) => i.isReceived && i.text.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ownImpressions.isNotEmpty) ...[
          Text(l10n.ownImpressions, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ...ownImpressions.map((i) => PrayerImpressionCard(
                impression: i,
                onChanged: (_) {},
                isReadOnly: true,
              )),
          const SizedBox(height: 24),
        ],
        
        if (receivedImpressions.isNotEmpty) ...[
          Text(l10n.receivedImpressions, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ...receivedImpressions.map((i) => PrayerImpressionCard(
                impression: i,
                onChanged: (_) {},
                isReadOnly: true,
              )),
          const SizedBox(height: 24),
        ],

        KeyTakeawayField(
          takeaways: takeaways,
          onUpdate: (_, __) {},
          isReadOnly: true,
        ),
      ],
    );
  }
}
