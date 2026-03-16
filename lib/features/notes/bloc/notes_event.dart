part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class UpdateNoteText extends NotesEvent {
  final String sessionId;
  final String text;

  const UpdateNoteText({required this.sessionId, required this.text});

  @override
  List<Object> get props => [sessionId, text];
}

class UpdateTakeaway extends NotesEvent {
  final String sessionId;
  final int index;
  final String text;

  const UpdateTakeaway({
    required this.sessionId,
    required this.index,
    required this.text,
  });

  @override
  List<Object> get props => [sessionId, index, text];
}

class AddNoteImage extends NotesEvent {
  final String sessionId;
  final String imagePath;

  const AddNoteImage({required this.sessionId, required this.imagePath});

  @override
  List<Object> get props => [sessionId, imagePath];
}

class RemoveNoteImage extends NotesEvent {
  final String sessionId;
  final String imagePath;

  const RemoveNoteImage({required this.sessionId, required this.imagePath});

  @override
  List<Object> get props => [sessionId, imagePath];
}
