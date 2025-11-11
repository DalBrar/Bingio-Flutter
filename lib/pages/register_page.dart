import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/btn_input_field.dart';
import 'package:bingio/shared/btn_plain_text.dart';
import 'package:bingio/shared/btn_solid.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

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

  final double verticalPadding = 10.0;

  void signUp() async {
    try {
      loadingSpinnerShow(context);
      if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
        await AuthService().signUpWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());
        widget.toggleLoginAndRegisterPages();
      }
      else {
        showAppError(AppStrings.errPasswordMismatch);
      }
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
                  AppStrings.pleaseRegisterToContinue,
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
                        onSubmitted: (val) { confirmPasswordFocusNode.requestFocus(); },
                      ),

                      InputFieldBtn(
                        hintText:  AppStrings.hintPasswordConfirm,
                        width: 800,
                        height: 55,
                        margin: EdgeInsetsGeometry.all(verticalPadding),
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: Icon(Icons.password, color: Colors.transparent),
                        textController: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        obscureText: true,
                        onSubmitted: (val) { signUpButtonFocusNode.requestFocus(); },
                      ),

                      SolidBtn(
                        text: AppStrings.signUp,
                        margin: EdgeInsetsGeometry.all(verticalPadding),
                        onPressed: signUp,
                        focusNode: signUpButtonFocusNode,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
                            style: AppStyles.regularText,
                          ),
                          PlainTextBtn(
                            text: AppStrings.logIn,
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
