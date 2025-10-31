import 'package:flutter/material.dart';
import 'package:sketch_cloud/core/constants/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double size;
  final EdgeInsetsGeometry padding;

  const CustomIconButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
    required this.backgroundColor,
    this.size = 38,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          splashColor: AppColors.appWhiteAlpha,
          child: Container(
            width: size,
            height: size,
            padding: padding,
            child: Image.asset(iconPath),
          ),
        ),
      ),
    );
  }
}