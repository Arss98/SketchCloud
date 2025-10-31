import 'package:flutter/material.dart';
import 'package:sketch_cloud/core/constants/app_text_styles.dart';

final class AppCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final Gradient? gradient;

  const AppCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.textStyle = AppTextStyles.roboto17w500,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Container(
            padding: padding,
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
