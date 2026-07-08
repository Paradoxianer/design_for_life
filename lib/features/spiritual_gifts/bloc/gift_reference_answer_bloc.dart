import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

part 'gift_reference_answer_event.dart';
part 'gift_reference_answer_state.dart';

/// Holds in-progress answers for the external "Referenz" (R) mini-flow
/// (#42), keyed by assessmentId so it never touches the reviewer's own
/// SpiritualGiftsBloc/self-assessment state - this is a separate,
/// short-lived role (answering about someone else), not the reviewer's own
/// profile. Persisted so a reviewer doesn't lose progress if interrupted
/// mid-flow.
class GiftReferenceAnswerBloc
    extends HydratedBloc<GiftReferenceAnswerEvent, GiftReferenceAnswerState> {
  GiftReferenceAnswerBloc() : super(const GiftReferenceAnswerState()) {
    on<AnswerReferenceQuestion>(_onAnswerReferenceQuestion);
    on<ClearReferenceAssessment>(_onClearReferenceAssessment);
  }

  void _onAnswerReferenceQuestion(
    AnswerReferenceQuestion event,
    Emitter<GiftReferenceAnswerState> emit,
  ) {
    final byAssessment = Map<String, Map<String, int>>.from(
      state.answersByAssessment,
    );
    final answers = Map<String, int>.from(
      byAssessment[event.assessmentId] ?? const {},
    );
    answers[event.questionId] = event.score;
    byAssessment[event.assessmentId] = answers;
    emit(state.copyWith(answersByAssessment: byAssessment));
  }

  void _onClearReferenceAssessment(
    ClearReferenceAssessment event,
    Emitter<GiftReferenceAnswerState> emit,
  ) {
    final byAssessment = Map<String, Map<String, int>>.from(
      state.answersByAssessment,
    )..remove(event.assessmentId);
    emit(state.copyWith(answersByAssessment: byAssessment));
  }

  @override
  GiftReferenceAnswerState? fromJson(Map<String, dynamic> json) =>
      GiftReferenceAnswerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(GiftReferenceAnswerState state) =>
      state.toJson();
}
