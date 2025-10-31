import 'package:flutter/material.dart';
import 'package:sketch_cloud/core/constants/app_colors.dart';
import 'package:sketch_cloud/features/drawing/widgets/custom_icon_button.dart';

final class ToolPanel extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onImportFromGallery;
  final VoidCallback onPencil;
  final VoidCallback onEraser;
  final VoidCallback onColorPicker;

  const ToolPanel({
    super.key,
    required this.onExport,
    required this.onImportFromGallery,
    required this.onPencil,
    required this.onEraser,
    required this.onColorPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Spacer(),
          CustomIconButton(
            backgroundColor: AppColors.appWhiteAlpha,
            iconPath: 'assets/images/icons/export.png',
            onPressed: onExport,
          ),
          const SizedBox(width: 12),
          CustomIconButton(
            backgroundColor: AppColors.appWhiteAlpha,
            iconPath: 'assets/images/icons/gallery.png',
            onPressed: onImportFromGallery,
          ),
          const SizedBox(width: 12),
          CustomIconButton(
            backgroundColor: AppColors.appWhiteAlpha,
            iconPath: 'assets/images/icons/pencil.png',
            onPressed: onPencil,
          ),
          const SizedBox(width: 12),
          CustomIconButton(
            backgroundColor: AppColors.appWhiteAlpha,
            iconPath: 'assets/images/icons/eraser.png',
            onPressed: onEraser,
          ),
          const SizedBox(width: 12),
          CustomIconButton(
            backgroundColor: AppColors.appWhiteAlpha,
            iconPath: 'assets/images/icons/colors.png',
            onPressed: onColorPicker,
          ),
        ],
      ),
    );
  }
}
