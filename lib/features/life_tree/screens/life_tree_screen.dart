import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/core/services/share_service.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/life_tree_bloc.dart';
import '../widgets/life_tree_editor.dart';
import '../widgets/life_tree_result.dart';

class LifeTreeScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const LifeTreeScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _getShareableContent(
    List<DflEntry> entries, 
    List<String> takeaways,
    String? treeImagePath,
  ) {
    final List<ShareableItem> items = [];

    // Add Key Takeaways
    for (int i = 0; i < takeaways.length; i++) {
      if (takeaways[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'life_tree_takeaway_$i',
          label: 'Erkenntnis ${i + 1}',
          textValue: takeaways[i],
        ));
      }
    }

    // Add Analog Entries
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (entry.text.trim().isNotEmpty || entry.imagePath != null) {
        items.add(ShareableItem(
          id: 'life_tree_entry_${entry.id}',
          label: 'Notiz ${i + 1}',
          textValue: entry.text.isNotEmpty ? entry.text : null,
          imagePath: entry.imagePath,
        ));
      }
    }

    if (treeImagePath != null) {
      items.add(ShareableItem(
        id: 'life_tree_digital',
        label: 'Digitaler Lebensbaum',
        imagePath: treeImagePath,
      ));
    }

    return ShareableContent(
      title: 'Mein Lebensbaum: $title',
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifeTreeBloc, EntryListState>(
      builder: (context, state) {
        final lifeTreeState = state as LifeTreeState;
        final entries = lifeTreeState.entries[sessionId] ?? [];
        final takeaways = lifeTreeState.takeaways[sessionId] ?? const ['', '', ''];
        final nodes = lifeTreeState.treeNodes[sessionId] ?? [];

        final displayEntries = entries.isEmpty 
            ? [DflEntry(id: 'initial_$sessionId')] 
            : entries;

        final shareContent = _getShareableContent(entries, takeaways, null);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) {
            ShareService.shareContent(
              context: context,
              content: shareContent,
              selectedItems: selectedItems,
            );
          },
          editor: LifeTreeEditor(
            sessionId: sessionId,
            entries: displayEntries,
            takeaways: takeaways,
            nodes: nodes,
            onUpdate: (index, value) {
              context.read<LifeTreeBloc>().add(
                UpdateTakeaway(sessionId, index, value),
              );
            },
          ),
          result: LifeTreeResult(
            entries: entries,
            takeaways: takeaways,
            nodes: nodes,
            onUpdate: (index, value) {
              context.read<LifeTreeBloc>().add(
                UpdateTakeaway(sessionId, index, value),
              );
            },
          ),
        );
      },
    );
  }
}
