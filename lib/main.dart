import 'package:bingio/pages/login_page.dart';
import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      debugShowCheckedModeBanner: false,
      title: STRINGS.appName,
      home: const Scaffold(
        backgroundColor: APPCOLORS.background,
        body: SafeArea(
          child: LoginPage(),
        ),
      ),
    );
  }
}
