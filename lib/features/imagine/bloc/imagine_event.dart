part of 'imagine_bloc.dart';

abstract class ImagineEvent extends Equatable {
  const ImagineEvent();
  @override
  List<Object?> get props => [];
}

class SelectPastImage extends ImagineEvent {
  final String sessionId;
  final String imageUrl;
  const SelectPastImage(this.sessionId, this.imageUrl);
  @override
  List<Object?> get props => [sessionId, imageUrl];
}

class SelectFutureImage extends ImagineEvent {
  final String sessionId;
  final String imageUrl;
  const SelectFutureImage(this.sessionId, this.imageUrl);
  @override
  List<Object?> get props => [sessionId, imageUrl];
}

class UpdateImagineTakeaway extends ImagineEvent {
  final String sessionId;
  final String text;
  const UpdateImagineTakeaway(this.sessionId, this.text);
  @override
  List<Object?> get props => [sessionId, text];
}
