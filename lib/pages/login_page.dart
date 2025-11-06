import 'dart:math';

import 'package:bingio/shared/app_toast.dart';
import 'package:bingio/shared/button_plain_text.dart';
import 'package:bingio/shared/button_solid.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode loginButtonFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const double verticalPadding = 10.0;

  DateTime lastBackPressTime = DateTime.now();

  void logUserIn() async {
    showAppToast('Log In not implemented yet.');
    return;

    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        DateTime now = DateTime.now();
        if (now.difference(lastBackPressTime) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          showAppToast('Press back again to exit');
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: APPCOLORS.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                GradientText(text: 'Welcome to ${STRINGS.appName}'),

                SizedBox(height: 40),
                Text(
                  'Please log in to continue.',
                  style: APPSTYLES.regularText,
                ),
                
                FocusScope(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InputField(
                        autoFocus: true,
                        controller: emailController,
                        hintText:  'Email',
                        focusNode: emailFocusNode,
                        nextFocus: passwordFocusNode,
                        paddingHorizontal: verticalPadding * 4,
                        paddingVertical: verticalPadding,
                      ),

                      InputField(
                        controller: passwordController,
                        hintText:  'Password',
                        focusNode: passwordFocusNode,
                        nextFocus: loginButtonFocusNode,
                        paddingHorizontal: verticalPadding * 4,
                        paddingVertical: verticalPadding,
                        obscureText: true,
                      ),

                      SolidButton(
                        focusNode: loginButtonFocusNode,
                        text: 'Log In',
                        onPressed: logUserIn,
                        paddingVertical: verticalPadding,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: APPSTYLES.regularText,
                          ),
                          PlainTextButton(
                            text: 'Sign Up',
                            onPressed: () {
                              showAppToast('Sign Up not implemented yet.');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
