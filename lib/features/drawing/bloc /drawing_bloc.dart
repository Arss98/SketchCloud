// features/drawing/bloc/drawing_bloc.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sketch_cloud/data/services/notification_service.dart';
import 'package:sketch_cloud/data/services/storage_service.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

final class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final StorageService _storageService;
  final NotificationService _notificationService;

  DrawingBloc({required StorageService storageService})
    : _storageService = storageService,
      _notificationService = NotificationService(),
      super(DrawingInitial()) {

    _notificationService.initialize();
    
    on<DrawingSaved>(_onDrawingSaved);
    on<DrawingExported>(_onDrawingExported);
    on<DrawingUpdated>(_onDrawingUpdated);
  }

  Future<void> _onDrawingSaved(
    DrawingSaved event,
    Emitter<DrawingState> emit,
  ) async {
    emit(DrawingSaving());

    try {
      final saveResult = await _storageService.saveImage(event.imageFile);

      await saveResult.fold(
        onSuccess: (imageModel) async {
          await _notificationService.showSaveSuccessNotification();
          emit(DrawingSaveSuccess());
        },
        onFailure: (error) {
          emit(DrawingError('Ошибка сохранения в облако: ${error.message}'));
        },
      );
    } catch (e) {
      await _notificationService.showErrorNotification('Ошибка сохранения: $e');
      emit(DrawingError('Ошибка сохранения: $e'));
    }
  }

  Future<void> _onDrawingUpdated(
    DrawingUpdated event,
    Emitter<DrawingState> emit,
  ) async {
    emit(DrawingSaving());

    try {
      final updateResult = await _storageService.updateImage(
        event.imageFile,
        event.imageId,
      );

      await updateResult.fold(
        onSuccess: (imageModel) async {
          await _notificationService.showSaveSuccessNotification();
          emit(DrawingSaveSuccess());
        },
        onFailure: (error) {
          emit(DrawingError('Ошибка обновления в облаке: ${error.message}'));
        },
      );
    } catch (e) {
      await _notificationService.showErrorNotification('Ошибка обновления: $e');
      emit(DrawingError('Ошибка обновления: $e'));
    }
  }

  Future<void> _onDrawingExported(
    DrawingExported event,
    Emitter<DrawingState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      await Share.shareXFiles([
        XFile(event.imageFile.path),
      ], text: 'Мой рисунок из Sketch Cloud');

      emit(const DrawingExportSuccess('Изображение экспортировано'));
    } catch (e) {
      emit(DrawingError('Ошибка экспорта: $e'));
    }
  }
}
