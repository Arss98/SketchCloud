import 'package:sketch_cloud/core/router/app_router.dart';
import 'package:sketch_cloud/core/constants/app_routes.dart';
import 'package:sketch_cloud/data/services/navigation_service.dart';
import 'package:sketch_cloud/data/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch_cloud/data/services/auth_service.dart';
import 'package:sketch_cloud/features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService: AuthService())
            ..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Sketch Cloud',
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigation.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.initialRoute,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          appNavigation.pushReplacementNamed(AppRoutes.gallery);
        } else if (state is AuthUnauthenticated) {
          appNavigation.pushReplacementNamed(AppRoutes.signIn);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial || state is AuthLoading) {
            return const SplashScreen();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}