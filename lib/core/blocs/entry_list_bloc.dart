import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/dfl_entry.dart';

// Events
abstract class EntryListEvent extends Equatable {
  const EntryListEvent();
  @override
  List<Object?> get props => [];
}

class AddEntry extends EntryListEvent {
  final String sessionId;
  const AddEntry(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class UpdateEntryText extends EntryListEvent {
  final String sessionId;
  final String entryId;
  final String text;
  const UpdateEntryText(this.sessionId, this.entryId, this.text);
  @override
  List<Object?> get props => [sessionId, entryId, text];
}

class ToggleEntryCompletion extends EntryListEvent {
  final String sessionId;
  final String entryId;
  const ToggleEntryCompletion(this.sessionId, this.entryId);
  @override
  List<Object?> get props => [sessionId, entryId];
}

class UpdateEntryImage extends EntryListEvent {
  final String sessionId;
  final String entryId;
  final String? imagePath;
  const UpdateEntryImage(this.sessionId, this.entryId, this.imagePath);
  @override
  List<Object?> get props => [sessionId, entryId, imagePath];
}

class DeleteEntry extends EntryListEvent {
  final String sessionId;
  final String entryId;
  const DeleteEntry(this.sessionId, this.entryId);
  @override
  List<Object?> get props => [sessionId, entryId];
}

class UpdateTakeaway extends EntryListEvent {
  final String sessionId;
  final int index;
  final String text;
  const UpdateTakeaway(this.sessionId, this.index, this.text);
  @override
  List<Object?> get props => [sessionId, index, text];
}

// State
class EntryListState extends Equatable {
  final Map<String, List<DflEntry>> entries;
  final Map<String, List<String>> takeaways;

  const EntryListState({
    this.entries = const {},
    this.takeaways = const {},
  });

  /// A session is considered completed if it has at least one entry with text or an image.
  bool isCompleted(String sessionId) {
    final sessionEntries = entries[sessionId] ?? [];
    return sessionEntries.any((e) => e.text.trim().isNotEmpty || e.imagePath != null);
  }

  @override
  List<Object?> get props => [entries, takeaways];

  EntryListState copyWith({
    Map<String, List<DflEntry>>? entries,
    Map<String, List<String>>? takeaways,
  }) {
    return EntryListState(
      entries: entries ?? this.entries,
      takeaways: takeaways ?? this.takeaways,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entries': entries.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList())),
      'takeaways': takeaways,
    };
  }

  factory EntryListState.fromJson(Map<String, dynamic> json) {
    return EntryListState(
      entries: (json['entries'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as List).map((e) => DflEntry.fromJson(e)).toList()),
          ) ?? {},
      takeaways: (json['takeaways'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v)),
          ) ?? {},
    );
  }
}

// Generic Bloc Implementation
abstract class EntryListBloc extends HydratedBloc<EntryListEvent, EntryListState> {
  EntryListBloc([EntryListState initialState = const EntryListState()]) : super(initialState) {
    on<AddEntry>(_onAddEntry);
    on<UpdateEntryText>(_onUpdateEntryText);
    on<ToggleEntryCompletion>(_onToggleEntryCompletion);
    on<UpdateEntryImage>(_onUpdateEntryImage);
    on<DeleteEntry>(_onDeleteEntry);
    on<UpdateTakeaway>(_onUpdateTakeaway);
  }

  List<DflEntry> _getEntries(String sessionId) {
    return List<DflEntry>.from(state.entries[sessionId] ?? []);
  }

  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  void _onAddEntry(AddEntry event, Emitter<EntryListState> emit) {
    final sessionEntries = _getEntries(event.sessionId);
    sessionEntries.add(DflEntry(id: _generateId()));
    
    final newMap = Map<String, List<DflEntry>>.from(state.entries);
    newMap[event.sessionId] = sessionEntries;
    emit(state.copyWith(entries: newMap));
  }

  void _onUpdateEntryText(UpdateEntryText event, Emitter<EntryListState> emit) {
    final sessionEntries = _getEntries(event.sessionId);
    final index = sessionEntries.indexWhere((i) => i.id == event.entryId);
    
    if (index != -1) {
      sessionEntries[index] = sessionEntries[index].copyWith(text: event.text);
    } else {
      sessionEntries.add(DflEntry(id: event.entryId, text: event.text));
    }

    if (sessionEntries.isNotEmpty && 
        sessionEntries.last.id == event.entryId && 
        (event.text.isNotEmpty || sessionEntries.last.imagePath != null)) {
      sessionEntries.add(DflEntry(id: _generateId()));
    }

    final newMap = Map<String, List<DflEntry>>.from(state.entries);
    newMap[event.sessionId] = sessionEntries;
    emit(state.copyWith(entries: newMap));
  }

  void _onToggleEntryCompletion(ToggleEntryCompletion event, Emitter<EntryListState> emit) {
    final sessionEntries = _getEntries(event.sessionId);
    int index = sessionEntries.indexWhere((i) => i.id == event.entryId);
    
    if (index == -1 && event.entryId.startsWith('initial_')) {
      sessionEntries.add(DflEntry(id: event.entryId, isCompleted: true));
      index = sessionEntries.length - 1;
    }

    if (index != -1) {
      final wasCompleted = sessionEntries[index].isCompleted;
      sessionEntries[index] = sessionEntries[index].copyWith(isCompleted: !wasCompleted);
      
      if (!wasCompleted) {
        final hasActive = sessionEntries.any((i) => !i.isCompleted);
        if (!hasActive) {
          sessionEntries.add(DflEntry(id: _generateId()));
        }
      }

      final newMap = Map<String, List<DflEntry>>.from(state.entries);
      newMap[event.sessionId] = sessionEntries;
      emit(state.copyWith(entries: newMap));
    }
  }

  void _onUpdateEntryImage(UpdateEntryImage event, Emitter<EntryListState> emit) {
    final sessionEntries = _getEntries(event.sessionId);
    final index = sessionEntries.indexWhere((i) => i.id == event.entryId);
    
    if (index != -1) {
      if (event.imagePath == null) {
        sessionEntries[index] = sessionEntries[index].copyWith(clearImagePath: true);
      } else {
        sessionEntries[index] = sessionEntries[index].copyWith(imagePath: event.imagePath);
      }
    } else if (event.imagePath != null) {
      sessionEntries.add(DflEntry(id: event.entryId, imagePath: event.imagePath));
    }

    if (sessionEntries.isNotEmpty && 
        sessionEntries.last.id == event.entryId && 
        (sessionEntries.last.imagePath != null || sessionEntries.last.text.isNotEmpty)) {
      sessionEntries.add(DflEntry(id: _generateId()));
    }

    final newMap = Map<String, List<DflEntry>>.from(state.entries);
    newMap[event.sessionId] = sessionEntries;
    emit(state.copyWith(entries: newMap));
  }

  void _onDeleteEntry(DeleteEntry event, Emitter<EntryListState> emit) {
    final sessionEntries = _getEntries(event.sessionId);
    sessionEntries.removeWhere((i) => i.id == event.entryId);

    final newMap = Map<String, List<DflEntry>>.from(state.entries);
    newMap[event.sessionId] = sessionEntries;
    emit(state.copyWith(entries: newMap));
  }

  void _onUpdateTakeaway(UpdateTakeaway event, Emitter<EntryListState> emit) {
    final sessionTakeaways = List<String>.from(state.takeaways[event.sessionId] ?? ['', '', '']);
    if (event.index < sessionTakeaways.length) {
      sessionTakeaways[event.index] = event.text;
      final newMap = Map<String, List<String>>.from(state.takeaways);
      newMap[event.sessionId] = sessionTakeaways;
      emit(state.copyWith(takeaways: newMap));
    }
  }

  @override
  EntryListState? fromJson(Map<String, dynamic> json) => EntryListState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(EntryListState state) => state.toJson();
}
