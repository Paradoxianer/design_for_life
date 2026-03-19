import 'package:freezed_annotation/freezed_annotation.dart';
import 'value_item.dart';

part 'values_state.freezed.dart';
part 'values_state.g.dart';

@freezed
class ValuesState with _$ValuesState {
  const factory ValuesState({
    @Default([]) List<ValueItem> allValues,
    @Default('') String reflectionThoughts,
    @Default('') String nextLifePhaseDescription,
    @Default([]) List<ValueItem> nextLifePhaseValues,
  }) = _ValuesState;

  factory ValuesState.fromJson(Map<String, dynamic> json) => _$ValuesStateFromJson(json);

  const ValuesState._();

  List<ValueItem> get topEightValues =>
      allValues.where((v) => v.rating == 1).toList();

  bool get isValid => topEightValues.length == 8;
}
