import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sketch_cloud/core/errors/gallery_errors.dart';
import 'package:sketch_cloud/core/utils/result.dart';
import 'package:sketch_cloud/data/models/image_model.dart';

final class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String userId;
  final String userName;

  StorageService({required this.userId, required this.userName});

  Future<Result<List<ImageModel>, GalleryError>> loadUserImages() async {
    try {
      final listResult = await _storage.ref('users/$userId/images').listAll();

      final images = await Future.wait(
        listResult.items.map((ref) async {
          final downloadUrl = await ref.getDownloadURL();
          final metadata = await ref.getMetadata();

          return ImageModel(
            id: ref.name,
            downloadUrl: downloadUrl,
            createdAt: metadata.timeCreated ?? DateTime.now(),
          );
        }),
      );

      images.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(images);
    } catch (e) {
      if (e.toString().contains('No such object')) {
        return Success([]);
      }
      return Failure(GalleryLoadError());
    }
  }

  Future<Result<ImageModel, GalleryError>> saveImage(File imageFile) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final Reference ref = _storage.ref('users/$userId/images/$fileName');

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/png',
          customMetadata: {
            'title': 'Изображение',
            'usen': userName,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final metadata = await snapshot.ref.getMetadata();

      final image = ImageModel(
        id: fileName,
        downloadUrl: downloadUrl,
        createdAt: metadata.timeCreated ?? DateTime.now(),
      );

      return Success(image);
    } catch (e) {
      return Failure(GallerySaveError());
    }
  }

  Future<Result<ImageModel, GalleryError>> updateImage(
    File imageFile,
    String imageId, 
  ) async {
    try {
      final Reference ref = _storage.ref('users/$userId/images/$imageId');

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/png',
          customMetadata: {
            'title': 'Изображение',
            'usen': userName,
            'uploadedAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now()
                .toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final metadata = await snapshot.ref.getMetadata();

      final image = ImageModel(
        id: imageId,
        downloadUrl: downloadUrl,
        createdAt: metadata.timeCreated ?? DateTime.now(),
      );

      return Success(image);
    } catch (e) {
      return Failure(GallerySaveError());
    }
  }

  Future<Result<void, GalleryError>> deleteImage(String imageId) async {
    try {
      final Reference ref = _storage.ref('users/$userId/images/$imageId');
      await ref.delete();
      return Success(null);
    } catch (e) {
      return Failure(GalleryDeleteError());
    }
  }

  Future<Map<String, dynamic>?> loadImageData(String imageId) async {
    try {
      final ref = _storage.ref('users/$userId/images/$imageId');
      final metadata = await ref.getMetadata();
      return metadata.customMetadata;
    } catch (e) {
      return null;
    }
  }
}
