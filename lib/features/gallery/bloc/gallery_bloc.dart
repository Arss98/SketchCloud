import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sketch_cloud/data/models/image_model.dart';
import 'package:sketch_cloud/data/services/storage_service.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

final class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final StorageService galleryService;

  GalleryBloc({required this.galleryService})
    : super(GalleryInitial()) {
    on<GalleryLoadRequested>(_onGalleryLoadRequested);
    on<GalleryImageAdded>(_onGalleryImageAdded);
    on<GalleryImageDeleted>(_onGalleryImageDeleted);
  }

  Future<void> _onGalleryLoadRequested(
    GalleryLoadRequested event,
    Emitter<GalleryState> emit,
  ) async {
    emit(GalleryLoading());

    final result = await galleryService.loadUserImages();

    result.fold(
      onSuccess: (images) => emit(GalleryLoaded(images)),
      onFailure: (error) => emit(GalleryError(error.message)),
    );
  }

  Future<void> _onGalleryImageAdded(
    GalleryImageAdded event,
    Emitter<GalleryState> emit,
  ) async {
    final result = await galleryService.saveImage(event.imageFile);

    result.fold(
      onSuccess: (_) => add(GalleryLoadRequested()),
      onFailure: (error) {
        emit(GalleryError(error.message));
        if (state is GalleryLoaded) {
          Future.delayed(const Duration(seconds: 2), () => emit(state));
        }
      },
    );
  }

  Future<void> _onGalleryImageDeleted(
    GalleryImageDeleted event,
    Emitter<GalleryState> emit,
  ) async {
    final result = await galleryService.deleteImage(event.imageId);

    result.fold(
      onSuccess: (_) => add(GalleryLoadRequested()),
      onFailure: (error) {
        emit(GalleryError(error.message));
        if (state is GalleryLoaded) {
          Future.delayed(const Duration(seconds: 2), () => emit(state));
        }
      },
    );
  }
}
