import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/my_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = AuthService().getCurrentUser();

  void logOut() async {
    await AuthService().logOut();
  }

  @override
  Widget build(BuildContext context) {
    loadingSpinnerHide();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MyAppBar(),
      body: Center(child: Text('Logged in as ${user?.email}'),)
    );
  }
}
