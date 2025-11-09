import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/button_plain_text.dart';
import 'package:bingio/shared/button_solid.dart';
import 'package:bingio/shared/exit_on_back_catcher.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/input_field.dart';
import 'package:flutter/material.dart';

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

  final String titleText = 'Welcome to ${AppStrings.appName}';
  final double verticalPadding = 10.0;

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
      await AuthService().logInWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());
    }
    on AuthServiceException catch (e) {
      showAppError(e.message);
    }
    on Exception catch (e) {
      showAppError('Exception: ${e.toString()}');
    }
    finally {
      Navigator.pop(context);
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
      showAppError(e.message);
    }
    on Exception catch (e) {
      showAppError('Exception: ${e.toString()}');
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
    return ExitOnBackCatcher(
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                  style: AppStyles.regularText,
                ),
                
                FocusScope(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputField(
                      hintText:  'Email',
                      textInputType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                      prefixIcon: Icon(Icons.mail),
                      suffixIcon: Icon(Icons.mail, color: Colors.transparent),
                      autoFocus: true,
                      controller: emailController,
                      focusNode: emailFocusNode,
                      nextFocus: passwordFocusNode,
                      paddingHorizontal: verticalPadding * 4,
                      paddingVertical: verticalPadding,
                    ),
                
                    InputField(
                      hintText:  'Password',
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: Icon(Icons.password, color: Colors.transparent),
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
