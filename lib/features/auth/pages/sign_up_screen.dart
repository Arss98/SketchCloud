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

final class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();

    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _unfocusAll() {
    _usernameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _confirmPasswordFocusNode.unfocus();
  }

  void _signUp() {
    context.read<AuthBloc>().add(
      SignUpRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        username: _usernameController.text.trim(),
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    children: [
                                      const Spacer(),
                                      _buildEmailForm(),
                                      _buildPasswordForm(),
                                      const Spacer(),
                                      const SizedBox(height: 8),
                                      _buildSignUpButton(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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

  Widget _buildEmailForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNeonLabel(text: AppStrings.authScreen.registrationTitle),

            const SizedBox(height: 16),

            CustomTextField(
              title: AppStrings.authScreen.nameFieldTitle,
              placeholder: AppStrings.authScreen.nameFieldPlaceholder,
              controller: _usernameController,
              focusNode: _usernameFocusNode,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              title: AppStrings.authScreen.emailFieldTitle,
              placeholder: AppStrings.authScreen.emailFieldPlaceholderSignUp,
              controller: _emailController,
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16),
            Divider(color: AppColors.appDarkGrey, thickness: 1),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildPasswordForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              title: AppStrings.authScreen.passwordFieldTitle,
              placeholder: AppStrings.authScreen.passwordFieldPlaceholderLength,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.next,
              obscureText: true,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              title: AppStrings.authScreen.confirmPasswordFieldTitle,
              placeholder: AppStrings.authScreen.passwordFieldPlaceholderLength,
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              textInputAction: TextInputAction.done,
              obscureText: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            AppCustomButton(
              text: AppStrings.authScreen.signUpButton,
              onPressed: state is AuthLoading ? null : _signUp,
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
