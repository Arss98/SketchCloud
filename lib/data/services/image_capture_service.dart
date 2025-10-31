import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ImageCaptureService {
  static Future<Uint8List?> captureImageFromRepaintBoundary(
    GlobalKey repaintBoundaryKey,
  ) async {
    try {
      final boundary = repaintBoundaryKey.currentContext?.findRenderObject() 
          as RenderRepaintBoundary?;
      
      if (boundary == null) {
        throw Exception('Render boundary not found');
      }

      await Future.delayed(const Duration(milliseconds: 100));

      final image = await boundary.toImage(
        pixelRatio: 3.0, 
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      image.dispose();

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      return byteData.buffer.asUint8List();
    } catch (e, stackTrace) {
      debugPrint('Image capture error: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }
}