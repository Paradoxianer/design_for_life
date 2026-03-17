import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import '../bloc/listening_prayer_bloc.dart';
import '../widgets/listening_prayer_editor.dart';
import '../widgets/listening_prayer_result.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/dfl_entry.dart';

class ListeningPrayerScreen extends StatefulWidget {
  final String sessionId;
  final String title;

  const ListeningPrayerScreen({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  State<ListeningPrayerScreen> createState() => _ListeningPrayerScreenState();
}

class _ListeningPrayerScreenState extends State<ListeningPrayerScreen> {
  bool _isEditMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListeningPrayerBloc, EntryListState>(
      builder: (context, state) {
        final impressions = state.entries[widget.sessionId] ?? [];
        final highlights = state.takeaways[widget.sessionId] ?? const ['', '', ''];

        final displayImpressions = impressions.isEmpty 
            ? [DflEntry(id: 'initial_${widget.sessionId}')] 
            : impressions;

        return DflModuleScaffold(
          title: widget.title,
          isEditMode: _isEditMode,
          onToggleMode: () => setState(() => _isEditMode = !_isEditMode),
          editor: ListeningPrayerEditor(
            sessionId: widget.sessionId,
            impressions: displayImpressions,
            takeaways: highlights,
            onTakeawaysUpdate: (newList) {
              for (int i = 0; i < newList.length; i++) {
                context.read<ListeningPrayerBloc>().add(
                  UpdateTakeaway(widget.sessionId, i, newList[i]),
                );
              }
            },
          ),
          result: ListeningPrayerResult(
            impressions: { 'Eindrücke': impressions },
            takeaways: highlights,
            onUpdate: (index, value) {
              context.read<ListeningPrayerBloc>().add(
                UpdateTakeaway(widget.sessionId, index, value),
              );
            },
          ),
          onSave: () {},
        );
      },
    );
  }
}
