import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/checklist_item.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';

class ChecklistBloc extends HydratedBloc<ChecklistEvent, ChecklistState> {
  ChecklistBloc() : super(ChecklistState.initial()) {
    on<ToggleChecklistItem>(_onToggleChecklistItem);
    on<AddCustomChecklistItem>(_onAddCustomChecklistItem);
    on<RemoveChecklistItem>(_onRemoveChecklistItem);
  }

  void _onToggleChecklistItem(
    ToggleChecklistItem event,
    Emitter<ChecklistState> emit,
  ) {
    final items = state.items
        .map(
          (item) => item.id == event.id
              ? item.copyWith(isChecked: !item.isChecked)
              : item,
        )
        .toList();
    emit(state.copyWith(items: items));
  }

  void _onAddCustomChecklistItem(
    AddCustomChecklistItem event,
    Emitter<ChecklistState> emit,
  ) {
    final text = event.text.trim();
    if (text.isEmpty) return;

    final newItem = ChecklistItem(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      customText: text,
    );
    emit(state.copyWith(items: [...state.items, newItem]));
  }

  void _onRemoveChecklistItem(
    RemoveChecklistItem event,
    Emitter<ChecklistState> emit,
  ) {
    final items = state.items.where((item) => item.id != event.id).toList();
    emit(state.copyWith(items: items));
  }

  @override
  ChecklistState? fromJson(Map<String, dynamic> json) =>
      ChecklistState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ChecklistState state) => state.toJson();
}
