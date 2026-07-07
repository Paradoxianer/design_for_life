import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
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
  final ScreenshotController _screenshotController = ScreenshotController();

  ShareableContent _getShareableContent(
    BuildContext context,
    List<DflEntry> entries,
    List<String> takeaways,
    List<LifeTreeNodeData> nodes,
  ) {
    final l10n = AppLocalizations.of(context);
    final List<ShareableItem> items = [];

    // 1. Key Takeaways (werden im ShareService als Text formatiert)
    for (int i = 0; i < takeaways.length; i++) {
      if (takeaways[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'takeaway_$i',
          label: l10n.shareInsightItem(i + 1),
          textValue: takeaways[i],
        ));
      }
    }

    // 2. Digitaler Baum (Grafik)
    if (nodes.isNotEmpty) {
      items.add(ShareableItem(
        id: 'tree_graph',
        label: l10n.lifeTreeShareGraph,
        isSelected: true,
        data: { 'type': 'life_tree_graph' },
      ));
    }

    // 3. Einträge (Analog/Notizen/Zeichnungen)
    for (var entry in entries) {
      if (entry.text.trim().isNotEmpty || entry.imagePath != null) {
        items.add(ShareableItem(
          id: 'entry_${entry.id}',
          label: l10n.shareNoteOrDrawing,
          textValue: entry.text.isNotEmpty ? entry.text : null,
          imagePath: entry.imagePath,
        ));
      }
    }

    return ShareableContent(title: '${l10n.lifeTreeTitle}: ${widget.title}', items: items);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifeTreeBloc, EntryListState>(
      builder: (context, state) {
        final lifeTreeState = state as LifeTreeState;
        final entries = lifeTreeState.entries[widget.sessionId] ?? [];
        final takeaways = lifeTreeState.takeaways[widget.sessionId] ?? const ['', '', ''];
        final nodes = lifeTreeState.treeNodes[widget.sessionId] ?? [];
        // In der Ergebnisansicht/beim Teilen bleiben eingeklappte Teilbäume
        // verborgen (#55) - z.B. um persönliche Äste vor anderen zu
        // verbergen. Der Editor selbst filtert unabhängig davon nochmal
        // selbst, da dort auch das Auf-/Zuklappen bedient wird.
        final visibleNodes = visibleLifeTreeNodes(
          nodes,
          lifeTreeState.collapsedNodeIds[widget.sessionId] ?? const {},
        );

        final displayEntries = entries.isEmpty 
            ? [DflEntry(id: 'initial_${widget.sessionId}')] 
            : entries;

        return DflModuleScaffold(
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          shareableContent: _getShareableContent(context, entries, takeaways, visibleNodes),
          onShare: (selectedItems) async {
            Uint8List? capturedImage;
            
            // Wenn die Grafik ausgewählt wurde, machen wir JETZT den Screenshot
            if (selectedItems.any((i) => i.id == 'tree_graph')) {
              try {
                // Ein kurzer Moment für das System, um den Layer-Buffer bereitzustellen
                await Future.delayed(const Duration(milliseconds: 150));
                capturedImage = await _screenshotController.capture();
                if (capturedImage == null) {
                   debugPrint('Screenshot returned null - retrying once...');
                   capturedImage = await _screenshotController.capture();
                }
              } catch (e) {
                debugPrint('Error during screenshot capture: $e');
              }
            }

            if (mounted) {
              // Wir übergeben das Bild in den Daten des entsprechenden Items
              final enrichedItems = selectedItems.map((si) {
                if (si.id == 'tree_graph' && capturedImage != null) {
                  return si.copyWith(data: {
                    ...si.data,
                    'capturedImage': capturedImage,
                  });
                }
                return si;
              }).toList();

              ShareService.shareContent(
                context: context,
                content: _getShareableContent(context, entries, takeaways, visibleNodes),
                selectedItems: enrichedItems
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
            nodes: visibleNodes,
            screenshotController: _screenshotController,
            onUpdate: (index, value) => context.read<LifeTreeBloc>().add(UpdateTakeaway(widget.sessionId, index, value)),
          ),
        );
      },
    );
  }
}
