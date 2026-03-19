import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_item.freezed.dart';
part 'value_item.g.dart';

@freezed
class ValueItem with _$ValueItem {
  const factory ValueItem({
    required String name,
    @Default(3) int rating, // 1: very important, 2: important, 3: not important
    String? definition,
  }) = _ValueItem;

  factory ValueItem.fromJson(Map<String, dynamic> json) => _$ValueItemFromJson(json);
}
