part of 'gift_reference_answer_bloc.dart';

class GiftReferenceAnswerState extends Equatable {
  final Map<String, Map<String, int>> answersByAssessment;

  const GiftReferenceAnswerState({this.answersByAssessment = const {}});

  Map<String, int> answersFor(String assessmentId) =>
      answersByAssessment[assessmentId] ?? const {};

  GiftReferenceAnswerState copyWith({
    Map<String, Map<String, int>>? answersByAssessment,
  }) {
    return GiftReferenceAnswerState(
      answersByAssessment: answersByAssessment ?? this.answersByAssessment,
    );
  }

  Map<String, dynamic> toJson() {
    return {'answersByAssessment': answersByAssessment};
  }

  factory GiftReferenceAnswerState.fromJson(Map<String, dynamic> json) {
    return GiftReferenceAnswerState(
      answersByAssessment:
          (json['answersByAssessment'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, Map<String, int>.from(v as Map)),
          ) ??
          const {},
    );
  }

  @override
  List<Object?> get props => [answersByAssessment];
}
