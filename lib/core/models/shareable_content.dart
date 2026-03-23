import 'package:equatable/equatable.dart';

class ShareableItem extends Equatable {
  final String id;
  final String label;
  final String? textValue;
  final String? imagePath;
  final bool isSelected;

  const ShareableItem({
    required this.id,
    required this.label,
    this.textValue,
    this.imagePath,
    this.isSelected = true,
  });

  ShareableItem copyWith({
    bool? isSelected,
  }) {
    return ShareableItem(
      id: id,
      label: label,
      textValue: textValue,
      imagePath: imagePath,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, label, textValue, imagePath, isSelected];
}

class ShareableContent extends Equatable {
  final String title;
  final List<ShareableItem> items;

  const ShareableContent({
    required this.title,
    required this.items,
  });

  @override
  List<Object?> get props => [title, items];
}
