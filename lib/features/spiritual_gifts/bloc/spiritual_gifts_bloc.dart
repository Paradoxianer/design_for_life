import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/gift_data.dart';
import '../models/spiritual_gift.dart';

part 'spiritual_gifts_event.dart';
part 'spiritual_gifts_state.dart';

class SpiritualGiftsBloc extends HydratedBloc<SpiritualGiftsEvent, SpiritualGiftsState> {
  SpiritualGiftsBloc() : super(const SpiritualGiftsState()) {
    on<AnswerQuestion>((event, emit) {
      final newAnswers = Map<String, int>.from(state.answers);
      newAnswers[event.questionId] = event.score;
      emit(state.copyWith(answers: newAnswers));
    });

    on<ResetTest>((event, emit) {
      emit(const SpiritualGiftsState());
    });
  }

  @override
  SpiritualGiftsState? fromJson(Map<String, dynamic> json) {
    return SpiritualGiftsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SpiritualGiftsState state) {
    return state.toJson();
  }
}
