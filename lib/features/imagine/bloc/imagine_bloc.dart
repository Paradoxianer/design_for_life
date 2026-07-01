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
    final updated = Map<String, String?>.from(state.pastImageUrls);
    updated[event.sessionId] = event.imageUrl;
    emit(state.copyWith(pastImageUrls: updated));
  }

  void _onSelectFutureImage(SelectFutureImage event, Emitter<ImagineState> emit) {
    final updated = Map<String, String?>.from(state.futureImageUrls);
    updated[event.sessionId] = event.imageUrl;
    emit(state.copyWith(futureImageUrls: updated));
  }

  void _onUpdateTakeaway(UpdateImagineTakeaway event, Emitter<ImagineState> emit) {
    final updated = Map<String, String>.from(state.takeaways);
    updated[event.sessionId] = event.text;
    emit(state.copyWith(takeaways: updated));
  }

  @override
  ImagineState? fromJson(Map<String, dynamic> json) => ImagineState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ImagineState state) => state.toJson();
}
