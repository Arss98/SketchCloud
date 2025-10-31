import 'package:sketch_cloud/core/constants/app_strings.dart';
import 'package:sketch_cloud/core/errors/base_error.dart';

sealed class ValidationError extends AppError {
  const ValidationError(super.message);
}

final class EmptyEmailError extends ValidationError {
  EmptyEmailError() : super(AppStrings.validationErrors.emptyEmail);
}

final class EmptyPasswordError extends ValidationError {
  EmptyPasswordError() : super(AppStrings.validationErrors.emptyPassword);
}

final class EmptyUsernameError extends ValidationError {
  EmptyUsernameError() : super(AppStrings.validationErrors.emptyUsername);
}

final class UserNameTooShortError extends ValidationError {
  UserNameTooShortError() : super(AppStrings.validationErrors.userNameTooShort);
}

final class PasswordTooShortError extends ValidationError {
  PasswordTooShortError() : super(AppStrings.validationErrors.passwordTooShort);
}

final class PasswordsDoNotMatchError extends ValidationError {
  PasswordsDoNotMatchError() : super(AppStrings.validationErrors.passwordsDoNotMatch);
}

final class InvalidEmailFormatError extends ValidationError {
  InvalidEmailFormatError() : super(AppStrings.validationErrors.invalidEmailFormat);
}