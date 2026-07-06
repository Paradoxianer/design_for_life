import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../models/life_tree_node_data.dart';

/// Reine Graph-Darstellung des digitalen Lebensbaums (Buchheim-Walker-Layout
/// + Knoten-Karten), losgelöst von Zoom/Pan/Screenshot-Infrastruktur. Wird
/// sowohl live in [LifeTreeResult] (innerhalb eines InteractiveViewer) als
/// auch off-screen für den PDF-Export (share_image_generator.dart) genutzt,
/// damit beide Stellen exakt dasselbe Bild erzeugen.
class LifeTreeGraphWidget extends StatefulWidget {
  final List<LifeTreeNodeData> nodes;
  final bool showNotes;

  /// GraphView's node-entrance-Animation (Standard: an) startet bei JEDEM
  /// performLayout() erneut per AnimationController.forward() - während des
  /// Tickens markiert das den Baum als "dirty". Bei captureFromLongWidget()
  /// führt das dazu, dass dessen Retry-Schleife während des Delays einen
  /// zweiten Layout-Durchlauf auslöst; GraphView's interne Kind-Element-
  /// Wiederverwendung (RenderCustomLayoutBox._isInitialized) überspringt beim
  /// zweiten Durchlauf das erneute Bauen/Zuordnen der Knoten-Widgets und wirft
  /// dabei einen Teil der bereits gemounteten Kind-Elemente weg - sichtbar als
  /// fehlende Wurzel und scheinbar falsch verbundene Zweige im Export-Bild.
  /// Die einfache Live-Darstellung nutzt stattdessen ScreenshotController's
  /// einfaches, einmaliges capture() ohne Retry-Schleife und ist davon nicht
  /// betroffen - dort bleibt die Animation daher an (animated: true, Default).
  final bool animated;

  static const double canvasPaddingX = 400.0;
  static const double canvasPaddingY = 200.0;

  const LifeTreeGraphWidget({
    super.key,
    required this.nodes,
    this.showNotes = false,
    this.animated = true,
  });

  @override
  State<LifeTreeGraphWidget> createState() => _LifeTreeGraphWidgetState();
}

class _LifeTreeGraphWidgetState extends State<LifeTreeGraphWidget> {
  final Graph graph = Graph()..isTree = true;
  late BuchheimWalkerConfiguration builder;
  late Algorithm algorithm;
  final Map<String, Node> _nodeCache = {};

  @override
  void initState() {
    super.initState();
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (50)
      ..levelSeparation = (80)
      ..subtreeSeparation = (50)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    algorithm = BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder));
    _syncGraph();
  }

  @override
  void didUpdateWidget(LifeTreeGraphWidget oldWidget) {
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: LifeTreeGraphWidget.canvasPaddingX,
        vertical: LifeTreeGraphWidget.canvasPaddingY,
      ),
      child: GraphView(
        graph: graph,
        algorithm: algorithm,
        animated: widget.animated,
        paint: Paint()
          ..color = Colors.green.shade400
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          final nodeId = node.key?.value as String;
          final nodeData =
              widget.nodes.firstWhere((n) => n.id == nodeId, orElse: () => LifeTreeNodeData(id: nodeId, text: ''));
          return LifeTreeNodeCard(nodeData: nodeData, showNote: widget.showNotes);
        },
      ),
    );
  }
}

class LifeTreeNodeCard extends StatelessWidget {
  final LifeTreeNodeData nodeData;
  final bool showNote;
  const LifeTreeNodeCard({super.key, required this.nodeData, required this.showNote});

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
