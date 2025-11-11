
import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/btn_icon.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hideLogoutButton;
  final bool showGoBackButton;

  const MyAppBar({
    super.key,
    this.hideLogoutButton = false,
    this.showGoBackButton = false,
  });
  
  void logOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {}
    await AuthService().logOut();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: [
                  if (hideLogoutButton == false) IconBtn(
                    text: AppStrings.logOut,
                    icon: Icons.logout,
                    onPressed: logOut,
                    flipX: true,
                    offsetX: -1,
                  ),
                  if (showGoBackButton) IconBtn(
                    text: AppStrings.goBack,
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: GradientText(text: AppStrings.appName),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
