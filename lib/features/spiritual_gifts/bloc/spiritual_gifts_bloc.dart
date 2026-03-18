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
      
      if (state.questionOrder.isEmpty) {
        // Erste Initialisierung: Fragen sammeln und mischen
        final allQuestionIds = gifts
            .expand((gift) => gift.questions.map((q) => q.id))
            .toList()
          ..shuffle();
        
        emit(state.copyWith(
          questionOrder: allQuestionIds,
          currentQuestionIndex: 0,
        ));
      }
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

    on<ResetTest>((event, emit) {
      // Beim Reset mischen wir neu
      final allQuestionIds = List<String>.from(state.questionOrder)..shuffle();
      emit(const SpiritualGiftsState().copyWith(
        questionOrder: allQuestionIds,
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
