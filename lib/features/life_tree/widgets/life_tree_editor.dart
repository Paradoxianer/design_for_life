import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

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
          l10n.lifeTreeAnalog,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...List.generate(entries.length, (index) {
          final entry = entries[index];
          final isLast = index == entries.length - 1;

          return DflEntryWidget(
            key: ValueKey(entry.id),
            entry: entry,
            hintText: l10n.notesHint,
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
  final TransformationController _transformationController = TransformationController();

  void _enterFullscreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenGraphViewer(
          nodes: widget.nodes,
          onAddNode: widget.onAddNode,
          onUpdateText: widget.onUpdateText,
          onUpdateNote: widget.onUpdateNote,
          onDeleteNode: widget.onDeleteNode,
          initialMatrix: _transformationController.value,
        ),
      ),
    ).then((resultMatrix) {
      if (resultMatrix is Matrix4) {
        _transformationController.value = resultMatrix;
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (widget.nodes.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () {
            widget.onAddNode(null, l10n.lifeTreeBirth);
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.lifeTreeStart),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.lifeTreeDigital, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Stack(
          children: [
            GestureDetector(
              onDoubleTap: _enterFullscreen,
              child: Container(
                height: 500, 
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: _LifeTreeGraphViewOnly(
                  nodes: widget.nodes,
                  onAddNode: widget.onAddNode,
                  onUpdateText: widget.onUpdateText,
                  onUpdateNote: widget.onUpdateNote,
                  onDeleteNode: widget.onDeleteNode,
                  transformationController: _transformationController,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(
                onPressed: _enterFullscreen,
                icon: const Icon(Icons.fullscreen),
                tooltip: l10n.lifeTreeFullscreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LifeTreeGraphViewOnly extends StatefulWidget {
  final List<LifeTreeNodeData> nodes;
  final Function(String?, String) onAddNode;
  final Function(String, String) onUpdateText;
  final Function(String, String) onUpdateNote;
  final Function(String) onDeleteNode;
  final TransformationController? transformationController;

  const _LifeTreeGraphViewOnly({
    required this.nodes,
    required this.onAddNode,
    required this.onUpdateText,
    required this.onUpdateNote,
    required this.onDeleteNode,
    this.transformationController,
  });

  @override
  State<_LifeTreeGraphViewOnly> createState() => _LifeTreeGraphViewOnlyState();
}

class _LifeTreeGraphViewOnlyState extends State<_LifeTreeGraphViewOnly> with TickerProviderStateMixin {
  late Graph graph;
  late BuchheimWalkerConfiguration builder;
  late Algorithm algorithm;
  final Map<String, Node> _nodeCache = {};
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  String? _lastAddedNodeId;
  BoxConstraints? _lastConstraints;
  bool _initialScrollDone = false;

  @override
  void initState() {
    super.initState();
    graph = Graph()..isTree = true;
    _transformationController = widget.transformationController ?? TransformationController();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });

    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (50)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
    
    algorithm = BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder));
    
    _syncGraph();
  }

  @override
  void didUpdateWidget(_LifeTreeGraphViewOnly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nodes != oldWidget.nodes) {
      if (widget.nodes.length > oldWidget.nodes.length) {
        final newNode = widget.nodes.firstWhere(
          (n) => !oldWidget.nodes.any((on) => on.id == n.id),
          orElse: () => widget.nodes.last,
        );
        _lastAddedNodeId = newNode.id;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToNode(newNode.id);
        });
      }
      _syncGraph();
    }
  }

  void _scrollToNode(String nodeId, {bool immediate = false}) {
    if (!mounted || _lastConstraints == null) return;
    
    final node = _nodeCache[nodeId];
    if (node != null) {
      final width = _lastConstraints!.maxWidth;
      final height = _lastConstraints!.maxHeight == double.infinity ? 500.0 : _lastConstraints!.maxHeight;

      final x = node.x;
      final y = node.y;
      
      // Node center (relative to graph origin)
      // Node width is 180, height is 120
      final nodeCenterX = x + 90;
      final nodeCenterY = y + 60;
      
      final viewportCenterX = width / 2;
      final viewportCenterY = height / 2;
      
      const paddingX = 200.0;
      const paddingY = 50.0;

      final targetX = viewportCenterX - (nodeCenterX + paddingX);
      final targetY = viewportCenterY - (nodeCenterY + paddingY);
      
      final targetMatrix = Matrix4.identity()..translate(targetX, targetY);

      if (immediate) {
        _transformationController.value = targetMatrix;
      } else {
        _animation = Matrix4Tween(
          begin: _transformationController.value,
          end: targetMatrix,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOutCubic,
        ));
        
        _animationController.forward(from: 0);
      }
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
  void dispose() {
    _animationController.dispose();
    if (widget.transformationController == null) {
      _transformationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _lastConstraints = constraints;
        if (!_initialScrollDone && widget.nodes.isNotEmpty) {
          _initialScrollDone = true;
          final rootNode = widget.nodes.firstWhere((n) => n.parentId == null, orElse: () => widget.nodes.first);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToNode(rootNode.id, immediate: true);
          });
        }

        return InteractiveViewer(
          transformationController: _transformationController,
          constrained: false, 
          boundaryMargin: const EdgeInsets.all(1000),
          minScale: 0.1,
          maxScale: 2.0,
          onInteractionStart: (_) {
            if (_animationController.isAnimating) {
              _animationController.stop();
            }
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
            child: GraphView(
              graph: graph,
              algorithm: algorithm,
              paint: Paint()..color = Colors.green.shade400..strokeWidth = 1.5..style = PaintingStyle.stroke,
              builder: (Node node) {
                final nodeId = node.key?.value as String;
                final nodeData = widget.nodes.firstWhere((n) => n.id == nodeId, orElse: () => LifeTreeNodeData(id: nodeId, text: '...'));
                
                return _TreeNodeWidget(
                  key: ValueKey('node_wid_$nodeId'),
                  nodeData: nodeData,
                  autofocus: nodeId == _lastAddedNodeId,
                  onChanged: (text) => widget.onUpdateText(nodeId, text),
                  onNoteChanged: (note) => widget.onUpdateNote(nodeId, note),
                  onAddChild: () => widget.onAddNode(nodeId, ''),
                  onAddSibling: () => widget.onAddNode(nodeData.parentId, ''),
                  onDelete: () => widget.onDeleteNode(nodeId),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FullscreenGraphViewer extends StatefulWidget {
  final List<LifeTreeNodeData> nodes;
  final Function(String?, String) onAddNode;
  final Function(String, String) onUpdateText;
  final Function(String, String) onUpdateNote;
  final Function(String) onDeleteNode;
  final Matrix4 initialMatrix;

  const _FullscreenGraphViewer({
    required this.nodes,
    required this.onAddNode,
    required this.onUpdateText,
    required this.onUpdateNote,
    required this.onDeleteNode,
    required this.initialMatrix,
  });

  @override
  State<_FullscreenGraphViewer> createState() => _FullscreenGraphViewerState();
}

class _FullscreenGraphViewerState extends State<_FullscreenGraphViewer> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController(widget.initialMatrix);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lifeTreeDigital),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(_transformationController.value),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen_exit),
            onPressed: () => Navigator.of(context).pop(_transformationController.value),
            tooltip: l10n.lifeTreeExitFullscreen,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: _LifeTreeGraphViewOnly(
          nodes: widget.nodes,
          onAddNode: widget.onAddNode,
          onUpdateText: widget.onUpdateText,
          onUpdateNote: widget.onUpdateNote,
          onDeleteNode: widget.onDeleteNode,
          transformationController: _transformationController,
        ),
      ),
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final LifeTreeNodeData nodeData;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onAddChild;
  final VoidCallback onAddSibling;
  final VoidCallback onDelete;

  const _TreeNodeWidget({
    super.key,
    required this.nodeData,
    this.autofocus = false,
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

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _textFocusNode.requestFocus();
      });
    }
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
    final l10n = AppLocalizations.of(context);
    final bool isFocused = _textFocusNode.hasFocus || _noteFocusNode.hasFocus;
    final bool showButtons = (isFocused || _isHovered) && !_showNoteOverlay;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material( 
        color: Colors.transparent,
        child: SizedBox(
          width: 180, 
          height: 120, 
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _textFocusNode.hasFocus ? theme.primaryColor : Colors.grey.shade300,
                        width: _textFocusNode.hasFocus ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05), 
                          blurRadius: 4, 
                          offset: const Offset(0, 2)
                        ),
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
                                decoration: InputDecoration(
                                  isDense: true, 
                                  border: InputBorder.none, 
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  hintText: l10n.lifeTreeNodeHint,
                                ),
                                style: theme.textTheme.bodyMedium,
                                onSubmitted: (val) => widget.onChanged(val),
                              ),
                            ),
                            Visibility(
                              visible: showButtons,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: IconButton(
                                icon: Icon(Icons.speaker_notes, size: 16, color: theme.primaryColor.withValues(alpha: 0.6)),
                                onPressed: () {
                                  setState(() => _showNoteOverlay = !_showNoteOverlay);
                                  if (_showNoteOverlay) {
                                    _noteFocusNode.requestFocus();
                                  }
                                },
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(right: 8),
                                tooltip: l10n.lifeTreeEditNote,
                              ),
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
                  const SizedBox(height: 4),
                  Visibility(
                    visible: showButtons,
                    maintainSize: true, 
                    maintainAnimation: true,
                    maintainState: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GhostNodeButton(label: l10n.lifeTreeAddChild, onTap: widget.onAddChild),
                        const SizedBox(width: 8),
                        if (widget.nodeData.parentId != null)
                          _GhostNodeButton(label: l10n.lifeTreeAddSibling, onTap: widget.onAddSibling),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (_showNoteOverlay)
                Positioned(
                  top: -10, 
                  child: Container(
                    width: 260, 
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))
                      ],
                      border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.lifeTreeEditNote, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Row(
                              children: [
                                Material(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  child: IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green, size: 20),
                                    onPressed: _saveNote,
                                    padding: const EdgeInsets.all(6),
                                    constraints: const BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.lifeTreeSaveNote,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Material(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                                    onPressed: _deleteNoteAndClose,
                                    padding: const EdgeInsets.all(6),
                                    constraints: const BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.lifeTreeDeleteNote,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _noteController,
                          focusNode: _noteFocusNode,
                          maxLines: 3, 
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: l10n.lifeTreeNoteHint,
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
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
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
