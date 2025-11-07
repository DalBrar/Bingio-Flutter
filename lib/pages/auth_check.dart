import 'package:bingio/pages/home_page.dart';
import 'package:bingio/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is Logged In
          if (snapshot.hasData) {
            return HomePage();
          }
          // User is NOT Logged In
          else {
            return LoginPage();
          }
        }
      )
    );
  }
}