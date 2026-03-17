import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
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
  late TextEditingController _takeawayController;

  @override
  void initState() {
    super.initState();
    _takeawayController = TextEditingController();
  }

  @override
  void dispose() {
    _takeawayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        final note = state.notes[widget.sessionId];
        if (note != null) {
          final newContent = note.takeaways.join('\n');
          if (_takeawayController.text != newContent) {
            _takeawayController.text = newContent;
          }
        }
      },
      builder: (context, state) {
        final note = state.notes[widget.sessionId];
        final text = note?.text ?? '';
        final takeaways = note?.takeaways ?? const [];
        final imagePaths = note?.imagePaths ?? const [];

        return DflModuleScaffold(
          title: widget.title,
          onSave: () {
            // Manual save if needed
          },
          editor: NotesEditor(
            sessionId: widget.sessionId,
            text: text,
            imagePaths: imagePaths,
            takeaways: takeaways,
            takeawayController: _takeawayController,
            onUpdate: (index, value) {
              context.read<NotesBloc>().add(
                UpdateTakeaway(
                  sessionId: widget.sessionId,
                  index: index,
                  text: value,
                ),
              );
            },
          ),
          result: NotesResult(
            text: text,
            imagePaths: imagePaths,
            takeaways: takeaways,
            takeawayController: _takeawayController,
            onUpdate: (index, value) {},
          ),
        );
      },
    );
  }
}
