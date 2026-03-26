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

class LifeTreeScreen extends StatefulWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const LifeTreeScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<LifeTreeScreen> createState() => _LifeTreeScreenState();
}

class _LifeTreeScreenState extends State<LifeTreeScreen> {
  bool _shareIncludeNotes = false;

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
      // Grafik-Item (Das Bild vom Baum)
      items.add(ShareableItem(
        id: 'tree_graph',
        label: 'Digitaler Lebensbaum (Grafik)',
        isSelected: true,
        data: {
          'type': 'life_tree_graph',
          'nodes': nodes,
          'showNotes': _shareIncludeNotes,
        },
      ));

      // Toggle for nodes in share selection
      items.add(ShareableItem(
        id: 'tree_include_notes',
        label: 'Notizen im Baum anzeigen',
        isSelected: _shareIncludeNotes,
      ));
      
      // Textuelle Liste der Ereignisse (Optional, falls jemand nur Text will)
      for (var node in nodes) {
        if (node.text.trim().isNotEmpty) {
          String text = node.text;
          if (_shareIncludeNotes && node.note.trim().isNotEmpty) {
            text += '\nNotiz: ${node.note}';
          }
          items.add(ShareableItem(
            id: 'node_${node.id}',
            label: 'Ereignis: ${node.text}',
            textValue: text,
            isSelected: false, // Default text nodes to unselected if graph is present
          ));
        }
      }
    }

    // 3. Entries (Analog/Notes)
    if (entries.isNotEmpty) {
      for (var entry in entries) {
        if (entry.text.trim().isNotEmpty || entry.imagePath != null) {
          items.add(ShareableItem(
            id: 'entry_${entry.id}',
            label: 'Notiz / Zeichnung',
            textValue: entry.text.isNotEmpty ? entry.text : null,
            imagePath: entry.imagePath,
          ));
        }
      }
    }

    return ShareableContent(title: 'Mein Lebensbaum: ${widget.title}', items: items);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifeTreeBloc, EntryListState>(
      builder: (context, state) {
        final lifeTreeState = state as LifeTreeState;
        final entries = lifeTreeState.entries[widget.sessionId] ?? [];
        final takeaways = lifeTreeState.takeaways[widget.sessionId] ?? const ['', '', ''];
        final nodes = lifeTreeState.treeNodes[widget.sessionId] ?? [];

        final displayEntries = entries.isEmpty 
            ? [DflEntry(id: 'initial_${widget.sessionId}')] 
            : entries;

        final shareContent = _getShareableContent(entries, takeaways, nodes);

        return DflModuleScaffold(
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          shareableContent: shareContent,
          onShare: (items) {
            // Update the notes toggle based on user selection in dialog
            final notesItem = items.firstWhere((i) => i.id == 'tree_include_notes', orElse: () => const ShareableItem(id: 'none', label: ''));
            if (notesItem.id != 'none') {
              setState(() => _shareIncludeNotes = notesItem.isSelected);
            }
            
            ShareService.shareContent(
              context: context, 
              content: shareContent, 
              selectedItems: items
            );
          },
          editor: LifeTreeEditor(
            key: ValueKey('life_tree_editor_${widget.sessionId}'),
            sessionId: widget.sessionId,
            entries: displayEntries,
            takeaways: takeaways,
            nodes: nodes,
            onUpdate: (index, value) => context.read<LifeTreeBloc>().add(UpdateTakeaway(widget.sessionId, index, value)),
          ),
          result: LifeTreeResult(
            entries: entries,
            takeaways: takeaways,
            nodes: nodes,
            onUpdate: (index, value) => context.read<LifeTreeBloc>().add(UpdateTakeaway(widget.sessionId, index, value)),
          ),
        );
      },
    );
  }
}
