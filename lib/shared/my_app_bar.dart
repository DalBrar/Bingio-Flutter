import 'package:bingio/shared/button_logout_icon.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GradientText(text: AppStrings.appName),
      centerTitle: true,
      backgroundColor: AppColors.background,
      leading: LogoutButtonIcon(),
    );
  }
}
