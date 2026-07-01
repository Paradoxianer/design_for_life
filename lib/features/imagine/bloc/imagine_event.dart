part of 'imagine_bloc.dart';

abstract class ImagineEvent extends Equatable {
  const ImagineEvent();
  @override
  List<Object?> get props => [];
}

class SelectPastImage extends ImagineEvent {
  final String sessionId;
  final String imageId;
  const SelectPastImage(this.sessionId, this.imageId);
  @override
  List<Object?> get props => [sessionId, imageId];
}

class SelectFutureImage extends ImagineEvent {
  final String sessionId;
  final String imageId;
  const SelectFutureImage(this.sessionId, this.imageId);
  @override
  List<Object?> get props => [sessionId, imageId];
}
