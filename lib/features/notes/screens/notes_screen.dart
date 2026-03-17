import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/notes_bloc.dart';
import '../widgets/notes_editor.dart';
import '../widgets/notes_result.dart';

class NotesScreen extends StatefulWidget {
  final String sessionId;
  final String title;

  const NotesScreen({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isEditMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, EntryListState>(
      builder: (context, state) {
        final entries = state.entries[widget.sessionId] ?? [];
        final takeaways = state.takeaways[widget.sessionId] ?? const ['', '', ''];

        // Sicherstellen, dass im Edit-Modus immer mindestens ein Feld da ist
        final displayEntries = entries.isEmpty 
            ? [DflEntry(id: 'initial_${widget.sessionId}')] 
            : entries;

        return DflModuleScaffold(
          title: widget.title,
          isEditMode: _isEditMode,
          onToggleMode: () => setState(() => _isEditMode = !_isEditMode),
          editor: NotesEditor(
            sessionId: widget.sessionId,
            entries: displayEntries,
            takeaways: takeaways,
            onUpdate: (index, value) {
              context.read<NotesBloc>().add(
                UpdateTakeaway(widget.sessionId, index, value),
              );
            },
          ),
          result: NotesResult(
            entries: entries,
            takeaways: takeaways,
            onUpdate: (index, value) {
               context.read<NotesBloc>().add(
                UpdateTakeaway(widget.sessionId, index, value),
              );
            },
          ),
        );
      },
    );
  }
}
