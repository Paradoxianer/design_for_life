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
        questionOrder = gifts
            .expand((gift) => gift.questions.map((q) => q.id))
            .toList()
          ..shuffle();
      }
      
      emit(state.copyWith(
        gifts: gifts,
        questionOrder: questionOrder,
        currentQuestionIndex: state.answers.length >= questionOrder.length ? 0 : state.firstUnansweredIndex,
      ));
    });

    on<AnswerQuestion>((event, emit) {
      final newAnswers = Map<String, int>.from(state.answers);
      newAnswers[event.questionId] = event.score;
      
      var newState = state.copyWith(
        answers: newAnswers,
      );

      // Wir setzen den Index immer auf die nächste unbeantwortete Frage,
      // es sei denn, der Test ist komplett.
      if (!newState.isCompleted) {
        newState = newState.copyWith(currentQuestionIndex: newState.firstUnansweredIndex);
      }

      // Automatische Takeaways generieren, wenn fertig
      if (newState.isCompleted) {
        final top3 = newState.getRankedGifts().take(3).map((g) => g.name).toList();
        final newTakeaways = Map<String, List<String>>.from(state.takeaways);
        newTakeaways[newState.currentSessionId ?? 'default'] = top3;
        newState = newState.copyWith(takeaways: newTakeaways);
      }

      emit(newState);
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
        
      emit(const SpiritualGiftsState().copyWith(
        gifts: state.gifts,
        questionOrder: allQuestionIds,
        currentQuestionIndex: 0,
        answers: {},
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
