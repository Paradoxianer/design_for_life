import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import '../models/life_tree_node_data.dart';

class LifeTreeState extends EntryListState {
  final Map<String, List<LifeTreeNodeData>> treeNodes;
  // Eingeklappte Teilbäume pro Session (#55) - bewusst im (hydrated)
  // Bloc-State statt nur lokal im Editor-Widget, damit derselbe Zustand auch
  // in der Ergebnisansicht und beim Teilen/Export gilt (z.B. um persönliche
  // Äste dort zu verbergen) und über App-Neustarts hinweg erhalten bleibt.
  final Map<String, Set<String>> collapsedNodeIds;

  const LifeTreeState({
    super.entries = const {},
    super.takeaways = const {},
    this.treeNodes = const {},
    this.collapsedNodeIds = const {},
  });

  @override
  bool isCompleted(String sessionId) {
    // A life tree is completed if there are analog entries OR digital tree nodes with text
    final hasAnalog = super.isCompleted(sessionId);
    final nodes = treeNodes[sessionId] ?? [];
    final hasDigital = nodes.any((n) => n.text.trim().isNotEmpty);
    return hasAnalog || hasDigital;
  }

  @override
  LifeTreeState copyWith({
    Map<String, List<DflEntry>>? entries,
    Map<String, List<String>>? takeaways,
    Map<String, List<LifeTreeNodeData>>? treeNodes,
    Map<String, Set<String>>? collapsedNodeIds,
  }) {
    return LifeTreeState(
      entries: entries ?? this.entries,
      takeaways: takeaways ?? this.takeaways,
      treeNodes: treeNodes ?? this.treeNodes,
      collapsedNodeIds: collapsedNodeIds ?? this.collapsedNodeIds,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['treeNodes'] = treeNodes.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
    json['collapsedNodeIds'] = collapsedNodeIds.map((k, v) => MapEntry(k, v.toList()));
    return json;
  }

  factory LifeTreeState.fromJson(Map<String, dynamic> json) {
    final base = EntryListState.fromJson(json);
    final treeNodes = (json['treeNodes'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, (v as List).map((e) => LifeTreeNodeData.fromJson(e)).toList()),
        ) ?? {};
    final collapsedNodeIds = (json['collapsedNodeIds'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, (v as List).cast<String>().toSet()),
        ) ?? {};

    return LifeTreeState(
      entries: base.entries,
      takeaways: base.takeaways,
      treeNodes: treeNodes,
      collapsedNodeIds: collapsedNodeIds,
    );
  }

  @override
  List<Object?> get props => [...super.props, treeNodes, collapsedNodeIds];
}

abstract class LifeTreeEvent extends EntryListEvent {
  const LifeTreeEvent();
}

class AddTreeNode extends LifeTreeEvent {
  final String sessionId;
  final String? parentId;
  final String text;
  const AddTreeNode(this.sessionId, {this.parentId, this.text = ''});
  @override
  List<Object?> get props => [sessionId, parentId, text];
}

class UpdateTreeNodeText extends LifeTreeEvent {
  final String sessionId;
  final String nodeId;
  final String text;
  const UpdateTreeNodeText(this.sessionId, this.nodeId, this.text);
  @override
  List<Object?> get props => [sessionId, nodeId, text];
}

class UpdateTreeNodeNote extends LifeTreeEvent {
  final String sessionId;
  final String nodeId;
  final String note;
  const UpdateTreeNodeNote(this.sessionId, this.nodeId, this.note);
  @override
  List<Object?> get props => [sessionId, nodeId, note];
}

class DeleteTreeNode extends LifeTreeEvent {
  final String sessionId;
  final String nodeId;
  const DeleteTreeNode(this.sessionId, this.nodeId);
  @override
  List<Object?> get props => [sessionId, nodeId];
}

class ToggleTreeNodeCollapsed extends LifeTreeEvent {
  final String sessionId;
  final String nodeId;
  const ToggleTreeNodeCollapsed(this.sessionId, this.nodeId);
  @override
  List<Object?> get props => [sessionId, nodeId];
}

class LifeTreeBloc extends EntryListBloc {
  LifeTreeBloc() : super(const LifeTreeState()) {
    on<AddTreeNode>(_onAddTreeNode);
    on<UpdateTreeNodeText>(_onUpdateTreeNodeText);
    on<UpdateTreeNodeNote>(_onUpdateTreeNodeNote);
    on<DeleteTreeNode>(_onDeleteTreeNode);
    on<ToggleTreeNodeCollapsed>(_onToggleTreeNodeCollapsed);
  }

  @override
  LifeTreeState get state => super.state as LifeTreeState;

  void _onAddTreeNode(AddTreeNode event, Emitter<EntryListState> emit) {
    final nodes = List<LifeTreeNodeData>.from(state.treeNodes[event.sessionId] ?? []);
    final newNode = LifeTreeNodeData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: event.parentId,
      text: event.text,
    );
    nodes.add(newNode);

    final newMap = Map<String, List<LifeTreeNodeData>>.from(state.treeNodes);
    newMap[event.sessionId] = nodes;
    emit(state.copyWith(treeNodes: newMap));
  }

  void _onUpdateTreeNodeText(UpdateTreeNodeText event, Emitter<EntryListState> emit) {
    final nodes = List<LifeTreeNodeData>.from(state.treeNodes[event.sessionId] ?? []);
    final index = nodes.indexWhere((n) => n.id == event.nodeId);
    if (index != -1) {
      nodes[index] = nodes[index].copyWith(text: event.text);
      final newMap = Map<String, List<LifeTreeNodeData>>.from(state.treeNodes);
      newMap[event.sessionId] = nodes;
      emit(state.copyWith(treeNodes: newMap));
    }
  }

  void _onUpdateTreeNodeNote(UpdateTreeNodeNote event, Emitter<EntryListState> emit) {
    final nodes = List<LifeTreeNodeData>.from(state.treeNodes[event.sessionId] ?? []);
    final index = nodes.indexWhere((n) => n.id == event.nodeId);
    if (index != -1) {
      nodes[index] = nodes[index].copyWith(note: event.note);
      final newMap = Map<String, List<LifeTreeNodeData>>.from(state.treeNodes);
      newMap[event.sessionId] = nodes;
      emit(state.copyWith(treeNodes: newMap));
    }
  }

  void _onDeleteTreeNode(DeleteTreeNode event, Emitter<EntryListState> emit) {
    final nodes = List<LifeTreeNodeData>.from(state.treeNodes[event.sessionId] ?? []);
    nodes.removeWhere((n) => n.id == event.nodeId);
    
    final newMap = Map<String, List<LifeTreeNodeData>>.from(state.treeNodes);
    newMap[event.sessionId] = nodes;
    emit(state.copyWith(treeNodes: newMap));
  }

  void _onToggleTreeNodeCollapsed(ToggleTreeNodeCollapsed event, Emitter<EntryListState> emit) {
    final collapsed = Set<String>.from(state.collapsedNodeIds[event.sessionId] ?? const {});
    if (!collapsed.remove(event.nodeId)) {
      collapsed.add(event.nodeId);
    }
    final newMap = Map<String, Set<String>>.from(state.collapsedNodeIds);
    newMap[event.sessionId] = collapsed;
    emit(state.copyWith(collapsedNodeIds: newMap));
  }

  @override
  LifeTreeState? fromJson(Map<String, dynamic> json) => LifeTreeState.fromJson(json);
}
