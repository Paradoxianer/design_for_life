import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'values_event.dart';
import 'values_state.dart';
import '../models/static_values_data.dart';
import '../models/value_item.dart';

class ValuesBloc extends HydratedBloc<ValuesEvent, ValuesState> {
  ValuesBloc() : super(const ValuesState()) {
    on<ValuesStarted>((event, emit) {
      if (state.allValues.isEmpty) {
        emit(state.copyWith(allValues: StaticValuesData.initialValues));
      }
    });

    on<UpdateRating>((event, emit) {
      final updatedValues = state.allValues.map((v) {
        if (v.name == event.name) {
          return v.copyWith(rating: event.rating);
        }
        return v;
      }).toList();
      emit(state.copyWith(allValues: updatedValues));
    });

    on<UpdateDefinition>((event, emit) {
      final updatedValues = state.allValues.map((v) {
        if (v.name == event.name) {
          return v.copyWith(definition: event.definition);
        }
        return v;
      }).toList();
      emit(state.copyWith(allValues: updatedValues));
    });

    on<UpdateReflection>((event, emit) {
      emit(state.copyWith(reflectionThoughts: event.thoughts));
    });

    on<UpdateNextLifePhase>((event, emit) {
      emit(state.copyWith(nextLifePhaseDescription: event.description));
    });

    on<ToggleNextLifeValue>((event, emit) {
      final current = List<ValueItem>.from(state.nextLifePhaseValues);
      if (current.any((v) => v.name == event.value.name)) {
        current.removeWhere((v) => v.name == event.value.name);
      } else if (current.length < 8) {
        current.add(event.value);
      }
      emit(state.copyWith(nextLifePhaseValues: current));
    });

    on<ReorderTopValues>((event, emit) {
      final top8 = List<ValueItem>.from(state.topEightValues);
      if (top8.isEmpty) return;

      final item = top8.removeAt(event.oldIndex);
      int newIdx = event.newIndex;
      if (newIdx > event.oldIndex) newIdx--;
      top8.insert(newIdx, item);

      // Create a map for quick access to the new order
      final nameToOrder = {for (int i = 0; i < top8.length; i++) top8[i].name: i};

      // Create a list of all other values (rating != 1)
      final otherValues = state.allValues.where((v) => v.rating != 1).toList();

      // Combine: first the top 8 in their new order, then all others
      final updatedAllValues = [...top8, ...otherValues];

      emit(state.copyWith(allValues: updatedAllValues));
    });
  }

  @override
  ValuesState? fromJson(Map<String, dynamic> json) => ValuesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ValuesState state) => state.toJson();
}
