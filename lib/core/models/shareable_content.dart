import 'package:equatable/equatable.dart';

class ShareableItem extends Equatable {
  final String id;
  final String label;
  final String? textValue;
  final String? imagePath;
  final bool isSelected;
  final dynamic data;

  const ShareableItem({
    required this.id,
    required this.label,
    this.textValue,
    this.imagePath,
    this.isSelected = true,
    this.data,
  });

  ShareableItem copyWith({
    bool? isSelected,
    dynamic data,
  }) {
    return ShareableItem(
      id: id,
      label: label,
      textValue: textValue,
      imagePath: imagePath,
      isSelected: isSelected ?? this.isSelected,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [id, label, textValue, imagePath, isSelected, data];
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
