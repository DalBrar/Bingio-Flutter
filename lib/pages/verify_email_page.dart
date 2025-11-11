import 'dart:async';
import 'package:bingio/pages/profiles_page.dart';
import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/btn_plain_text.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/my_app_bar.dart';
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

  void sendVerificationEmail() async {
    try {
      if (user == null) return;

      await checkEmailVerified();

      if (_isEmailVerified) return;

      await user!.sendEmailVerification();

      setState(() => _canSendEmail = false);
      await Future.delayed(Duration(seconds: 60));
      setState(() => _canSendEmail = true);
    }
    catch (e) {
      showAppError(e.toString());
    }
  }

  Future checkEmailVerified() async {
    await user!.reload();
    setState(() => _isEmailVerified = user!.emailVerified);

    if (_isEmailVerified) timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    loadingSpinnerHide();
    sendVerificationEmail();
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
        appBar: MyAppBar(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.pleaseVerifyEmail,
                  style: AppStyles.largeText,
                ),
                SizedBox(height: 25),
                PlainTextBtn(
                  autoFocus: true,
                  text: _canSendEmail ? '${AppStrings.btnSendVerificationTo} ${user!.email}' : AppStrings.btnEmailSentCheckAccount,
                  onPressed: () => _canSendEmail 
                  ? sendVerificationEmail()
                  : showAppToast(AppStrings.pleaseWaitBeforeTryAgain)
                )
              ],
            ),
          )
        )
      );
  }
}