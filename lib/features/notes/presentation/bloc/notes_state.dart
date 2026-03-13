part of 'notes_bloc.dart';

class NotesState extends Equatable {
  final Map<String, NoteContent> notes;

  const NotesState({this.notes = const {}});

  NotesState copyWith({Map<String, NoteContent>? notes}) {
    return NotesState(notes: notes ?? this.notes);
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory NotesState.fromJson(Map<String, dynamic> json) {
    final notesMap = (json['notes'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(
            key,
            NoteContent.fromJson(value as Map<String, dynamic>),
          ),
        ) ??
        {};
    return NotesState(notes: notesMap);
  }

  @override
  List<Object> get props => [notes];
}
