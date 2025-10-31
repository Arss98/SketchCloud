part of 'drawing_bloc.dart';

sealed class DrawingState extends Equatable {
  const DrawingState();
}

final class DrawingInitial extends DrawingState {
  @override List<Object> get props => [];
}

final class DrawingSaving extends DrawingState {
  @override List<Object> get props => [];
}

final class DrawingSaveSuccess extends DrawingState {
  @override List<Object> get props => [];
}

final class DrawingExportSuccess extends DrawingState {
  final String message;
  const DrawingExportSuccess(this.message);
  @override List<Object> get props => [message];
}

final class DrawingError extends DrawingState {
  final String message;
  const DrawingError(this.message);
  @override List<Object> get props => [message];
}