import 'package:bingio/pages/login_page.dart';
import 'package:bingio/pages/register_page.dart';
import 'package:bingio/pages/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool showRegisterPage = false;

  void toggleLoginAndRegisterPages() {
    setState(() {
      showRegisterPage = !showRegisterPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is Logged In
          if (snapshot.hasData) {
            return VerifyEmailPage();
          }
          // User is NOT Logged In
          else {
            if (showRegisterPage) {
              return RegisterPage(
                toggleLoginAndRegisterPages: toggleLoginAndRegisterPages,
              );
            } else {
              return LoginPage(
                toggleLoginAndRegisterPages: toggleLoginAndRegisterPages,
              );
            }
          }
        }
      )
    );
  }
}