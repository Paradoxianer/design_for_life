import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'values_event.dart';
import 'values_state.dart';
import '../models/static_values_data.dart';

class ValuesBloc extends HydratedBloc<ValuesEvent, ValuesState> {
  ValuesBloc() : super(const ValuesState()) {
    on<ValuesEvent>((event, emit) {
      event.map(
        started: (e) {
          if (state.allValues.isEmpty) {
            emit(state.copyWith(allValues: StaticValuesData.initialValues));
          }
        },
        updateRating: (e) {
          final updatedValues = state.allValues.map((v) {
            if (v.name == e.name) {
              return v.copyWith(rating: e.rating);
            }
            return v;
          }).toList();
          emit(state.copyWith(allValues: updatedValues));
        },
        updateDefinition: (e) {
          final updatedValues = state.allValues.map((v) {
            if (v.name == e.name) {
              return v.copyWith(definition: e.definition);
            }
            return v;
          }).toList();
          emit(state.copyWith(allValues: updatedValues));
        },
        updateReflection: (e) {
          emit(state.copyWith(reflectionThoughts: e.thoughts));
        },
        updateNextLifePhase: (e) {
          emit(state.copyWith(nextLifePhaseDescription: e.description));
        },
        toggleNextLifeValue: (e) {
          final current = List.from(state.nextLifePhaseValues);
          if (current.any((v) => v.name == e.value.name)) {
            current.removeWhere((v) => v.name == e.value.name);
          } else if (current.length < 8) {
            current.add(e.value);
          }
          emit(state.copyWith(nextLifePhaseValues: List.from(current)));
        },
      );
    });
  }

  @override
  ValuesState? fromJson(Map<String, dynamic> json) => ValuesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ValuesState state) => state.toJson();
}
