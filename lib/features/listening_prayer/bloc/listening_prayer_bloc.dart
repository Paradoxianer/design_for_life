import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'listening_prayer_event.dart';
import 'listening_prayer_state.dart';
import '../models/prayer_impression.dart';

class ListeningPrayerBloc extends HydratedBloc<ListeningPrayerEvent, ListeningPrayerState> {
  ListeningPrayerBloc() : super(const ListeningPrayerState()) {
    on<AddImpression>(_onAddImpression);
    on<UpdateImpressionText>(_onUpdateImpressionText);
    on<ToggleImpressionCompletion>(_onToggleImpressionCompletion);
    on<UpdateImpressionImage>(_onUpdateImpressionImage);
    on<UpdateHighlight>(_onUpdateHighlight);
  }

  List<PrayerImpression> _getEffectiveImpressions(String sessionId) {
    final list = state.impressions[sessionId] ?? [];
    if (list.isEmpty) {
      return [PrayerImpression(id: DateTime.now().toIso8601String())];
    }
    return list;
  }

  void _onAddImpression(AddImpression event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = List<PrayerImpression>.from(state.impressions[event.sessionId] ?? []);
    sessionImpressions.add(PrayerImpression(id: DateTime.now().toIso8601String()));
    
    final newImpressions = Map<String, List<PrayerImpression>>.from(state.impressions);
    newImpressions[event.sessionId] = sessionImpressions;
    emit(state.copyWith(impressions: newImpressions));
  }

  void _onUpdateImpressionText(UpdateImpressionText event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = List<PrayerImpression>.from(_getEffectiveImpressions(event.sessionId));
    final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
    
    if (index != -1) {
      sessionImpressions[index] = sessionImpressions[index].copyWith(text: event.text);
      final newImpressions = Map<String, List<PrayerImpression>>.from(state.impressions);
      newImpressions[event.sessionId] = sessionImpressions;
      emit(state.copyWith(impressions: newImpressions));
    }
  }

  void _onToggleImpressionCompletion(ToggleImpressionCompletion event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = List<PrayerImpression>.from(_getEffectiveImpressions(event.sessionId));
    final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
    
    if (index != -1) {
      final wasCompleted = sessionImpressions[index].isCompleted;
      sessionImpressions[index] = sessionImpressions[index].copyWith(isCompleted: !wasCompleted);
      
      if (!wasCompleted) {
        final hasUncompleted = sessionImpressions.any((i) => !i.isCompleted);
        if (!hasUncompleted) {
          sessionImpressions.add(PrayerImpression(id: DateTime.now().add(const Duration(milliseconds: 1)).toIso8601String()));
        }
      }

      final newImpressions = Map<String, List<PrayerImpression>>.from(state.impressions);
      newImpressions[event.sessionId] = sessionImpressions;
      emit(state.copyWith(impressions: newImpressions));
    }
  }

  void _onUpdateImpressionImage(UpdateImpressionImage event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = List<PrayerImpression>.from(_getEffectiveImpressions(event.sessionId));
    final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
    
    if (index != -1) {
      sessionImpressions[index] = sessionImpressions[index].copyWith(imagePath: event.imagePath);
      final newImpressions = Map<String, List<PrayerImpression>>.from(state.impressions);
      newImpressions[event.sessionId] = sessionImpressions;
      emit(state.copyWith(impressions: newImpressions));
    }
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
