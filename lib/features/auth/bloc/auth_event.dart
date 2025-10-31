part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, username];
}

final class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

final class SignOutRequested extends AuthEvent {}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}