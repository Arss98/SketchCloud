part of 'drawing_bloc.dart';

sealed class DrawingEvent extends Equatable {
  const DrawingEvent();
}

final class DrawingSaved extends DrawingEvent {
  final File imageFile;
  const DrawingSaved(this.imageFile);
  @override List<Object> get props => [imageFile];
}

final class DrawingExported extends DrawingEvent {
  final File imageFile;
  const DrawingExported(this.imageFile);
  @override List<Object> get props => [imageFile];
}

final class DrawingUpdated extends DrawingEvent {
  final File imageFile;
  final String imageId;
  const DrawingUpdated(this.imageFile, this.imageId);
  @override List<Object> get props => [imageFile, imageId];
}