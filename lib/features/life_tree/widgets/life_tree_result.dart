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

  const LifeTreeResult({
    super.key,
    required this.entries,
    required this.takeaways,
    required this.nodes,
    this.onUpdate,
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

  @override
  void initState() {
    super.initState();
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
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
            Text(
              'Digitaler Lebensbaum',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 450,
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
                      return _ReadOnlyNodeWidget(nodeData: nodeData);
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
  const _ReadOnlyNodeWidget({required this.nodeData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Container(
      width: 160, 
      height: 70, // Fixed size to prevent layout jumps in GraphView
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nodeData.text.isEmpty ? '...' : nodeData.text,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (nodeData.note.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Icon(Icons.speaker_notes, size: 12, color: Colors.grey),
            ],
          ],
        ),
      ),
    );

    if (nodeData.note.isNotEmpty) {
      return Tooltip(
        message: nodeData.note,
        preferBelow: false,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
        child: content,
      );
    }

    return content;
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
