import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../repositories/personal_style_repository.dart';
import 'personal_style_event.dart';
import 'personal_style_state.dart';

class PersonalStyleBloc extends HydratedBloc<PersonalStyleEvent, PersonalStyleState> {
  final PersonalStyleRepository repository;

  PersonalStyleBloc({required this.repository}) : super(const PersonalStyleState()) {
    on<InitPersonalStyleAssessment>((event, emit) async {
      // forceReload wie bei den Geistesgaben/Feedback: geänderte JSON-Inhalte
      // sollen auch bei bereits persistiertem State übernommen werden.
      final questionnaire = await repository.loadQuestionnaire(event.locale, forceReload: true);
      emit(state.copyWith(questionnaire: questionnaire));
    });

    on<AnswerPersonalStyleQuestion>((event, emit) {
      final newAnswers = Map<String, int>.from(state.answers)..[event.questionId] = event.value;
      var newState = state.copyWith(answers: newAnswers);

      // Ergebnis automatisch als Key-Takeaway ablegen, sobald der Bogen
      // vollständig ist (Akzeptanzkriterium aus #50) - nur, wenn der erste
      // Slot noch leer ist, damit ein bereits vom Nutzer geschriebener Text
      // nicht überschrieben wird.
      final profile = newState.profile;
      if (profile != null) {
        final existing = List<String>.from(newState.takeaways[event.sessionId] ?? const ['', '', '']);
        if (existing.isEmpty) existing.addAll(const ['', '', '']);
        if (existing.first.trim().isEmpty) {
          existing[0] = profile.title;
          final newTakeaways = Map<String, List<String>>.from(newState.takeaways);
          newTakeaways[event.sessionId] = existing;
          newState = newState.copyWith(takeaways: newTakeaways);
        }
      }

      emit(newState);
    });

    on<UpdatePersonalStyleTakeaway>((event, emit) {
      final sessionTakeaways = List<String>.from(state.takeaways[event.sessionId] ?? const ['', '', '']);
      if (event.index < sessionTakeaways.length) {
        sessionTakeaways[event.index] = event.text;
        final newTakeaways = Map<String, List<String>>.from(state.takeaways);
        newTakeaways[event.sessionId] = sessionTakeaways;
        emit(state.copyWith(takeaways: newTakeaways));
      }
    });
  }

  @override
  PersonalStyleState? fromJson(Map<String, dynamic> json) => PersonalStyleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PersonalStyleState state) => state.toJson();
}
