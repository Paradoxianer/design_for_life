import '../models/value_item.dart';

abstract class ValuesEvent {
  const ValuesEvent();
}

class ValuesStarted extends ValuesEvent {
  const ValuesStarted();
}

class UpdateRating extends ValuesEvent {
  final String name;
  final int rating;
  const UpdateRating(this.name, this.rating);
}

class UpdateDefinition extends ValuesEvent {
  final String name;
  final String definition;
  const UpdateDefinition(this.name, this.definition);
}

class UpdateReflection extends ValuesEvent {
  final String thoughts;
  const UpdateReflection(this.thoughts);
}

class UpdateNextLifePhase extends ValuesEvent {
  final String description;
  const UpdateNextLifePhase(this.description);
}

class ToggleNextLifeValue extends ValuesEvent {
  final ValueItem value;
  const ToggleNextLifeValue(this.value);
}

class ReorderTopValues extends ValuesEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderTopValues(this.oldIndex, this.newIndex);
}
