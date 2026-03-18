import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/key_takeaway_field.dart';
import '../bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'prayer_impression_entry.dart';

class ListeningPrayerEditor extends StatelessWidget {
  final String sessionId;
  final List<DflEntry> impressions;
  final List<String> takeaways;
  final Function(List<String>) onTakeawaysUpdate;

  const ListeningPrayerEditor({
    super.key,
    required this.sessionId,
    required this.impressions,
    required this.takeaways,
    required this.onTakeawaysUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<ListeningPrayerBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.listeningPrayer ?? 'Listening Prayer',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Erfasse hier deine Eindrücke.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        
        ...impressions.map((impression) => PrayerImpressionEntry(
          key: ValueKey(impression.id),
          impression: impression,
          onTextChanged: (text) {
            bloc.add(UpdateEntryText(
              sessionId,
              impression.id,
              text,
            ));
          },
          onImageChanged: (path) {
            bloc.add(UpdateEntryImage(
              sessionId,
              impression.id,
              path,
            ));
          },
        )),

        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        
        KeyTakeawayField(
          takeaways: takeaways,
          onUpdate: (index, value) {
            final newList = List<String>.from(takeaways);
            if (index < newList.length) {
              newList[index] = value;
            } else {
              while (newList.length <= index) {
                newList.add('');
              }
              newList[index] = value;
            }
            onTakeawaysUpdate(newList);
          },
        ),
      ],
    );
  }
}
