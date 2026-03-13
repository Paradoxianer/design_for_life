import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/module_scaffold.dart';
import '../bloc/notes_bloc.dart';

class NotesModuleScreen extends StatefulWidget {
  final String sessionId;
  final String title;

  const NotesModuleScreen({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  State<NotesModuleScreen> createState() => _NotesModuleScreenState();
}

class _NotesModuleScreenState extends State<NotesModuleScreen> {
  bool _isEditMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        final note = state.notes[widget.sessionId];
        final text = note?.text ?? '';
        final takeaways = note?.takeaways ?? const ['', '', ''];

        return ModuleScaffold(
          title: widget.title,
          isEditMode: _isEditMode,
          onToggleMode: () => setState(() => _isEditMode = !_isEditMode),
          takeaways: takeaways,
          onTakeawayUpdate: (index, value) {
            context.read<NotesBloc>().add(
                  UpdateTakeaway(
                    sessionId: widget.sessionId,
                    index: index,
                    text: value,
                  ),
                );
          },
          editor: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: text)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: text.length),
                  ),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Write down what stands out to you...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<NotesBloc>().add(
                        UpdateNoteText(sessionId: widget.sessionId, text: value),
                      );
                },
              ),
            ],
          ),
          result: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notes Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                text.isEmpty ? '_No notes recorded._' : text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}
