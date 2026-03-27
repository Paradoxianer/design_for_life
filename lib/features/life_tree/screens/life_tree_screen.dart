import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
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
  final ScreenshotController _screenshotController = ScreenshotController();

  ShareableContent _getShareableContent(
    List<DflEntry> entries, 
    List<String> takeaways,
    List<LifeTreeNodeData> nodes,
    Uint8List? capturedGraph,
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
      items.add(ShareableItem(
        id: 'tree_graph',
        label: 'Digitaler Lebensbaum (Grafik)',
        isSelected: true,
        data: {
          'type': 'life_tree_graph',
          'nodes': nodes,
          'showNotes': _shareIncludeNotes,
          'capturedImage': capturedGraph, // Hier übergeben wir das echte Bild
        },
      ));

      items.add(ShareableItem(
        id: 'tree_include_notes',
        label: 'Notizen im Baum anzeigen',
        isSelected: _shareIncludeNotes,
      ));
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

        return DflModuleScaffold(
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          shareableContent: _getShareableContent(entries, takeaways, nodes, null),
          onShare: (selectedItems) async {
            // 1. Falls der Graph gewählt wurde, machen wir JETZT den Screenshot vom echten Widget
            Uint8List? capturedImage;
            final hasGraph = selectedItems.any((i) => i.id == 'tree_graph');
            
            if (hasGraph) {
              try {
                // Wir warten kurz, um sicherzugehen, dass das UI stabil ist
                capturedImage = await _screenshotController.capture();
              } catch (e) {
                debugPrint('Screenshot failed: $e');
              }
            }

            // 2. Wir bauen den Content neu zusammen, diesmal mit dem echten Bild-Byte-Array
            final fullContent = _getShareableContent(entries, takeaways, nodes, capturedImage);
            
            // 3. Update toggle state
            final notesItem = selectedItems.firstWhere((i) => i.id == 'tree_include_notes', orElse: () => const ShareableItem(id: 'none', label: ''));
            if (notesItem.id != 'none') {
              setState(() => _shareIncludeNotes = notesItem.isSelected);
            }
            
            // 4. Teilen auslösen
            if (mounted) {
              ShareService.shareContent(
                context: context, 
                content: fullContent, 
                selectedItems: selectedItems.map((si) {
                  // Wir müssen sicherstellen, dass das 'tree_graph' Item das Bild in seinen Daten hat
                  if (si.id == 'tree_graph') {
                    return si.copyWith(data: {
                      ...si.data,
                      'capturedImage': capturedImage,
                    });
                  }
                  return si;
                }).toList(),
              );
            }
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
            screenshotController: _screenshotController, // Controller weitergeben
            onUpdate: (index, value) => context.read<LifeTreeBloc>().add(UpdateTakeaway(widget.sessionId, index, value)),
          ),
        );
      },
    );
  }
}
