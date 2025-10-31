part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class ErrorState extends AuthState {
  final List<AppError> errors;

  const ErrorState(this.errors);

  @override
  List<Object> get props => [errors];
  
  bool get hasSingleError => errors.length == 1;
  bool get hasMultipleErrors => errors.length > 1;
  
  String get firstErrorMessage => errors.first.message;
  
  String get combinedErrorMessages =>
      errors.map((e) => e.message).join('\n');
}