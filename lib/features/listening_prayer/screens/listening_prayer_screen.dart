import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import '../bloc/listening_prayer_bloc.dart';
import '../widgets/listening_prayer_editor.dart';
import '../widgets/listening_prayer_result.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';

class ListeningPrayerScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const ListeningPrayerScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListeningPrayerBloc, EntryListState>(
      builder: (context, state) {
        final impressions = state.entries[sessionId] ?? [];
        final highlights = state.takeaways[sessionId] ?? const ['', '', ''];

        final displayImpressions = impressions.isEmpty 
            ? [DflEntry(id: 'initial_$sessionId')] 
            : impressions;

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          editor: ListeningPrayerEditor(
            sessionId: sessionId,
            impressions: displayImpressions,
            takeaways: highlights,
            onTakeawaysUpdate: (newList) {
              for (int i = 0; i < newList.length; i++) {
                context.read<ListeningPrayerBloc>().add(
                  UpdateTakeaway(sessionId, i, newList[i]),
                );
              }
            },
          ),
          result: ListeningPrayerResult(
            impressions: { 'Eindrücke': impressions },
            takeaways: highlights,
            onUpdate: (index, value) {
              context.read<ListeningPrayerBloc>().add(
                UpdateTakeaway(sessionId, index, value),
              );
            },
          ),
        );
      },
    );
  }
}
