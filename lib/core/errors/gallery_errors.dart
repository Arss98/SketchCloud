import 'package:sketch_cloud/core/constants/app_strings.dart';

sealed class GalleryError {
  final String message;
  const GalleryError(this.message);
}

final class GalleryLoadError extends GalleryError {
  GalleryLoadError() : super(AppStrings.galleryErrors.loadError);
}

final class GallerySaveError extends GalleryError {
  GallerySaveError() : super(AppStrings.galleryErrors.saveError);
}

final class GalleryDeleteError extends GalleryError {
  GalleryDeleteError() : super(AppStrings.galleryErrors.deleteError);
}

final class UnknownGalleryError extends GalleryError {
  UnknownGalleryError([String? customMessage])
    : super(customMessage ?? AppStrings.galleryErrors.unknownError);
}