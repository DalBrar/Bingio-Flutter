import 'package:bingio/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitOnBackCatcher extends StatefulWidget {
  final Widget child;

  const ExitOnBackCatcher({
    super.key,
    required this.child,
  });

  @override
  State<ExitOnBackCatcher> createState() => _ExitOnBackCatcherState();
}

class _ExitOnBackCatcherState extends State<ExitOnBackCatcher> {
  DateTime lastBackPressTime = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        DateTime now = DateTime.now();
        if (now.difference(lastBackPressTime) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          showAppToast('Press back again to exit');
          return;
        }
        SystemNavigator.pop();
      },
      child: widget.child,
    );
  }
}