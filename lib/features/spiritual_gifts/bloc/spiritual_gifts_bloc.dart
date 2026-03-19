import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/spiritual_gift.dart';
import '../repositories/gifts_repository.dart';

part 'spiritual_gifts_event.dart';
part 'spiritual_gifts_state.dart';

class SpiritualGiftsBloc extends HydratedBloc<SpiritualGiftsEvent, SpiritualGiftsState> {
  final GiftsRepository repository;

  SpiritualGiftsBloc({required this.repository}) : super(const SpiritualGiftsState()) {
    on<InitTest>((event, emit) async {
      final gifts = await repository.loadGifts(event.locale);
      
      List<String> questionOrder = List.from(state.questionOrder);
      if (questionOrder.isEmpty) {
        // Fragen mischen, falls noch nicht geschehen
        questionOrder = gifts
            .expand((gift) => gift.questions.map((q) => q.id))
            .toList()
          ..shuffle();
      }
      
      emit(state.copyWith(
        gifts: gifts,
        questionOrder: questionOrder,
      ));
    });

    on<AnswerQuestion>((event, emit) {
      final newAnswers = Map<String, int>.from(state.answers);
      newAnswers[event.questionId] = event.score;
      
      int nextIndex = state.currentQuestionIndex + 1;
      
      emit(state.copyWith(
        answers: newAnswers,
        currentQuestionIndex: nextIndex,
      ));
    });

    on<PreviousQuestion>((event, emit) {
      if (state.currentQuestionIndex > 0) {
        emit(state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex - 1,
        ));
      }
    });

    on<UpdateTakeaways>((event, emit) {
      final newTakeaways = Map<String, List<String>>.from(state.takeaways);
      newTakeaways[event.sessionId] = event.takeaways;
      emit(state.copyWith(takeaways: newTakeaways));
    });

    on<ResetTest>((event, emit) {
      final allQuestionIds = state.gifts
          .expand((gift) => gift.questions.map((q) => q.id))
          .toList()
        ..shuffle();
        
      emit(const SpiritualGiftsState(gifts: []).copyWith(
        gifts: state.gifts,
        questionOrder: allQuestionIds,
        currentQuestionIndex: 0,
        answers: {},
        takeaways: state.takeaways,
      ));
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
