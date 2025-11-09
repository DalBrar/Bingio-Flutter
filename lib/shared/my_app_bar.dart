
import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/my_app_bar_button.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hideLogoutButton;
  final bool showBackButton;

  const MyAppBar({
    super.key,
    this.hideLogoutButton = false,
    this.showBackButton = false,
  });
  
  void logOut() async {
    await AuthService().logOut();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GradientText(text: AppStrings.appName),
      centerTitle: true,
      backgroundColor: AppColors.background,
      leading: Row(
        children: [
          if (hideLogoutButton == false) MyAppBarButton(
            onPressed: logOut,
            icon: Icon(Icons.logout),
            flipX: true,
            offsetX: -1,
          ),
          if (showBackButton) MyAppBarButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded),
          ),
        ],
      ),
    );
  }
}
