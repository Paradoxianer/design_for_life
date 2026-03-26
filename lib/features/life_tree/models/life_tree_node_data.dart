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
