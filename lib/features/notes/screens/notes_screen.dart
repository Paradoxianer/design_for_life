import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/core/services/share_service.dart';
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

  ShareableContent _getShareableContent(List<DflEntry> entries, List<String> takeaways) {
    final List<ShareableItem> items = [];

    // Add Key Takeaways first
    for (int i = 0; i < takeaways.length; i++) {
      if (takeaways[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'note_takeaway_$i',
          label: 'Erkenntnis ${i + 1}',
          textValue: takeaways[i],
        ));
      }
    }

    // Add Note Entries (Text and Images)
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final hasText = entry.text.trim().isNotEmpty;
      final hasImage = entry.imagePath != null && entry.imagePath!.isNotEmpty;

      if (hasText || hasImage) {
        items.add(ShareableItem(
          id: 'note_entry_${entry.id}',
          label: 'Notiz ${i + 1}',
          textValue: hasText ? entry.text : null,
          imagePath: hasImage ? entry.imagePath : null,
        ));
      }
    }

    return ShareableContent(
      title: 'Meine Notizen: $title',
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, EntryListState>(
      builder: (context, state) {
        final entries = state.entries[sessionId] ?? [];
        final takeaways = state.takeaways[sessionId] ?? const ['', '', ''];

        final displayEntries = entries.isEmpty 
            ? [DflEntry(id: 'initial_$sessionId')] 
            : entries;

        final shareContent = _getShareableContent(entries, takeaways);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) {
            ShareService.shareContent(
              content: shareContent,
              selectedItems: selectedItems,
            );
          },
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
