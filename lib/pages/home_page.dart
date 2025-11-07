import 'package:bingio/services/auth_service.dart';
import 'package:bingio/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  void logOut() async {
    await AuthService().logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APPCOLORS.background,
      appBar: AppBar(
        actions: [IconButton(onPressed: logOut, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Text('Logged in as ${user?.email}'),)
    );
  }
}
