import 'package:sketch_cloud/core/constants/app_strings.dart';
import 'package:sketch_cloud/core/errors/base_error.dart';

sealed class AuthError extends AppError {
  const AuthError(super.message);
}

final class WeakPasswordError extends AuthError {
  WeakPasswordError() : super(AppStrings.authErrors.weakPassword);
}

final class EmailAlreadyInUseError extends AuthError {
  EmailAlreadyInUseError() : super(AppStrings.authErrors.emailInUse);
}

final class UserNotFoundError extends AuthError {
  UserNotFoundError() : super(AppStrings.authErrors.userNotFound);
}

final class WrongPasswordError extends AuthError {
  WrongPasswordError() : super(AppStrings.authErrors.wrongPassword);
}

final class NetworkError extends AuthError {
  NetworkError() : super(AppStrings.authErrors.networkError);
}

final class InvalidEmailError extends AuthError {
  InvalidEmailError() : super(AppStrings.authErrors.invalidEmail);
}

final class UserDataNotFoundError extends AuthError {
  UserDataNotFoundError() : super(AppStrings.authErrors.userDataNotFound);
}

final class OperationNotAllowedError extends AuthError {
  OperationNotAllowedError() : super(AppStrings.authErrors.operationNotAllowed);
}

final class UnknownAuthError extends AuthError {
  UnknownAuthError([String? customMessage])
    : super(customMessage ?? AppStrings.authErrors.unknownError);
}
