import 'package:bingio/shared/functions.dart';
import 'package:flutter/material.dart';

class OnBackCatcher extends StatefulWidget {
  final Widget child;
  /// Popup message text. Set as `null` (or unset) to skip popup message.
  final String? text;
  /// Default behaviour is `Navigator.pop(context)`.
  /// To exit app use: `SystemNavigator.pop()`.
  final Function(BuildContext ctx)? onBack;
  /// Called when App is resumed from a paused state. Can use to `setState((){})` to force a rebuild.
  final VoidCallback? onAppResume;

  const OnBackCatcher({
    super.key,
    required this.child,
    this.text,
    this.onBack,
    this.onAppResume,
  });

  @override
  State<OnBackCatcher> createState() => _OnBackCatcherState();
}

class _OnBackCatcherState extends State<OnBackCatcher> with WidgetsBindingObserver {
  DateTime lastBackPressTime = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // send out a signal to any Widgets that wanna listen and update their state
      if (widget.onAppResume != null) widget.onAppResume!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        DateTime now = DateTime.now();
        if (widget.text != null && (now.difference(lastBackPressTime) > const Duration(seconds: 2))) {
          lastBackPressTime = now;
          showAppToast(widget.text!);
          return;
        }
        if (widget.onBack == null) {
          Navigator.pop(context);
        } else {
          widget.onBack!(context);
        }
      },
      child: widget.child,
    );
  }
}