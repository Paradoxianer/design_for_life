import 'package:equatable/equatable.dart';
import '../models/value_item.dart';

abstract class ValuesEvent extends Equatable {
  const ValuesEvent();
  @override
  List<Object?> get props => [];
}

class ValuesStarted extends ValuesEvent {
  final List<ValueItem> initialValues;
  const ValuesStarted(this.initialValues);
  @override
  List<Object?> get props => [initialValues];
}

class UpdateRating extends ValuesEvent {
  final String name;
  final int rating;
  const UpdateRating(this.name, this.rating);
  @override
  List<Object?> get props => [name, rating];
}

class UpdateDefinition extends ValuesEvent {
  final String name;
  final String definition;
  const UpdateDefinition(this.name, this.definition);
  @override
  List<Object?> get props => [name, definition];
}

class UpdateReflection extends ValuesEvent {
  final String thoughts;
  const UpdateReflection(this.thoughts);
  @override
  List<Object?> get props => [thoughts];
}

class UpdateNextLifePhase extends ValuesEvent {
  final String description;
  const UpdateNextLifePhase(this.description);
  @override
  List<Object?> get props => [description];
}

class ToggleNextLifeValue extends ValuesEvent {
  final ValueItem value;
  const ToggleNextLifeValue(this.value);
  @override
  List<Object?> get props => [value];
}

class ReorderTopValues extends ValuesEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderTopValues(this.oldIndex, this.newIndex);
  @override
  List<Object?> get props => [oldIndex, newIndex];
}
