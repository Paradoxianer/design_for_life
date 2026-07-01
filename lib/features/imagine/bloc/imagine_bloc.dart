import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

part 'imagine_event.dart';
part 'imagine_state.dart';

class ImagineBloc extends HydratedBloc<ImagineEvent, ImagineState> {
  ImagineBloc() : super(const ImagineState()) {
    on<SelectPastImage>(_onSelectPastImage);
    on<SelectFutureImage>(_onSelectFutureImage);
    on<UpdateImagineTakeaway>(_onUpdateTakeaway);
  }

  void _onSelectPastImage(SelectPastImage event, Emitter<ImagineState> emit) {
    final updated = Map<String, String?>.from(state.pastImageIds);
    updated[event.sessionId] = event.imageId;
    emit(state.copyWith(pastImageIds: updated));
  }

  void _onSelectFutureImage(SelectFutureImage event, Emitter<ImagineState> emit) {
    final updated = Map<String, String?>.from(state.futureImageIds);
    updated[event.sessionId] = event.imageId;
    emit(state.copyWith(futureImageIds: updated));
  }

  void _onUpdateTakeaway(UpdateImagineTakeaway event, Emitter<ImagineState> emit) {
    final current = List<String>.from(
      state.takeaways[event.sessionId] ?? ['', '', ''],
    );
    while (current.length <= event.index) {
      current.add('');
    }
    current[event.index] = event.text;
    final updated = Map<String, List<String>>.from(state.takeaways);
    updated[event.sessionId] = current;
    emit(state.copyWith(takeaways: updated));
  }

  @override
  ImagineState? fromJson(Map<String, dynamic> json) => ImagineState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ImagineState state) => state.toJson();
}
