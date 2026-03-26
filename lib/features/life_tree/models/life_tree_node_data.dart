import 'package:equatable/equatable.dart';

enum LifeTreeNodeType {
  branch,
  leaf
}

class LifeTreeNodeData extends Equatable {
  final String id;
  final String text;
  final String note;
  final String? parentId;
  final LifeTreeNodeType type;

  const LifeTreeNodeData({
    required this.id,
    this.text = '',
    this.note = '',
    this.parentId,
    this.type = LifeTreeNodeType.branch,
  });

  LifeTreeNodeData copyWith({
    String? text,
    String? note,
    String? parentId,
    LifeTreeNodeType? type,
  }) {
    return LifeTreeNodeData(
      id: id,
      text: text ?? this.text,
      note: note ?? this.note,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'note': note,
      'parentId': parentId,
      'type': type.name,
    };
  }

  factory LifeTreeNodeData.fromJson(Map<String, dynamic> json) {
    return LifeTreeNodeData(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      note: json['note'] as String? ?? '',
      parentId: json['parentId'] as String?,
      type: LifeTreeNodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LifeTreeNodeType.branch,
      ),
    );
  }

  @override
  List<Object?> get props => [id, text, note, parentId, type];
}
