import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../../../core/widgets/key_takeaway_field.dart';
import '../bloc/listening_prayer_bloc.dart';
import '../bloc/listening_prayer_event.dart';
import '../models/prayer_impression.dart';
import 'prayer_impression_card.dart';

class ListeningPrayerEditor extends DflModuleEditor {
  final String sessionId;
  final List<PrayerImpression> impressions;

  const ListeningPrayerEditor({
    super.key,
    required this.sessionId,
    required this.impressions,
    required super.takeaways,
    required super.onTakeawayUpdate,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Guidance
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.spatial_audio_off_outlined, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.listeningPrayerGuidance,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(l10n.ownImpressions, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),

        ...impressions.map((impression) => PrayerImpressionCard(
              impression: impression,
              onChanged: (val) {
                context.read<ListeningPrayerBloc>().add(
                      UpdateImpression(
                        sessionId: sessionId,
                        impressionId: impression.id,
                        text: val,
                      ),
                    );
              },
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // We override build because we want the KeyTakeawayField to have a custom title
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildContent(context),
        const SizedBox(height: 32),
        // Special Takeaway Field for Listening Prayer
        KeyTakeawayField(
          takeaways: takeaways,
          onUpdate: onTakeawayUpdate,
          isReadOnly: false,
        ),
      ],
    );
  }
}
