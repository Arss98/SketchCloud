import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:sketch_cloud/data/models/drawing_point.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;
  final ui.Image? backgroundImage;

  const DrawingPainter({
    required this.points,
    this.backgroundImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    if (backgroundImage != null) {
      _paintBackgroundImage(canvas, size);
    }

    _paintDrawingPoints(canvas);
  }

  void _paintBackgroundImage(Canvas canvas, Size size) {
    try {
      final image = backgroundImage!;
      final imageWidth = image.width.toDouble();
      final imageHeight = image.height.toDouble();
      
      final scaleX = size.width / imageWidth;
      final scaleY = size.height / imageHeight;
      final scale = scaleX < scaleY ? scaleX : scaleY;
      
      final offsetX = (size.width - (imageWidth * scale)) / 2;
      final offsetY = (size.height - (imageHeight * scale)) / 2;
      
      canvas.save();
      canvas.translate(offsetX, offsetY);
      canvas.scale(scale);
      
      canvas.drawImage(image, Offset.zero, Paint()..filterQuality = FilterQuality.high);
      canvas.restore();
    } catch (e) {
      debugPrint('Error painting background image: $e');
    }
  }

  void _paintDrawingPoints(Canvas canvas) {
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      
      if (currentPoint.offset == Offset.zero || nextPoint.offset == Offset.zero) {
        continue;
      }

      final paint = Paint()
        ..color = currentPoint.color
        ..strokeWidth = currentPoint.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(currentPoint.offset, nextPoint.offset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}