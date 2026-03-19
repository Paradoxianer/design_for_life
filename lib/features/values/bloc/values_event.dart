import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/value_item.dart';

part 'values_event.freezed.dart';

@freezed
class ValuesEvent with _$ValuesEvent {
  const factory ValuesEvent.started() = _Started;
  const factory ValuesEvent.updateRating(String name, int rating) = _UpdateRating;
  const factory ValuesEvent.updateDefinition(String name, String definition) = _UpdateDefinition;
  const factory ValuesEvent.updateReflection(String thoughts) = _UpdateReflection;
  const factory ValuesEvent.updateNextLifePhase(String description) = _UpdateNextLifePhase;
  const factory ValuesEvent.toggleNextLifeValue(ValueItem value) = _ToggleNextLifeValue;
}
