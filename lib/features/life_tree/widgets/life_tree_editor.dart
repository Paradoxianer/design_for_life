import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../../../core/widgets/dfl_entry_widget.dart';
import '../bloc/life_tree_bloc.dart';
import '../models/life_tree_node_data.dart';

class LifeTreeEditor extends DflModuleEditor {
  final String sessionId;
  final List<DflEntry> entries;
  final List<LifeTreeNodeData> nodes;

  const LifeTreeEditor({
    super.key,
    required this.sessionId,
    required this.entries,
    required this.nodes,
    required super.takeaways,
    required super.onUpdate,
  });

  @override
  Widget buildContent(BuildContext context) {
    final bloc = context.read<LifeTreeBloc>();

    return Column(
      key: ValueKey('editor_col_$sessionId'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LifeTreeGraphSection(
          key: ValueKey('graph_section_$sessionId'),
          sessionId: sessionId,
          nodes: nodes,
          onAddNode: (parentId, text) => bloc.add(AddTreeNode(sessionId, parentId: parentId, text: text)),
          onUpdateText: (nodeId, text) => bloc.add(UpdateTreeNodeText(sessionId, nodeId, text)),
          onDeleteNode: (nodeId) => bloc.add(DeleteTreeNode(sessionId, nodeId)),
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 24),
        Text(
          'Analoge Notizen & Zeichnungen',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...List.generate(entries.length, (index) {
          final entry = entries[index];
          final isLast = index == entries.length - 1;

          return DflEntryWidget(
            key: ValueKey(entry.id),
            entry: entry,
            hintText: 'Notiz oder Beschreibung...',
            onTextChanged: (text) => bloc.add(UpdateEntryText(sessionId, entry.id, text)),
            onImageChanged: (path) => bloc.add(UpdateEntryImage(sessionId, entry.id, path)),
            onDelete: isLast ? null : () => bloc.add(DeleteEntry(sessionId, entry.id)),
          );
        }),
      ],
    );
  }
}

class _LifeTreeGraphSection extends StatefulWidget {
  final String sessionId;
  final List<LifeTreeNodeData> nodes;
  final Function(String?, String) onAddNode;
  final Function(String, String) onUpdateText;
  final Function(String) onDeleteNode;

  const _LifeTreeGraphSection({
    super.key,
    required this.sessionId,
    required this.nodes,
    required this.onAddNode,
    required this.onUpdateText,
    required this.onDeleteNode,
  });

  @override
  State<_LifeTreeGraphSection> createState() => _LifeTreeGraphSectionState();
}

class _LifeTreeGraphSectionState extends State<_LifeTreeGraphSection> {
  late Graph graph;
  late BuchheimWalkerConfiguration builder;
  late Algorithm algorithm;
  final Map<String, Node> _nodeCache = {};

  @override
  void initState() {
    super.initState();
    graph = Graph()..isTree = true;
    
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (50)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
    
    algorithm = BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder));
    
    _syncGraph();
  }

  @override
  void didUpdateWidget(_LifeTreeGraphSection oldWidget) {
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
    if (widget.nodes.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () => widget.onAddNode(null, 'Geburt'),
          icon: const Icon(Icons.add),
          label: const Text('Lebensbaum starten (Geburt)'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Digitaler Lebensbaum', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 500, 
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: InteractiveViewer(
            constrained: false, 
            boundaryMargin: const EdgeInsets.all(400),
            minScale: 0.01,
            maxScale: 2.0,
            child: GraphView(
              graph: graph,
              algorithm: algorithm,
              paint: Paint()..color = Colors.green..strokeWidth = 1..style = PaintingStyle.stroke,
              builder: (Node node) {
                final nodeId = node.key?.value as String;
                final nodeData = widget.nodes.firstWhere((n) => n.id == nodeId, orElse: () => LifeTreeNodeData(id: nodeId, text: '...'));
                
                return _TreeNodeWidget(
                  key: ValueKey('node_wid_$nodeId'),
                  nodeData: nodeData,
                  onChanged: (text) => widget.onUpdateText(nodeId, text),
                  onAddChild: () => widget.onAddNode(nodeId, ''),
                  onAddSibling: () => widget.onAddNode(nodeData.parentId, ''),
                  onDelete: () => widget.onDeleteNode(nodeId),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final LifeTreeNodeData nodeData;
  final ValueChanged<String> onChanged;
  final VoidCallback onAddChild;
  final VoidCallback onAddSibling;
  final VoidCallback onDelete;

  const _TreeNodeWidget({
    super.key,
    required this.nodeData,
    required this.onChanged,
    required this.onAddChild,
    required this.onAddSibling,
    required this.onDelete,
  });

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nodeData.text);
    _focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(_TreeNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nodeData.text != _controller.text && !_focusNode.hasFocus) {
      _controller.text = widget.nodeData.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool showButtons = _isFocused || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material( 
        color: Colors.transparent,
        child: Container(
          width: 200, 
          height: 100, 
          padding: const EdgeInsets.all(8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isFocused ? theme.primaryColor : Colors.grey.shade400,
                        width: _isFocused ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        isDense: true, 
                        border: InputBorder.none, 
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                      ),
                      style: theme.textTheme.bodyMedium,
                      onChanged: widget.onChanged,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: showButtons,
                    maintainSize: true, 
                    maintainAnimation: true,
                    maintainState: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GhostNodeButton(label: '+ Kind', onTap: widget.onAddChild),
                        const SizedBox(width: 8),
                        if (widget.nodeData.parentId != null)
                          _GhostNodeButton(label: '+ Geschwister', onTap: widget.onAddSibling),
                      ],
                    ),
                  ),
                ],
              ),
              // Delete Button (x) in the top right corner
              if (showButtons && widget.nodeData.parentId != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: _GhostNodeButton(
                    label: 'x', 
                    onTap: widget.onDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostNodeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GhostNodeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
