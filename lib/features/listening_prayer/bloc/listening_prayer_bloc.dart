import 'package:flutter/foundation.dart';
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

  // Interne Helper-Methode für den Zugriff auf die Liste einer Session
  List<PrayerImpression> _getImpressions(String sessionId) {
    return List<PrayerImpression>.from(state.impressions[sessionId] ?? []);
  }

  void _onAddImpression(AddImpression event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = _getImpressions(event.sessionId);
    sessionImpressions.add(PrayerImpression(id: DateTime.now().toIso8601String()));
    
    final newMap = Map<String, List<PrayerImpression>>.from(state.impressions);
    newMap[event.sessionId] = sessionImpressions;
    emit(state.copyWith(impressions: newMap));
  }

  void _onUpdateImpressionText(UpdateImpressionText event, Emitter<ListeningPrayerState> emit) {
    debugPrint('BLOC_TEXT: ID=${event.impressionId}, Val=${event.text}');
    final sessionImpressions = _getImpressions(event.sessionId);
    
    // Falls die Liste leer ist, erstellen wir den Eintrag einfach mit der ID, die die UI schickt
    if (sessionImpressions.isEmpty) {
      sessionImpressions.add(PrayerImpression(id: event.impressionId, text: event.text));
    } else {
      final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
      if (index != -1) {
        sessionImpressions[index] = sessionImpressions[index].copyWith(text: event.text);
      } else {
        // Fallback: Falls ID nicht gefunden (z.B. nach Hot Reload), hängen wir es an
        sessionImpressions.add(PrayerImpression(id: event.impressionId, text: event.text));
      }
    }

    final newMap = Map<String, List<PrayerImpression>>.from(state.impressions);
    newMap[event.sessionId] = sessionImpressions;
    emit(state.copyWith(impressions: newMap));
  }

  void _onToggleImpressionCompletion(ToggleImpressionCompletion event, Emitter<ListeningPrayerState> emit) {
    debugPrint('BLOC_TOGGLE: ID=${event.impressionId}');
    final sessionImpressions = _getImpressions(event.sessionId);
    final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
    
    if (index != -1) {
      final wasCompleted = sessionImpressions[index].isCompleted;
      sessionImpressions[index] = sessionImpressions[index].copyWith(isCompleted: !wasCompleted);
      
      if (!wasCompleted) {
        // Auto-Expansion: Immer ein neues leeres Feld, wenn alles andere "done" ist
        final hasActive = sessionImpressions.any((i) => !i.isCompleted);
        if (!hasActive) {
          sessionImpressions.add(PrayerImpression(id: DateTime.now().toIso8601String()));
        }
      }

      final newMap = Map<String, List<PrayerImpression>>.from(state.impressions);
      newMap[event.sessionId] = sessionImpressions;
      emit(state.copyWith(impressions: newMap));
    }
  }

  void _onUpdateImpressionImage(UpdateImpressionImage event, Emitter<ListeningPrayerState> emit) {
    final sessionImpressions = _getImpressions(event.sessionId);
    final index = sessionImpressions.indexWhere((i) => i.id == event.impressionId);
    
    if (index != -1) {
      sessionImpressions[index] = sessionImpressions[index].copyWith(imagePath: event.imagePath);
      final newMap = Map<String, List<PrayerImpression>>.from(state.impressions);
      newMap[event.sessionId] = sessionImpressions;
      emit(state.copyWith(impressions: newMap));
    }
  }

  void _onUpdateHighlight(UpdateHighlight event, Emitter<ListeningPrayerState> emit) {
    final sessionHighlights = List<String>.from(state.highlights[event.sessionId] ?? ['', '', '']);
    if (event.index < sessionHighlights.length) {
      sessionHighlights[event.index] = event.text;
      final newMap = Map<String, List<String>>.from(state.highlights);
      newMap[event.sessionId] = sessionHighlights;
      emit(state.copyWith(highlights: newMap));
    }
  }

  @override
  ListeningPrayerState? fromJson(Map<String, dynamic> json) => ListeningPrayerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ListeningPrayerState state) => state.toJson();
}
