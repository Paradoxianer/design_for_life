import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/module_editor.dart';
import '../bloc/notes_bloc.dart';

class NotesEditor extends ModuleEditor {
  final String sessionId;
  final String text;

  const NotesEditor({
    super.key,
    required this.sessionId,
    required this.text,
    required super.takeaways,
    required super.onTakeawayUpdate,
  });

  @override
  Widget buildEditorContent(BuildContext context) {
    return Column(
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
                  UpdateNoteText(sessionId: sessionId, text: value),
                );
          },
        ),
      ],
    );
  }
}
