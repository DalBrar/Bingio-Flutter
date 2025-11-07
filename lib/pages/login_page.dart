import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/app_toast.dart';
import 'package:bingio/shared/button_plain_text.dart';
import 'package:bingio/shared/button_solid.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  final Function() toggleLoginAndRegisterPages;
  
  const LoginPage({
    super.key,
    required this.toggleLoginAndRegisterPages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode loginButtonFocusNode = FocusNode();
  final FocusNode googleSignInButtonFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String titleText = 'Welcome to ${STRINGS.appName}';
  final double verticalPadding = 10.0;

  DateTime lastBackPressTime = DateTime.now();

  void logUserIn() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
      await AuthService().logInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    on AuthServiceException catch (e) {
      showAppError(e.message, toastLength: Toast.LENGTH_LONG);
    }
    on Exception catch (e) {
      showAppError('Exception: ${e.toString()}', toastLength: Toast.LENGTH_LONG);
    }
    finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void googleSignIn() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
      await AuthService().logInWithGoogle();
    }
    on AuthServiceException catch (e) {
      showAppError(e.message, toastLength: Toast.LENGTH_LONG);
    }
    on Exception catch (e) {
      showAppError('Exception: ${e.toString()}', toastLength: Toast.LENGTH_LONG);
    }
    finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    loginButtonFocusNode.dispose();
    googleSignInButtonFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                GradientText(text: titleText),

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
                        hintText:  'Email',
                        autoFocus: true,
                        controller: emailController,
                        focusNode: emailFocusNode,
                        nextFocus: passwordFocusNode,
                        paddingHorizontal: verticalPadding * 4,
                        paddingVertical: verticalPadding,
                      ),

                      InputField(
                        hintText:  'Password',
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        nextFocus: loginButtonFocusNode,
                        paddingHorizontal: verticalPadding * 4,
                        paddingVertical: verticalPadding,
                        obscureText: true,
                      ),

                      SolidButton(
                        text: 'Log In',
                        focusNode: loginButtonFocusNode,
                        onPressed: logUserIn,
                        paddingVertical: verticalPadding,
                      ),

                      Text('-- OR --'),

                      SolidButton(
                        text: 'Sign In with Google',
                        image: 'assets/images/google_favicon.png',
                        width: 250,
                        focusNode: googleSignInButtonFocusNode,
                        onPressed: googleSignIn,
                        paddingVertical: verticalPadding,
                      ),

                      PlainTextButton(
                        text: 'Sign Up with Email',
                        onPressed: widget.toggleLoginAndRegisterPages,
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
