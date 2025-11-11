
import 'dart:async';

import 'package:bingio/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Can throw AuthServiceException
  Future<UserCredential> logInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'channel-error':
          throw AuthServiceException(AppStrings.errEmailAndPasswordRequired);
        case 'invalid-email':
          throw AuthServiceException(AppStrings.errInvalidEmail);
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          throw AuthServiceException(AppStrings.errIncorrectCredentials);
        case 'user-disabled':
          throw AuthServiceException(AppStrings.errAccountDisabled);
        case 'user-token-expired':
          throw AuthServiceException(AppStrings.errAuthenticationExpired);
        case 'operation-not-allowed':
          throw AuthServiceException(AppStrings.errMethodNotEnabled);
        case 'too-many-requests':
          throw AuthServiceException(AppStrings.errTooManyRequests);
        case 'network-request-failed':
          throw AuthServiceException(AppStrings.errNetworkConnection);
        default:
          throw AuthServiceException('Auth Error: ${e.message}');
      }
    }
  }

  /// Can throw AuthServiceException
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'channel-error':
          throw AuthServiceException(AppStrings.errEmailAndPasswordRequired);
        case 'invalid-email':
          throw AuthServiceException(AppStrings.errInvalidEmail);
        case 'email-already-in-use':
          throw AuthServiceException(AppStrings.errEmailAlreadyInUse);
        case 'weak-password':
          throw AuthServiceException(AppStrings.errWeakPassword);
        case 'user-token-expired':
          throw AuthServiceException(AppStrings.errAuthenticationExpired);
        case 'operation-not-allowed':
          throw AuthServiceException(AppStrings.errMethodNotEnabled);
        case 'too-many-requests':
          throw AuthServiceException(AppStrings.errTooManyRequests);
        case 'network-request-failed':
          throw AuthServiceException(AppStrings.errNetworkConnection);
        default:
          throw AuthServiceException('Auth Error: ${e.message}');
      }
    }
  }

  /// Can throw AuthServiceException
  Future<UserCredential> logInWithGoogle() async {
    // Begin Log In process
    final GoogleSignInAccount? gSignIn = await GoogleSignIn().signIn();
    if (gSignIn == null) {
      throw AuthServiceException(AppStrings.errGoogleSignInCancelled);
    }
    // Obtain Auth details from Log In
    final GoogleSignInAuthentication gAuth = await gSignIn.authentication;
    // Create new OAuth credentials for user
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // Sign in to Firebase using credentials
    try {
      return await _firebaseAuth.signInWithCredential(credential);
    }
    on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'account-exists-with-different-credential':
          throw AuthServiceException(AppStrings.errGoogleAccountExistsDifferentCredential);
        case 'invalid-credential':
        case 'invalid-verification-code':
        case 'invalid-verification-id':
          throw AuthServiceException(AppStrings.errGoogleCredentialsExpired);
        case 'operation-not-allowed':
          throw AuthServiceException(AppStrings.errMethodNotEnabled);
        case 'user-disabled':
          throw AuthServiceException(AppStrings.errAccountDisabled);
        default:
          throw AuthServiceException('Auth Error: ${e.message}');
      }
    }
  }

  Future<void> logOut() async {
    return await _firebaseAuth.signOut();
  }

}

class AuthServiceException implements Exception {
  final String message;

  AuthServiceException([this.message = 'Generic Auth Error']);

  @override
  String toString() => message;
}
