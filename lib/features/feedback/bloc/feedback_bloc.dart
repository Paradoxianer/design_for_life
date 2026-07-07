import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../repositories/feedback_questions_repository.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackBloc extends HydratedBloc<FeedbackEvent, FeedbackState> {
  final FeedbackQuestionsRepository repository;

  FeedbackBloc({required this.repository}) : super(const FeedbackState()) {
    on<LoadFeedbackQuestionnaire>((event, emit) async {
      // forceReload wie bei den Geistesgaben: geänderte JSON-Inhalte sollen
      // auch bei bereits persistiertem State übernommen werden.
      final questionnaire = await repository.loadQuestionnaire(event.locale, forceReload: true);
      emit(state.copyWith(questionnaire: questionnaire));
    });

    on<UpdateFeedbackAnswer>((event, emit) {
      emit(state.copyWith(response: state.response.copyWithAnswer(event.questionId, event.value)));
    });
  }

  @override
  FeedbackState? fromJson(Map<String, dynamic> json) => FeedbackState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(FeedbackState state) => state.toJson();
}
