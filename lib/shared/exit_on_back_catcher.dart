import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnBackCatcher extends StatefulWidget {
  final Widget child;
  final String? text;
  final VoidCallback? onBack;
  final bool skipNotification;

  const OnBackCatcher({
    super.key,
    required this.child,
    this.text,
    this.onBack,
    this.skipNotification = false,
  });

  @override
  State<OnBackCatcher> createState() => _OnBackCatcherState();
}

class _OnBackCatcherState extends State<OnBackCatcher> {
  DateTime lastBackPressTime = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        DateTime now = DateTime.now();
        if (widget.skipNotification == false &&  (now.difference(lastBackPressTime) > const Duration(seconds: 2))) {
          lastBackPressTime = now;
          showAppToast((widget.text == null) ? AppStrings.pressBackAgainToExit : widget.text!);
          return;
        }
        if (widget.onBack == null) {
          SystemNavigator.pop();
        } else {
          widget.onBack!();
        }
      },
      child: widget.child,
    );
  }
}