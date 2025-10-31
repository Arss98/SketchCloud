part of 'gallery_bloc.dart';

sealed class GalleryState extends Equatable {
  const GalleryState();
  
  @override
  List<Object> get props => [];
}

final class GalleryInitial extends GalleryState {}

final class GalleryLoading extends GalleryState {}

final class GalleryLoaded extends GalleryState {
  final List<ImageModel> images;
  
  const GalleryLoaded(this.images);
  
  @override
  List<Object> get props => [images];
}

final class GalleryError extends GalleryState {
  final String message;
  
  const GalleryError(this.message);
  
  @override
  List<Object> get props => [message];
}