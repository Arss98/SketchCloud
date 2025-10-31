import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sketch_cloud/core/errors/base_error.dart';
import 'package:sketch_cloud/core/errors/validation_errors.dart';
import 'package:sketch_cloud/data/services/auth_service.dart';
import 'package:sketch_cloud/data/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final currentUser = await authService.getCurrentUser();

      if (currentUser != null) {
        emit(AuthAuthenticated(currentUser));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final validationErrors = _validateSignUpData(event: event);
    if (validationErrors.isNotEmpty) {
      emit(ErrorState(validationErrors));
      return;
    }

    emit(const AuthLoading());

    final result = await authService.registerUserWithEmailAndPassword(
      event.email,
      event.password,
      event.username,
    );

    result.fold(
      onSuccess: (user) => emit(AuthAuthenticated(user)),
      onFailure: (error) => emit(ErrorState([error])),
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    final validationErrors = _validateSignInData(event: event);
    if (validationErrors.isNotEmpty) {
      emit(ErrorState(validationErrors));
      return;
    }

    emit(AuthLoading());

    final result = await authService.signInWithEmailAndPassword(
      event.email,
      event.password,
    );

    result.fold(
      onSuccess: (user) => emit(AuthAuthenticated(user)),
      onFailure: (error) => emit(ErrorState([error])),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await authService.signOut();
    emit(AuthUnauthenticated());
  }
}

extension AuthValidation on AuthBloc {
  List<ValidationError> _validateSignUpData({required SignUpRequested event}) {
    final errors = <ValidationError>[];

    if (event.email.isEmpty) {
      errors.add(EmptyEmailError());
    } else {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(event.email)) {
        errors.add(InvalidEmailFormatError());
      }
    }

    if (event.password.isEmpty) {
      errors.add(EmptyPasswordError());
    } else if (event.password.length < 8) {
      errors.add(PasswordTooShortError());
    }

    if (event.password != event.confirmPassword) {
      errors.add(PasswordsDoNotMatchError());
    }

    if (event.username.isEmpty) {
      errors.add(EmptyUsernameError());
    } else if (event.username.length < 2) {
      errors.add(UserNameTooShortError());
    }

    return errors;
  }

  List<ValidationError> _validateSignInData({required SignInRequested event}) {
    final errors = <ValidationError>[];

    if (event.email.isEmpty) {
      errors.add(EmptyEmailError());
    } else {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(event.email)) {
        errors.add(InvalidEmailFormatError());
      }
    }

    if (event.password.isEmpty) {
      errors.add(EmptyPasswordError());
    }

    return errors;
  }
}
