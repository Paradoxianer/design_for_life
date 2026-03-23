import 'package:equatable/equatable.dart';
import '../models/feedback_response.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class FeedbackStarted extends FeedbackEvent {}

class UpdateFeedback extends FeedbackEvent {
  final FeedbackResponse response;

  const UpdateFeedback(this.response);

  @override
  List<Object?> get props => [response];
}
