
import 'dart:async';

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
          throw AuthServiceException('Must provide Email and Password');
        case 'invalid-email':
          throw AuthServiceException('Invalid email format');
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          throw AuthServiceException('Incorrect Email or Password');
        case 'user-disabled':
          throw AuthServiceException('Account disabled');
        case 'user-token-expired':
          throw AuthServiceException('User authentication expired');
        case 'operation-not-allowed':
          throw AuthServiceException('This method is not enabled');
        case 'too-many-requests':
          throw AuthServiceException('Too many requests, please wait a bit and try again later');
        case 'network-request-failed':
          throw AuthServiceException('Network error, check your connection');
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
          throw AuthServiceException('Must provide Email and Password');
        case 'invalid-email':
          throw AuthServiceException('Invalid email format');
        case 'email-already-in-use':
          throw AuthServiceException('Email address already in use');
        case 'weak-password':
          throw AuthServiceException('Weak password, password must be at least 6 characters');
        case 'user-token-expired':
          throw AuthServiceException('User authentication expired');
        case 'operation-not-allowed':
          throw AuthServiceException('This method is not enabled');
        case 'too-many-requests':
          throw AuthServiceException('Too many requests, please wait a bit and try again later');
        case 'network-request-failed':
          throw AuthServiceException('Network error, check your connection');
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
      throw AuthServiceException('Google Sign In cancelled');
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
          throw AuthServiceException('Account exists with different credential, remove from Google Apps & Services');
        case 'invalid-credential':
        case 'invalid-verification-code':
        case 'invalid-verification-id':
          throw AuthServiceException('Credential has expired, try clearing app storage');
        case 'operation-not-allowed':
          throw AuthServiceException('This method is not enabled');
        case 'user-disabled':
          throw AuthServiceException('Account disabled');
        case 'user-not-found':
          throw AuthServiceException('There is no User to the corresponding Email');
        case 'wrong-password':
          throw AuthServiceException('Invalid or unset password for the Email account');
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
