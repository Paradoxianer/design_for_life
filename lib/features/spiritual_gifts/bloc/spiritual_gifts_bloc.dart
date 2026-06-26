import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/spiritual_gift.dart';
import '../models/gift_question.dart';
import '../repositories/gifts_repository.dart';

part 'spiritual_gifts_event.dart';
part 'spiritual_gifts_state.dart';

class SpiritualGiftsBloc extends HydratedBloc<SpiritualGiftsEvent, SpiritualGiftsState> {
  final GiftsRepository repository;

  SpiritualGiftsBloc({required this.repository}) : super(const SpiritualGiftsState()) {
    on<InitTest>((event, emit) async {
      // If we already have the gifts for this session and the locale matches, skip reload
      if (state.isLoaded && 
          state.currentSessionId == event.sessionId && 
          repository.cachedLocale == event.locale) {
        return;
      }

      final gifts = await repository.loadGifts(event.locale);
      
      // Clear question order if gifts were reloaded to ensure sync
      // We ONLY include non-reference questions in the main test
      List<String> questionOrder = gifts
          .expand((gift) => gift.questions)
          .where((q) => q.type != QuestionType.reference)
          .map((q) => q.id)
          .toList();
          
      if (state.questionOrder.length != questionOrder.length) {
        questionOrder.shuffle();
      } else {
        questionOrder = state.questionOrder;
      }
      
      emit(state.copyWith(
        gifts: gifts,
        questionOrder: questionOrder,
        currentSessionId: event.sessionId,
        currentQuestionIndex: state.answers.length >= questionOrder.length ? 0 : state.firstUnansweredIndex,
      ));
    });

    on<AnswerQuestion>((event, emit) {
      final newAnswers = Map<String, int>.from(state.answers);
      newAnswers[event.questionId] = event.score;
      
      var newState = state.copyWith(
        answers: newAnswers,
      );

      // We set the index to the next unanswered question unless the test is complete
      if (!newState.isCompleted) {
        newState = newState.copyWith(currentQuestionIndex: newState.firstUnansweredIndex);
      }

      // Automatic takeaways generation when test is completed
      if (newState.isCompleted) {
        final top3 = newState.getRankedGifts().take(3).map((g) => g.name).toList();
        final newTakeaways = Map<String, List<String>>.from(state.takeaways);
        final sessionId = newState.currentSessionId ?? 'default';
        if (newTakeaways[sessionId] == null || newTakeaways[sessionId]!.isEmpty) {
          newTakeaways[sessionId] = top3;
        }
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
