import 'package:flutter/material.dart';

final class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  static const String _backgroundMain = 'assets/images/background/background.png';
  static const String _backgroundSecondary = 'assets/images/background/backgroundLines.png';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainLayer(),
        _buildSecondaryLayer(),
        child,
      ],
    );
  }

  Widget _buildMainLayer() {
    return Image.asset(
      _backgroundMain,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildSecondaryLayer() {
    return Positioned(
      top: 0,
      left: 0,
      child: Image.asset(
        _backgroundSecondary,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
