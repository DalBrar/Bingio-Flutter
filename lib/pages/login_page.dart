import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/btn_input_field.dart';
import 'package:bingio/shared/btn_plain_text.dart';
import 'package:bingio/shared/btn_solid.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/exit_on_back_catcher.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/constants.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final double verticalPadding = 10.0;

  void logUserIn() async {
    try {
      loadingSpinnerShow(context);
      await AuthService().logInWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());
    }
    on AuthServiceException catch (e) {
      showAppError(e.message);
    }
    on Exception catch (e) {
      showAppError('Exception: ${e.toString()}');
    }
    finally {
      loadingSpinnerHide();
    }
  }

  void googleSignIn() async {
    try {
      loadingSpinnerShow(context);
      await AuthService().logInWithGoogle();
    }
    on AuthServiceException catch (e) {
      showAppError(e.message);
    }
    on Exception catch (e) {
      showAppError('Exception: ${e.toString()}');
    }
    finally {
      loadingSpinnerHide();
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    loginButtonFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackCatcher(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                GradientText(text: AppStrings.welcome),

                SizedBox(height: 40),
                Text(
                  AppStrings.pleaseLoginToContinue,
                  style: AppStyles.largeText,
                ),
                
                FocusScope(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputFieldBtn(
                      hintText:  AppStrings.hintEmail,
                      width: 800,
                      height: 55,
                      margin: EdgeInsetsGeometry.all(verticalPadding),
                      textInputType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                      prefixIcon: Icon(Icons.mail),
                      suffixIcon: Icon(Icons.mail, color: Colors.transparent),
                      autoFocus: true,
                      textController: emailController,
                      focusNode: emailFocusNode,
                      onSubmitted: (val) { passwordFocusNode.requestFocus(); },
                    ),
                
                    InputFieldBtn(
                      hintText:  AppStrings.hintPassword,
                      width: 800,
                      height: 55,
                      margin: EdgeInsetsGeometry.all(verticalPadding),
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: Icon(Icons.password, color: Colors.transparent),
                      textController: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: true,
                      onSubmitted: (val) { loginButtonFocusNode.requestFocus(); },
                    ),
                
                    SolidBtn(
                      text: AppStrings.emailLogIn,
                      margin: EdgeInsetsGeometry.all(verticalPadding),
                      onPressed: logUserIn,
                      focusNode: loginButtonFocusNode,
                    ),
                
                    Text(AppStrings.orDashed),
                
                    SolidBtn(
                      text: AppStrings.signInWithGoogle,
                      image: 'assets/images/google_favicon.png',
                      margin: EdgeInsetsGeometry.all(verticalPadding),
                      onPressed: googleSignIn,
                    ),
                
                    PlainTextBtn(
                      text: AppStrings.signUpWithEmail,
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
