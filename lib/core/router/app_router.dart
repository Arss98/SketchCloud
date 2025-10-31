import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch_cloud/core/constants/app_routes.dart';
import 'package:sketch_cloud/data/models/image_model.dart';
import 'package:sketch_cloud/data/services/navigation_service.dart';
import 'package:sketch_cloud/data/services/storage_service.dart';
import 'package:sketch_cloud/features/auth/bloc/auth_bloc.dart';
import 'package:sketch_cloud/features/auth/pages/sign_in_screen.dart';
import 'package:sketch_cloud/features/auth/pages/sign_up_screen.dart';
import 'package:sketch_cloud/features/drawing/bloc%20/drawing_bloc.dart';
import 'package:sketch_cloud/features/drawing/pages/drawing_screen.dart';
import 'package:sketch_cloud/features/gallery/bloc/gallery_bloc.dart';
import 'package:sketch_cloud/features/gallery/pages/gallery_screen.dart';

final class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.gallery:
        return MaterialPageRoute(
          builder: (_) {
            final authBloc = BlocProvider.of<AuthBloc>(
              appNavigation.navigatorKey.currentContext!,
            );

            return BlocBuilder<AuthBloc, AuthState>(
              bloc: authBloc,
              builder: (context, authState) {
                if (authState is AuthAuthenticated) {
                  return BlocProvider(
                    create: (context) => GalleryBloc(
                      galleryService: StorageService(
                        userId: authState.user.uid,
                        userName: authState.user.username
                      ),
                    )..add(GalleryLoadRequested()),
                    child: const GalleryScreen(),
                  );
                }
                return const SignInScreen();
              },
            );
          },
        );

      case AppRoutes.drawing:
        return MaterialPageRoute(
          builder: (_) {
            final authBloc = BlocProvider.of<AuthBloc>(
              appNavigation.navigatorKey.currentContext!,
            );

            final image = settings.arguments as ImageModel?;

            return BlocBuilder<AuthBloc, AuthState>(
              bloc: authBloc,
              builder: (context, authState) {
                if (authState is AuthAuthenticated) {
                  return BlocProvider(
                    create: (context) => DrawingBloc(
                      storageService: StorageService(
                        userId: authState.user.uid,
                        userName: authState.user.username
                      ),
                    ),
                    child: DrawingScreen(image: image, userId: authState.user.uid),
                  );
                }
                return const SignInScreen();
              },
            );
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
