import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/note_content.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends HydratedBloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState()) {
    on<UpdateNoteText>(_onUpdateNoteText);
    on<UpdateTakeaway>(_onUpdateTakeaway);
  }

  void _onUpdateNoteText(UpdateNoteText event, Emitter<NotesState> emit) {
    final updatedNotes = Map<String, NoteContent>.from(state.notes);
    final currentNote = updatedNotes[event.sessionId] ?? NoteContent(sessionId: event.sessionId);
    
    updatedNotes[event.sessionId] = currentNote.copyWith(text: event.text);
    emit(state.copyWith(notes: updatedNotes));
  }

  void _onUpdateTakeaway(UpdateTakeaway event, Emitter<NotesState> emit) {
    final updatedNotes = Map<String, NoteContent>.from(state.notes);
    final currentNote = updatedNotes[event.sessionId] ?? NoteContent(sessionId: event.sessionId);
    
    final updatedTakeaways = List<String>.from(currentNote.takeaways);
    if (event.index < updatedTakeaways.length) {
      updatedTakeaways[event.index] = event.text;
    }
    
    updatedNotes[event.sessionId] = currentNote.copyWith(takeaways: updatedTakeaways);
    emit(state.copyWith(notes: updatedNotes));
  }

  @override
  NotesState? fromJson(Map<String, dynamic> json) => NotesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(NotesState state) => state.toJson();
}
