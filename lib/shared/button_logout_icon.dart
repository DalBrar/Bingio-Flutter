import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class LogoutButtonIcon extends StatelessWidget {
  const LogoutButtonIcon({super.key});
  
  void logOut() async {
    await AuthService().logOut();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusColor: AppColors.active.withAlpha(125),
      hoverColor: AppColors.active.withAlpha(125),
      onPressed: logOut,
      icon: Transform.flip(
        flipX: true,
        origin: Offset(-1, 0),
        child: Icon(Icons.logout),
      ),
    );
  }
}