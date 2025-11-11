import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:flutter/material.dart';

class PlainTextBtn extends StatefulWidget {
  final bool autoFocus;
  final String text;
  final VoidCallback onPressed;

  const PlainTextBtn({
    super.key,
    this.autoFocus = false,
    required this.text,
    required this.onPressed,
  });

  @override
  State<PlainTextBtn> createState() => _PlainTextBtnState();
}

class _PlainTextBtnState extends State<PlainTextBtn> {
  static const int duration = 300;
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return FocusWrap(
      autoFocus: widget.autoFocus,
      backgroundColorFocused: AppColors.active,
      animationDurationMilliseconds: duration,
      onPressSelect: widget.onPressed,
      onFocusChanged: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: duration),
        style: TextStyle(
          color: _hasFocus ? AppColors.background : AppColors.link,
          fontFamily: 'Futura'
        ),
        child: Text(widget.text),
      ),
    );
  }
}