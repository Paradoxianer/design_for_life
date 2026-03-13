import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/key_takeaway_component.dart';
import '../bloc/notes_bloc.dart';

class NotesScreen extends StatelessWidget {
  final String sessionId;
  final String title;

  const NotesScreen({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        final note = state.notes[sessionId];
        final text = note?.text ?? '';
        final takeaways = note?.takeaways ?? const ['', '', ''];

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  // TODO: Implement sharing
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                const SizedBox(height: 32),
                KeyTakeawayComponent(
                  takeaways: takeaways,
                  onUpdate: (index, value) {
                    context.read<NotesBloc>().add(
                          UpdateTakeaway(
                            sessionId: sessionId,
                            index: index,
                            text: value,
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
