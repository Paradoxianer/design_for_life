part of 'checklist_bloc.dart';

class ChecklistState extends Equatable {
  final List<ChecklistItem> items;

  const ChecklistState({required this.items});

  factory ChecklistState.initial() {
    return ChecklistState(
      items: ChecklistItem.defaultItemIds
          .map((id) => ChecklistItem(id: id))
          .toList(),
    );
  }

  /// Considered done once every item (defaults + any self-added ones) is
  /// checked off - matches how packing/prep checklists are actually used.
  bool get isCompleted =>
      items.isNotEmpty && items.every((item) => item.isChecked);

  ChecklistState copyWith({List<ChecklistItem>? items}) {
    return ChecklistState(items: items ?? this.items);
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((item) => item.toJson()).toList()};
  }

  factory ChecklistState.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>?;
    if (rawItems == null || rawItems.isEmpty) return ChecklistState.initial();

    return ChecklistState(
      items: rawItems
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [items];
}
