import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/notes_bloc.dart';
import '../widgets/notes_editor.dart';
import '../widgets/notes_result.dart';

class NotesScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const NotesScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, EntryListState>(
      builder: (context, state) {
        final entries = state.entries[sessionId] ?? [];
        final takeaways = state.takeaways[sessionId] ?? const ['', '', ''];

        final displayEntries = entries.isEmpty 
            ? [DflEntry(id: 'initial_$sessionId')] 
            : entries;

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          editor: NotesEditor(
            sessionId: sessionId,
            entries: displayEntries,
            takeaways: takeaways,
            onUpdate: (index, value) {
              context.read<NotesBloc>().add(
                UpdateTakeaway(sessionId, index, value),
              );
            },
          ),
          result: NotesResult(
            entries: entries,
            takeaways: takeaways,
            onUpdate: (index, value) {
               context.read<NotesBloc>().add(
                UpdateTakeaway(sessionId, index, value),
              );
            },
          ),
        );
      },
    );
  }
}
