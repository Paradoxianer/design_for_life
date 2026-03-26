import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/core/services/share_service.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/life_tree_bloc.dart';
import '../models/life_tree_node_data.dart';
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
    List<LifeTreeNodeData> nodes,
  ) {
    final List<ShareableItem> items = [];
    
    // 1. Key Takeaways
    for (int i = 0; i < takeaways.length; i++) {
      if (takeaways[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'takeaway_$i',
          label: 'Erkenntnis ${i + 1}',
          textValue: takeaways[i],
        ));
      }
    }

    // 2. Tree Structure (Digital)
    if (nodes.isNotEmpty) {
      items.add(const ShareableItem(
        id: 'tree_header',
        label: '--- Digitaler Lebensbaum ---',
        isSelected: true,
      ));
      
      for (var node in nodes) {
        if (node.text.trim().isNotEmpty) {
          String text = node.text;
          if (node.note.trim().isNotEmpty) {
            text += '\nNotiz: ${node.note}';
          }
          items.add(ShareableItem(
            id: 'node_${node.id}',
            label: 'Ereignis: ${node.text}',
            textValue: text,
          ));
        }
      }
    }

    // 3. Entries (Analog/Notes)
    if (entries.isNotEmpty) {
       items.add(const ShareableItem(
        id: 'entries_header',
        label: '--- Notizen & Zeichnungen ---',
        isSelected: true,
      ));
      
      for (var entry in entries) {
        if (entry.text.trim().isNotEmpty || entry.imagePath != null) {
          items.add(ShareableItem(
            id: 'entry_${entry.id}',
            label: 'Notiz',
            textValue: entry.text.isNotEmpty ? entry.text : null,
            imagePath: entry.imagePath,
          ));
        }
      }
    }

    return ShareableContent(title: 'Mein Lebensbaum: $title', items: items);
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

        final shareContent = _getShareableContent(entries, takeaways, nodes);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent,
          onShare: (items) => ShareService.shareContent(
            context: context, 
            content: shareContent, 
            selectedItems: items
          ),
          editor: LifeTreeEditor(
            key: ValueKey('life_tree_editor_$sessionId'),
            sessionId: sessionId,
            entries: displayEntries,
            takeaways: takeaways,
            nodes: nodes,
            onUpdate: (index, value) => context.read<LifeTreeBloc>().add(UpdateTakeaway(sessionId, index, value)),
          ),
          result: LifeTreeResult(
            entries: entries,
            takeaways: takeaways,
            nodes: nodes,
            onUpdate: (index, value) => context.read<LifeTreeBloc>().add(UpdateTakeaway(sessionId, index, value)),
          ),
        );
      },
    );
  }
}
