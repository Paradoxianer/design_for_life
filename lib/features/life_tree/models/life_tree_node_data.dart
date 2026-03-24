import 'package:equatable/equatable.dart';

class LifeTreeNodeData extends Equatable {
  final String id;
  final String text;
  final String? parentId;

  const LifeTreeNodeData({
    required this.id,
    this.text = '',
    this.parentId,
  });

  LifeTreeNodeData copyWith({
    String? text,
    String? parentId,
  }) {
    return LifeTreeNodeData(
      id: id,
      text: text ?? this.text,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'parentId': parentId,
    };
  }

  factory LifeTreeNodeData.fromJson(Map<String, dynamic> json) {
    return LifeTreeNodeData(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      parentId: json['parentId'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, text, parentId];
}
