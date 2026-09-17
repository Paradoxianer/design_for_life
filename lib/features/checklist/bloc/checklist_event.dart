part of 'checklist_bloc.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object?> get props => [];
}

class ToggleChecklistItem extends ChecklistEvent {
  final String id;

  const ToggleChecklistItem(this.id);

  @override
  List<Object?> get props => [id];
}

class AddCustomChecklistItem extends ChecklistEvent {
  final String text;

  const AddCustomChecklistItem(this.text);

  @override
  List<Object?> get props => [text];
}

class RemoveChecklistItem extends ChecklistEvent {
  final String id;

  const RemoveChecklistItem(this.id);

  @override
  List<Object?> get props => [id];
}
