import 'package:flutter/material.dart';
import 'package:sketch_cloud/core/widget/app_background.dart';

final class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final bool extendBodyBehindAppBar;
  final Widget body;

  const AppScaffold({
    super.key,
    this.appBar,
    this.extendBodyBehindAppBar = false,
    required this.body,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: AppBackground(child: body),
    );
  }
}