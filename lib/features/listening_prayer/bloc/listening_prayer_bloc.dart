import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'listening_prayer_event.dart';
import 'listening_prayer_state.dart';
import '../models/prayer_impression.dart';

class ListeningPrayerBloc extends HydratedBloc<ListeningPrayerEvent, ListeningPrayerState> {
  ListeningPrayerBloc() : super(const ListeningPrayerState()) {
    on<UpdateImpression>(_onUpdateImpression);
    on<AddImpression>(_onAddImpression);
    on<UpdateHighlight>(_onUpdateHighlight);
  }

  void _onUpdateImpression(UpdateImpression event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = List<PrayerImpression>.from(
      state.impressions[event.sessionId] ?? [PrayerImpression(id: DateTime.now().toString())],
    );

    final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
    if (index != -1) {
      sessionImpressions[index] = sessionImpressions[index].copyWith(text: event.text);
      
      // Auto-add new empty impression if the last one is being typed in
      if (index == sessionImpressions.length - 1 && event.text.isNotEmpty) {
        sessionImpressions.add(PrayerImpression(id: DateTime.now().add(const Duration(milliseconds: 10)).toString()));
      }

      final newImpressions = Map<String, List<PrayerImpression>>.from(state.impressions);
      newImpressions[event.sessionId] = sessionImpressions;
      emit(state.copyWith(impressions: newImpressions));
    }
  }

  void _onAddImpression(AddImpression event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = List<PrayerImpression>.from(state.impressions[event.sessionId] ?? []);
    sessionImpressions.add(PrayerImpression(id: DateTime.now().toString()));
    
    final newImpressions = Map<String, List<PrayerImpression>>.from(state.impressions);
    newImpressions[event.sessionId] = sessionImpressions;
    emit(state.copyWith(impressions: newImpressions));
  }

  void _onUpdateHighlight(UpdateHighlight event, Emitter<ListeningPrayerState> emit) {
    final sessionHighlights = List<String>.from(state.highlights[event.sessionId] ?? ['', '', '']);
    if (event.index < sessionHighlights.length) {
      sessionHighlights[event.index] = event.text;
      final newHighlights = Map<String, List<String>>.from(state.highlights);
      newHighlights[event.sessionId] = sessionHighlights;
      emit(state.copyWith(highlights: newHighlights));
    }
  }

  @override
  ListeningPrayerState? fromJson(Map<String, dynamic> json) => ListeningPrayerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ListeningPrayerState state) => state.toJson();
}
