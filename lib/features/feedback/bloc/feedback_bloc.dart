import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';
import '../models/feedback_response.dart';

class FeedbackBloc extends HydratedBloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(const FeedbackState()) {
    on<FeedbackStarted>((event, emit) {
      // Logic for initialization if needed
    });

    on<UpdateFeedback>((event, emit) {
      emit(state.copyWith(response: event.response));
    });
  }

  @override
  FeedbackState? fromJson(Map<String, dynamic> json) {
    return FeedbackState(
      response: FeedbackResponse.fromJson(json['response']),
      isSubmitted: json['isSubmitted'] ?? false,
    );
  }

  @override
  Map<String, dynamic>? toJson(FeedbackState state) {
    return {
      'response': state.response.toJson(),
      'isSubmitted': state.isSubmitted,
    };
  }
}
