import 'package:flutter/material.dart';
import 'package:sketch_cloud/core/constants/app_colors.dart';
import 'package:sketch_cloud/core/constants/app_text_styles.dart';

final class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.placeholder,
    this.focusNode,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
  });

  final String title;
  final String placeholder;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: AppColors.appGray),
          boxShadow: [
            const BoxShadow(color: AppColors.appTextFieldShadow),
            const BoxShadow(
              color: AppColors.appTextFieldBackground,
              blurRadius: 50,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.roboto12w400),
            const SizedBox(height: 4),
            TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: textInputAction,
              obscureText: obscureText,
              obscuringCharacter: '*',
              style: AppTextStyles.roboto14w400.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: AppTextStyles.roboto14w400,
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appGray, width: 1),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appGray, width: 1),
                ),
                contentPadding: const EdgeInsets.only(bottom: 2),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}