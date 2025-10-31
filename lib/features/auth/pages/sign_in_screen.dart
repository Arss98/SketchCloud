import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch_cloud/core/constants/app_colors.dart';
import 'package:sketch_cloud/core/constants/app_routes.dart';
import 'package:sketch_cloud/core/constants/app_strings.dart';
import 'package:sketch_cloud/core/constants/app_text_styles.dart';
import 'package:sketch_cloud/core/widget/app_custom_button.dart';
import 'package:sketch_cloud/core/widget/app_custom_textfield.dart';
import 'package:sketch_cloud/core/widget/app_neon_label.dart';
import 'package:sketch_cloud/core/widget/app_scaffold.dart';
import 'package:sketch_cloud/features/auth/bloc/auth_bloc.dart';

final class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _unfocusAll() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  void _signIn() {
    context.read<AuthBloc>().add(
      SignInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.gallery);
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.firstErrorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Stack(
          children: [
            IgnorePointer(
              ignoring: isLoading,
              child: Opacity(
                opacity: isLoading ? 0.6 : 1.0,
                child: GestureDetector(
                  onTap: _unfocusAll,
                  child: AppScaffold(
                    body: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            const Spacer(),
                            _buildLoginForm(),
                            const Spacer(),
                            _buildAuthButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNeonLabel(text: AppStrings.authScreen.loginTitle),

            const SizedBox(height: 16),

            CustomTextField(
              title: AppStrings.authScreen.emailFieldTitle,
              placeholder: AppStrings.authScreen.emailFieldPlaceholderSignIn,
              focusNode: _emailFocusNode,
              controller: _emailController,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              title: AppStrings.authScreen.passwordFieldTitle,
              placeholder: AppStrings.authScreen.passwordFieldPlaceholderSignIn,
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAuthButtons() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            AppCustomButton(
              text: AppStrings.authScreen.signInButton,
              onPressed: state is AuthLoading ? null : _signIn,
              gradient: LinearGradient(
                colors: [
                  AppColors.appGradientMain,
                  AppColors.appGradientSecondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            const SizedBox(height: 16),
            AppCustomButton(
              text: AppStrings.authScreen.registrationTitle,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.signUp);
              },
              textStyle: AppTextStyles.roboto17w500.copyWith(
                color: Colors.black,
              ),
              color: Colors.white,
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
