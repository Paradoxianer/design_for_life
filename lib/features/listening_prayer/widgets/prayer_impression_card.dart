import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/prayer_impression.dart';

class PrayerImpressionCard extends StatelessWidget {
  final PrayerImpression impression;
  final Function(String) onChanged;
  final bool isReadOnly;

  const PrayerImpressionCard({
    super.key,
    required this.impression,
    required this.onChanged,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (impression.isReceived)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Chip(
                  label: Text(l10n.receivedImpressions, style: const TextStyle(fontSize: 12)),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ),
            if (isReadOnly)
              Text(impression.text, style: theme.textTheme.bodyLarge)
            else
              TextField(
                controller: TextEditingController(text: impression.text)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: impression.text.length),
                  ),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: l10n.impressionHint,
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }
}
