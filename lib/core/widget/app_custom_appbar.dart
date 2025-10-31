import 'package:flutter/material.dart';
import 'package:sketch_cloud/core/constants/app_colors.dart';
import 'package:sketch_cloud/core/constants/app_text_styles.dart';

final class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool hasImages;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.hasImages = false,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Colors.transparent,
        boxShadow: [
          const BoxShadow(color: Color.fromARGB(79, 227, 227, 227)),
          const BoxShadow(
            color: AppColors.appTextFieldBackground,
            blurRadius: 50,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                icon: leftIcon ?? Image.asset('assets/images/icons/logOut.png'),
                onPressed: onLeftPressed,
              ),

              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: AppTextStyles.roboto17w500.copyWith(
                      color: AppColors.appWhite
                    ),
                  ),
                ),
              ),

              if (hasImages)
                IconButton(
                  icon:
                      rightIcon ??
                      Image.asset('assets/images/icons/paintRoller.png'),
                  onPressed: onRightPressed,
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
