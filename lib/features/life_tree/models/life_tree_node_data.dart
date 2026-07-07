import 'package:equatable/equatable.dart';

class LifeTreeNodeData extends Equatable {
  final String id;
  final String text;
  final String note;
  final String? parentId;

  const LifeTreeNodeData({
    required this.id,
    this.text = '',
    this.note = '',
    this.parentId,
  });

  LifeTreeNodeData copyWith({
    String? text,
    String? note,
    String? parentId,
  }) {
    return LifeTreeNodeData(
      id: id,
      text: text ?? this.text,
      note: note ?? this.note,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'note': note,
      'parentId': parentId,
    };
  }

  factory LifeTreeNodeData.fromJson(Map<String, dynamic> json) {
    return LifeTreeNodeData(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      note: json['note'] as String? ?? '',
      parentId: json['parentId'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, text, note, parentId];
}

/// Filtert Knoten heraus, deren Elternkette (irgendwo weiter oben) einen
/// eingeklappten Knoten enthält (#55). Gemeinsam genutzt vom Editor, der
/// Ergebnisansicht und dem PDF-Export, damit ein eingeklappter Teilbaum
/// überall gleichermaßen verborgen bleibt (z.B. um persönliche Äste vor dem
/// Teilen zu verbergen), statt nur lokal im Editor sichtbar zu sein.
List<LifeTreeNodeData> visibleLifeTreeNodes(
  List<LifeTreeNodeData> nodes,
  Set<String> collapsedNodeIds,
) {
  if (collapsedNodeIds.isEmpty) return nodes;
  final byId = {for (final n in nodes) n.id: n};
  bool isHidden(LifeTreeNodeData node) {
    var current = node;
    while (current.parentId != null) {
      if (collapsedNodeIds.contains(current.parentId)) return true;
      final parent = byId[current.parentId];
      if (parent == null) break;
      current = parent;
    }
    return false;
  }

  return nodes.where((n) => !isHidden(n)).toList();
}
