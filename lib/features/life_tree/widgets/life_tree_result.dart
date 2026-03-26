import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/widgets/dfl_module_result.dart';
import '../models/life_tree_node_data.dart';

class LifeTreeResult extends StatefulWidget {
  final List<DflEntry> entries;
  final List<LifeTreeNodeData> nodes;
  final List<String> takeaways;
  final Function(int, String)? onUpdate;
  final bool showNotesInitially;

  const LifeTreeResult({
    super.key,
    required this.entries,
    required this.takeaways,
    required this.nodes,
    this.onUpdate,
    this.showNotesInitially = false,
  });

  @override
  State<LifeTreeResult> createState() => _LifeTreeResultState();
}

class _LifeTreeResultState extends State<LifeTreeResult> {
  final Graph graph = Graph()..isTree = true;
  late BuchheimWalkerConfiguration builder;
  late Algorithm algorithm;
  final Map<String, Node> _nodeCache = {};
  final TransformationController _transformationController = TransformationController();
  bool _showNotes = false;

  @override
  void initState() {
    super.initState();
    _showNotes = widget.showNotesInitially;
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (50)
      ..levelSeparation = (80) // Increased to accommodate inline notes
      ..subtreeSeparation = (50)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
    
    algorithm = BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder));
    _syncGraph();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _transformationController.value = Matrix4.identity()..translate(150.0, 50.0);
      }
    });
  }

  @override
  void didUpdateWidget(LifeTreeResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nodes != oldWidget.nodes) {
      _syncGraph();
    }
  }

  void _syncGraph() {
    final Set<String> targetIds = widget.nodes.map((n) => n.id).toSet();
    final currentNodes = List<Node>.from(graph.nodes);
    
    for (var node in currentNodes) {
      final id = node.key?.value as String;
      if (!targetIds.contains(id)) {
        graph.removeNode(node);
        _nodeCache.remove(id);
      }
    }

    for (var nodeData in widget.nodes) {
      final node = _nodeCache.putIfAbsent(nodeData.id, () => Node.Id(nodeData.id));
      if (!graph.nodes.contains(node)) {
        graph.addNode(node);
      }
    }

    graph.edges.clear();
    for (var nodeData in widget.nodes) {
      if (nodeData.parentId != null) {
        final parent = _nodeCache[nodeData.parentId];
        final child = _nodeCache[nodeData.id];
        if (parent != null && child != null) {
          graph.addEdge(parent, child);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DflModuleResult(
      title: 'Mein Lebensbaum',
      takeaways: widget.takeaways,
      onUpdate: widget.onUpdate,
      result: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.nodes.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Digitaler Lebensbaum',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text('Notizen anzeigen', style: theme.textTheme.bodySmall),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _showNotes,
                        onChanged: (v) => setState(() => _showNotes = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              ),
              child: InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(800),
                minScale: 0.1,
                maxScale: 2.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
                  child: GraphView(
                    graph: graph,
                    algorithm: algorithm,
                    paint: Paint()..color = Colors.green.shade400..strokeWidth = 1.5..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      final nodeId = node.key?.value as String;
                      final nodeData = widget.nodes.firstWhere((n) => n.id == nodeId, orElse: () => LifeTreeNodeData(id: nodeId, text: ''));
                      return _ReadOnlyNodeWidget(nodeData: nodeData, showNote: _showNotes);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
          
          Text(
            'Notizen & Zeichnungen',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...widget.entries.map((entry) => _DflEntryReadOnlyWidget(entry: entry)),
        ],
      ),
    );
  }
}

class _ReadOnlyNodeWidget extends StatelessWidget {
  final LifeTreeNodeData nodeData;
  final bool showNote;
  const _ReadOnlyNodeWidget({required this.nodeData, required this.showNote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasNote = nodeData.note.isNotEmpty;
    
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nodeData.text.isEmpty ? '...' : nodeData.text,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (hasNote && showNote) ...[
            const SizedBox(height: 4),
            const Divider(height: 8, thickness: 0.5),
            Text(
              nodeData.note,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 10,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _DflEntryReadOnlyWidget extends StatelessWidget {
  final DflEntry entry;
  const _DflEntryReadOnlyWidget({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.text.isNotEmpty)
            Text(entry.text, style: theme.textTheme.bodyMedium),
          if (entry.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(entry.imagePath!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb || path.startsWith('http')) {
      return Image.network(path, width: double.infinity, height: 200, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: double.infinity, height: 200, fit: BoxFit.cover);
  }
}
