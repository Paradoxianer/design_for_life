part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class AddNoteEntry extends NotesEvent {
  final String sessionId;
  const AddNoteEntry({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class UpdateNoteEntryText extends NotesEvent {
  final String sessionId;
  final String entryId;
  final String text;

  const UpdateNoteEntryText({
    required this.sessionId,
    required this.entryId,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, entryId, text];
}

class ToggleNoteEntryCompletion extends NotesEvent {
  final String sessionId;
  final String entryId;

  const ToggleNoteEntryCompletion({
    required this.sessionId,
    required this.entryId,
  });

  @override
  List<Object?> get props => [sessionId, entryId];
}

class UpdateNoteEntryImage extends NotesEvent {
  final String sessionId;
  final String entryId;
  final String? imagePath;

  const UpdateNoteEntryImage({
    required this.sessionId,
    required this.entryId,
    this.imagePath,
  });

  @override
  List<Object?> get props => [sessionId, entryId, imagePath];
}

class UpdateNoteTakeaway extends NotesEvent {
  final String sessionId;
  final int index;
  final String text;

  const UpdateNoteTakeaway({
    required this.sessionId,
    required this.index,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, index, text];
}
