import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<File> createTempImageFile(Uint8List imageBytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/sketch_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      await file.writeAsBytes(imageBytes);
      
      if (await file.exists() && await file.length() > 0) {
        return file;
      } else {
        throw Exception('Failed to create valid image file');
      }
    } catch (e) {
      throw Exception('File creation error: $e');
    }
  }

  static Future<void> cleanupTempFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final files = directory.listSync();
      
      final now = DateTime.now();
      for (var file in files) {
        if (file is File && file.path.endsWith('.png')) {
          final stat = await file.stat();
          if (now.difference(stat.modified).inHours > 1) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Cleanup error: $e');
    }
  }
}