import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sketch_cloud/data/models/user_model.dart';
import 'package:sketch_cloud/core/errors/auth_errors.dart';
import 'package:sketch_cloud/core/utils/result.dart';
import 'package:sketch_cloud/core/constants/app_strings.dart';

final class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<UserModel, AuthError>> registerUserWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) {
        return Failure(
          UnknownAuthError(AppStrings.authErrors.userCreationFailed),
        );
      }

      UserModel userModel = UserModel(
        uid: user.uid,
        email: email,
        username: username,
      );

      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toFirestore());

      return Success(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Failure(WeakPasswordError());
      } else if (e.code == 'email-already-in-use') {
        return Failure(EmailAlreadyInUseError());
      } else if (e.code == 'invalid-email') {
        return Failure(InvalidEmailError());
      } else if (e.code == 'operation-not-allowed') {
        return Failure(OperationNotAllowedError());
      }
      return Failure(
        UnknownAuthError(e.message ?? AppStrings.authErrors.unknownError),
      );
    } catch (e) {
      return Failure(UnknownAuthError(AppStrings.authErrors.unknownError));
    }
  }

  Future<Result<UserModel, AuthError>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) {
        return Failure(UnknownAuthError(AppStrings.authErrors.signInFailed));
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final Map<String, dynamic>? data = userDoc.data();

      if (!userDoc.exists || data == null) {
        return Failure(UserDataNotFoundError());
      }

      return Success(UserModel.fromFirestore(data));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Failure(UserNotFoundError());
      } else if (e.code == 'wrong-password') {
        return Failure(WrongPasswordError());
      } else if (e.code == 'invalid-email') {
        return Failure(InvalidEmailError());
      } else if (e.code == 'network-request-failed') {
        return Failure(NetworkError());
      }
      return Failure(
        UnknownAuthError(e.message ?? AppStrings.authErrors.unknownError),
      );
    } catch (e) {
      return Failure(UnknownAuthError(AppStrings.authErrors.unknownError));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        final Map<String, dynamic>? data = userDoc.data();

        if (userDoc.exists && data != null) {
          return UserModel.fromFirestore(data);
        }
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}
