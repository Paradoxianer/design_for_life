import 'package:flutter_bloc/flutter_bloc.dart';
import 'values_event.dart';
import 'values_state.dart';
import '../models/static_values_data.dart';

class ValuesBloc extends Bloc<ValuesEvent, ValuesState> {
  ValuesBloc() : super(const ValuesState()) {
    on<_Started>((event, emit) {
      if (state.allValues.isEmpty) {
        emit(state.copyWith(allValues: StaticValuesData.initialValues));
      }
    });

    on<_UpdateRating>((event, emit) {
      final updatedValues = state.allValues.map((v) {
        if (v.name == event.name) {
          return v.copyWith(rating: event.rating);
        }
        return v;
      }).toList();
      emit(state.copyWith(allValues: updatedValues));
    });

    on<_UpdateDefinition>((event, emit) {
      final updatedValues = state.allValues.map((v) {
        if (v.name == event.name) {
          return v.copyWith(definition: event.definition);
        }
        return v;
      }).toList();
      emit(state.copyWith(allValues: updatedValues));
    });

    on<_UpdateReflection>((event, emit) {
      emit(state.copyWith(reflectionThoughts: event.thoughts));
    });

    on<_UpdateNextLifePhase>((event, emit) {
      emit(state.copyWith(nextLifePhaseDescription: event.description));
    });

    on<_ToggleNextLifeValue>((event, emit) {
      final current = List<ValueItem>.from(state.nextLifePhaseValues);
      if (current.any((v) => v.name == event.value.name)) {
        current.removeWhere((v) => v.name == event.value.name);
      } else if (current.length < 8) {
        current.add(event.value);
      }
      emit(state.copyWith(nextLifePhaseValues: current));
    });
  }
}
