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
  final bool initialEditMode;

  const NotesScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialEditMode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, EntryListState>(
      builder: (context, state) {
        final entries = state.entries[widget.sessionId] ?? [];
        final takeaways = state.takeaways[widget.sessionId] ?? const ['', '', ''];

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
