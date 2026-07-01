import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

part 'imagine_event.dart';
part 'imagine_state.dart';

class ImagineBloc extends HydratedBloc<ImagineEvent, ImagineState> {
  ImagineBloc() : super(const ImagineState()) {
    on<SelectPastImage>(_onSelectPastImage);
    on<SelectFutureImage>(_onSelectFutureImage);
  }

  void _onSelectPastImage(SelectPastImage event, Emitter<ImagineState> emit) {
    final updated = Map<String, String?>.from(state.pastImageIds);
    updated[event.sessionId] = event.imageUrl;
    emit(state.copyWith(pastImageIds: updated));
  }

  void _onSelectFutureImage(SelectFutureImage event, Emitter<ImagineState> emit) {
    final updated = Map<String, String?>.from(state.futureImageIds);
    updated[event.sessionId] = event.imageUrl;
    emit(state.copyWith(futureImageIds: updated));
  }

  @override
  ImagineState? fromJson(Map<String, dynamic> json) => ImagineState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ImagineState state) => state.toJson();
}
