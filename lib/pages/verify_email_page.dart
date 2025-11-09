import 'dart:async';
import 'package:bingio/pages/profiles_page.dart';
import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/button_plain_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final User? user = AuthService().getCurrentUser();
  bool _isEmailVerified = false;
  bool _canSendEmail = true;
  Timer? timer;

  void logOut() async {
    await AuthService().logOut();
  }

  void sendVerificationEmail() async {
    try {
      if (user == null) return;
      await user!.sendEmailVerification();
      showAppToast('Email sent, please check your account');

      setState(() => _canSendEmail = false);
      await Future.delayed(Duration(seconds: 10));
      setState(() => _canSendEmail = true);
    }
    catch (e) {
      showAppError(e.toString());
    }
  }

  Future checkEmailVerified() async {
    user!.reload();
    setState(() => _isEmailVerified = user!.emailVerified);

    if (_isEmailVerified) timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _isEmailVerified = user!.emailVerified;

    if (!_isEmailVerified) {
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
      ? ProfilesPage()
      : Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          actions: [IconButton(onPressed: logOut, icon: Icon(Icons.logout))],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Please verify your email to continue.'),
                PlainTextButton(
                  text: 'Send verification email to ${user!.email}',
                  onPressed: () => _canSendEmail 
                  ? sendVerificationEmail()
                  : showAppToast('Please wait a bit before trying to send again')
                )
              ],
            ),
          )
        )
      );
  }
}