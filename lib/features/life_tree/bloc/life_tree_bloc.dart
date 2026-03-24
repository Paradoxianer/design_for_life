import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import '../models/life_tree_node_data.dart';

class LifeTreeState extends EntryListState {
  final Map<String, List<LifeTreeNodeData>> treeNodes;

  const LifeTreeState({
    super.entries = const {},
    super.takeaways = const {},
    this.treeNodes = const {},
  });

  @override
  LifeTreeState copyWith({
    Map<String, List<DflEntry>>? entries,
    Map<String, List<String>>? takeaways,
    Map<String, List<LifeTreeNodeData>>? treeNodes,
  }) {
    return LifeTreeState(
      entries: entries ?? this.entries,
      takeaways: takeaways ?? this.takeaways,
      treeNodes: treeNodes ?? this.treeNodes,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['treeNodes'] = treeNodes.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()));
    return json;
  }

  factory LifeTreeState.fromJson(Map<String, dynamic> json) {
    final base = EntryListState.fromJson(json);
    final treeNodes = (json['treeNodes'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, (v as List).map((e) => LifeTreeNodeData.fromJson(e)).toList()),
        ) ?? {};
    
    return LifeTreeState(
      entries: base.entries,
      takeaways: base.takeaways,
      treeNodes: treeNodes,
    );
  }

  @override
  List<Object?> get props => [...super.props, treeNodes];
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

class DeleteTreeNode extends LifeTreeEvent {
  final String sessionId;
  final String nodeId;
  const DeleteTreeNode(this.sessionId, this.nodeId);
  @override
  List<Object?> get props => [sessionId, nodeId];
}

class LifeTreeBloc extends EntryListBloc {
  LifeTreeBloc() : super() {
    on<AddTreeNode>(_onAddTreeNode);
    on<UpdateTreeNodeText>(_onUpdateTreeNodeText);
    on<DeleteTreeNode>(_onDeleteTreeNode);
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

  void _onDeleteTreeNode(DeleteTreeNode event, Emitter<EntryListState> emit) {
    final nodes = List<LifeTreeNodeData>.from(state.treeNodes[event.sessionId] ?? []);
    nodes.removeWhere((n) => n.id == event.nodeId);
    
    final newMap = Map<String, List<LifeTreeNodeData>>.from(state.treeNodes);
    newMap[event.sessionId] = nodes;
    emit(state.copyWith(treeNodes: newMap));
  }

  @override
  LifeTreeState? fromJson(Map<String, dynamic> json) => LifeTreeState.fromJson(json);
}
