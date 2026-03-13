import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        final note = state.notes[widget.sessionId];
        final text = note?.text ?? '';
        final takeaways = note?.takeaways ?? const ['', '', ''];

        return DflModuleScaffold(
          title: widget.title,
          isEditMode: _isEditMode,
          onToggleMode: () => setState(() => _isEditMode = !_isEditMode),
          editor: NotesEditor(
            sessionId: widget.sessionId,
            text: text,
            takeaways: takeaways,
            onTakeawayUpdate: (index, val) {
              context.read<NotesBloc>().add(
                    UpdateTakeaway(
                      sessionId: widget.sessionId,
                      index: index,
                      text: val,
                    ),
                  );
            },
          ),
          result: NotesResult(
            text: text,
            takeaways: takeaways,
          ),
        );
      },
    );
  }
}
