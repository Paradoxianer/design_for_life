import 'package:equatable/equatable.dart';

/// One item on the participant packing/prep checklist (#82).
///
/// Default items have a fixed [id] and a null [customText] - their label is
/// resolved from l10n at render time (see ChecklistView) so they stay
/// translated even though only the id is persisted. User-added items carry
/// their own literal [customText] instead, since there's no l10n key for
/// free-form text someone typed themselves.
class ChecklistItem extends Equatable {
  static const String personalItems = 'default_personal_items';
  static const String bible = 'default_bible';
  static const String writingUtensils = 'default_writing_utensils';
  static const String casualClothes = 'default_casual_clothes';
  static const String giftsValuesTest = 'default_gifts_values_test';

  static const List<String> defaultItemIds = [
    personalItems,
    bible,
    writingUtensils,
    casualClothes,
    giftsValuesTest,
  ];

  final String id;
  final String? customText;
  final bool isChecked;

  const ChecklistItem({
    required this.id,
    this.customText,
    this.isChecked = false,
  });

  bool get isCustom => customText != null;

  ChecklistItem copyWith({bool? isChecked}) {
    return ChecklistItem(
      id: id,
      customText: customText,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'customText': customText, 'isChecked': isChecked};
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      customText: json['customText'] as String?,
      isChecked: json['isChecked'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, customText, isChecked];
}
