import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/my_app_bar.dart';
import 'package:bingio/shared/on_back_catcher.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String profileId;
  final String profileName;

  const HomePage({
    super.key,
    required this.profileId,
    required this.profileName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return OnBackCatcher(
      onBack: (ctx) { FocusScope.of(context).unfocus(); },
      onAppResume: () => setState(() {}),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(),
        body: Center(child: Text('Logged in as ${widget.profileName}, last updated ${DateTime.now()}'),)
      ),
    );
  }
}
