import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/key_takeaway_field.dart';
import '../models/prayer_impression.dart';

class ListeningPrayerEditor extends StatelessWidget {
  final Map<String, List<PrayerImpression>> impressions;
  final List<String> takeaways;
  final Function(Map<String, List<PrayerImpression>>) onImpressionsUpdate;
  final Function(List<String>) onTakeawaysUpdate;
  final TextEditingController takeawayController;

  const ListeningPrayerEditor({
    super.key,
    required this.impressions,
    required this.takeaways,
    required this.onImpressionsUpdate,
    required this.onTakeawaysUpdate,
    required this.takeawayController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          context,
          l10n.receivedImpressions,
          impressions['received'] ?? [],
          (val) => _updateSection('received', val),
          l10n.impressionHint,
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          l10n.ownImpressions,
          impressions['own'] ?? [],
          (val) => _updateSection('own', val),
          l10n.impressionHint,
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        KeyTakeawayField(
          controller: takeawayController,
          label: l10n.threeHighlights,
          takeaways: takeaways,
          onUpdate: onTakeawaysUpdate,
        ),
      ],
    );
  }

  void _updateSection(String key, List<PrayerImpression> newValues) {
    final newImpressions = Map<String, List<PrayerImpression>>.from(impressions);
    newImpressions[key] = newValues;
    onImpressionsUpdate(newImpressions);
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<PrayerImpression> items,
    Function(List<PrayerImpression>) onUpdate,
    String hint,
  ) {
    final displayItems = List<PrayerImpression>.from(items);
    if (displayItems.isEmpty || (displayItems.isNotEmpty && displayItems.last.text.isNotEmpty)) {
      displayItems.add(PrayerImpression(id: DateTime.now().toString()));
    }

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
        ...displayItems.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              controller: TextEditingController(text: value.text)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: value.text.length),
                ),
              onChanged: (newValue) {
                final newList = List<PrayerImpression>.from(displayItems);
                newList[index] = newList[index].copyWith(text: newValue);
                onUpdate(newList.where((e) => e.text.isNotEmpty).toList());
              },
            ),
          );
        }),
      ],
    );
  }
}
