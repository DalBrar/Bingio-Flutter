import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/app_toast.dart';
import 'package:bingio/shared/button_plain_text.dart';
import 'package:bingio/shared/button_solid.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/input_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  final Function() toggleLoginAndRegisterPages;
  
  const RegisterPage({
    super.key,
    required this.toggleLoginAndRegisterPages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode signUpButtonFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final String titleText = 'Welcome to ${STRINGS.appName}';
  final double verticalPadding = 10.0;

  void signUp() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
      if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
        await AuthService().signUpWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());
        widget.toggleLoginAndRegisterPages();
      }
      else {
        showAppError('Passwords do not match');
      }
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
    confirmPasswordFocusNode.dispose();
    signUpButtonFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        widget.toggleLoginAndRegisterPages();
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
                  'Please register to continue.',
                  style: APPSTYLES.regularText,
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
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        nextFocus: confirmPasswordFocusNode,
                        paddingHorizontal: verticalPadding * 4,
                        paddingVertical: verticalPadding,
                        obscureText: true,
                      ),

                      InputField(
                        hintText:  'Confirm Password',
                        prefixIcon: Icon(Icons.password),
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        nextFocus: signUpButtonFocusNode,
                        paddingHorizontal: verticalPadding * 4,
                        paddingVertical: verticalPadding,
                        obscureText: true,
                      ),

                      SolidButton(
                        text: 'Sign Up',
                        focusNode: signUpButtonFocusNode,
                        onPressed: signUp,
                        paddingVertical: verticalPadding,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: APPSTYLES.regularText,
                          ),
                          PlainTextButton(
                            text: 'Log In',
                            onPressed: widget.toggleLoginAndRegisterPages,
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
