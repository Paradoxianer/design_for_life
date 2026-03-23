import 'package:equatable/equatable.dart';
import '../models/feedback_response.dart';

class FeedbackState extends Equatable {
  final FeedbackResponse response;
  final bool isSubmitted;

  const FeedbackState({
    this.response = const FeedbackResponse(),
    this.isSubmitted = false,
  });

  FeedbackState copyWith({
    FeedbackResponse? response,
    bool? isSubmitted,
  }) {
    return FeedbackState(
      response: response ?? this.response,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [response, isSubmitted];
}
