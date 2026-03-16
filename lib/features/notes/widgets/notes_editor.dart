import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../bloc/notes_bloc.dart';

class NotesEditor extends DflModuleEditor {
  final String sessionId;
  final String text;
  final List<String> imagePaths;

  const NotesEditor({
    super.key,
    required this.sessionId,
    required this.text,
    required this.imagePaths,
    required super.takeaways,
    required super.onUpdate,
    required super.takeawayController,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.notesGuidance,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(l10n.notes, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: TextEditingController(text: text)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: text.length),
              ),
            maxLines: null,
            decoration: InputDecoration(
              hintText: l10n.notesHint,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              context.read<NotesBloc>().add(
                    UpdateNoteText(sessionId: sessionId, text: value),
                  );
            },
          ),
        ),
        const SizedBox(height: 24),
        Text(l10n.photosAndSlides, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _ImageGrid(
          imagePaths: imagePaths,
          onAdd: () async {
            final picker = ImagePicker();
            final image = await picker.pickImage(source: ImageSource.camera);
            if (image != null) {
              // TODO: Logic for saving image path to bloc
            }
          },
        ),
      ],
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<String> imagePaths;
  final VoidCallback onAdd;

  const _ImageGrid({required this.imagePaths, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...imagePaths.map((path) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover),
                ),
              )),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
