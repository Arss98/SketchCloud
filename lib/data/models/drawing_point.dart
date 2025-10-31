import 'package:flutter/material.dart';

final class DrawingPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  const DrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });

  const DrawingPoint.empty()
      : offset = Offset.zero,
        color = Colors.transparent,
        strokeWidth = 0;
}