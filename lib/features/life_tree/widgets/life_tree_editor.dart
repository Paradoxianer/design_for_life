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
    final lifeTreeBloc = BlocProvider.of<LifeTreeBloc>(context);

    return Column(
      key: ValueKey('editor_col_$sessionId'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LifeTreeGraphSection(
          key: ValueKey('graph_section_$sessionId'),
          sessionId: sessionId,
          nodes: nodes,
          onAddNode: (parentId, text) => lifeTreeBloc.add(AddTreeNode(sessionId, parentId: parentId, text: text)),
          onUpdateText: (nodeId, text) => lifeTreeBloc.add(UpdateTreeNodeText(sessionId, nodeId, text)),
          onUpdateNote: (nodeId, note) => lifeTreeBloc.add(UpdateTreeNodeNote(sessionId, nodeId, note)),
          onDeleteNode: (nodeId) => lifeTreeBloc.add(DeleteTreeNode(sessionId, nodeId)),
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 24),
        Text(
          'Notizen & Zeichnungen',
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
            onTextChanged: (text) => lifeTreeBloc.add(UpdateEntryText(sessionId, entry.id, text)),
            onImageChanged: (path) => lifeTreeBloc.add(UpdateEntryImage(sessionId, entry.id, path)),
            onDelete: isLast ? null : () => lifeTreeBloc.add(DeleteEntry(sessionId, entry.id)),
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
  final Function(String, String) onUpdateNote;
  final Function(String) onDeleteNode;

  const _LifeTreeGraphSection({
    super.key,
    required this.sessionId,
    required this.nodes,
    required this.onAddNode,
    required this.onUpdateText,
    required this.onUpdateNote,
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
  final TransformationController _transformationController = TransformationController();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _transformationController.value = Matrix4.identity()..translate(150.0, 50.0);
      }
    });
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
            transformationController: _transformationController,
            constrained: false, 
            boundaryMargin: const EdgeInsets.all(1000),
            minScale: 0.1,
            maxScale: 2.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
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
                    onNoteChanged: (note) => widget.onUpdateNote(nodeId, note),
                    onAddChild: () => widget.onAddNode(nodeId, ''),
                    onAddSibling: () => widget.onAddNode(nodeData.parentId, ''),
                    onDelete: () => widget.onDeleteNode(nodeId),
                  );
                },
              ),
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
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onAddChild;
  final VoidCallback onAddSibling;
  final VoidCallback onDelete;

  const _TreeNodeWidget({
    super.key,
    required this.nodeData,
    required this.onChanged,
    required this.onNoteChanged,
    required this.onAddChild,
    required this.onAddSibling,
    required this.onDelete,
  });

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  late TextEditingController _textController;
  late TextEditingController _noteController;
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  bool _isHovered = false;
  bool _showNoteOverlay = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.nodeData.text);
    _noteController = TextEditingController(text: widget.nodeData.note);
    
    _textFocusNode.addListener(() {
      if (!_textFocusNode.hasFocus && mounted) {
        if (_textController.text != widget.nodeData.text) {
          widget.onChanged(_textController.text);
        }
      }
      setState(() {});
    });

    _noteFocusNode.addListener(() {
      if (!_noteFocusNode.hasFocus && mounted) {
        if (_showNoteOverlay && _noteController.text != widget.nodeData.note) {
          widget.onNoteChanged(_noteController.text);
        }
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(_TreeNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nodeData.text != _textController.text && !_textFocusNode.hasFocus) {
      _textController.text = widget.nodeData.text;
    }
    if (widget.nodeData.note != _noteController.text && !_noteFocusNode.hasFocus) {
      _noteController.text = widget.nodeData.note;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _noteController.dispose();
    _textFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    widget.onNoteChanged(_noteController.text);
    setState(() => _showNoteOverlay = false);
  }

  void _deleteNoteAndClose() {
    _noteController.text = '';
    widget.onNoteChanged('');
    setState(() => _showNoteOverlay = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isFocused = _textFocusNode.hasFocus || _noteFocusNode.hasFocus;
    final bool showButtons = isFocused || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material( 
        color: Colors.transparent,
        child: SizedBox(
          width: 180, 
          height: 100, 
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Main Node Box
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _textFocusNode.hasFocus ? theme.primaryColor : Colors.grey.shade400,
                        width: _textFocusNode.hasFocus ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                focusNode: _textFocusNode,
                                decoration: const InputDecoration(
                                  isDense: true, 
                                  border: InputBorder.none, 
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  hintText: 'Ereignis...',
                                ),
                                style: theme.textTheme.bodyMedium,
                                onSubmitted: (val) => widget.onChanged(val),
                              ),
                            ),
                            if (showButtons)
                              IconButton(
                                icon: Icon(Icons.speaker_notes, size: 16, color: theme.primaryColor.withValues(alpha: 0.6)),
                                onPressed: () {
                                  setState(() => _showNoteOverlay = !_showNoteOverlay);
                                  if (_showNoteOverlay) {
                                    _noteFocusNode.requestFocus();
                                  }
                                },
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(right: 8),
                                tooltip: 'Notiz bearbeiten',
                              ),
                          ],
                        ),
                        if (!_showNoteOverlay && widget.nodeData.note.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
                            child: Text(
                              widget.nodeData.note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ),
                      ],
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
              
              if (_showNoteOverlay)
                Positioned(
                  top: -20, // Positioned over the node
                  child: Container(
                    width: 260, 
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))],
                      border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Notiz bearbeiten', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Row(
                              children: [
                                Material(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  child: IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green, size: 24),
                                    onPressed: _saveNote,
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Speichern',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Material(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.redAccent, size: 24),
                                    onPressed: _deleteNoteAndClose,
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Notiz löschen',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _noteController,
                          focusNode: _noteFocusNode,
                          maxLines: 5,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Deine Gedanken...',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(12),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),

              if (showButtons && widget.nodeData.parentId != null)
                Positioned(
                  top: -8,
                  right: -8,
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
