part of 'gallery_bloc.dart';

sealed class GalleryEvent extends Equatable {
  const GalleryEvent();
  
  @override
  List<Object> get props => [];
}

final class GalleryLoadRequested extends GalleryEvent {}

final class GalleryImageAdded extends GalleryEvent {
  final File imageFile;
  final String? title;

  const GalleryImageAdded(this.imageFile, [this.title]);

  @override
  List<Object> get props => [imageFile];
}

final class GalleryImageDeleted extends GalleryEvent {
  final String imageId;
  
  const GalleryImageDeleted(this.imageId);
  
  @override
  List<Object> get props => [imageId];
}