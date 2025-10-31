import 'package:flutter/material.dart';

final class AppNavigation {
  static final AppNavigation _instance = AppNavigation._internal();
  factory AppNavigation() => _instance;
  AppNavigation._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  BuildContext? get context => navigatorKey.currentContext;
  
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName, 
      arguments: arguments
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName, 
      arguments: arguments
    );
  }

  void pop<T>([T? result]) {
    navigatorKey.currentState?.pop<T>(result);
  }

  void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }
}

final appNavigation = AppNavigation();