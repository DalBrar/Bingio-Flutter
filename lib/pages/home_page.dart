import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: logOut, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Text('Logged in as ${user?.email}'),)
    );
  }
}
