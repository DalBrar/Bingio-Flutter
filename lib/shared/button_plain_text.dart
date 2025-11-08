import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class PlainTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double paddingHorizontal;
  final double paddingVertical;

  const PlainTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: AppStyles.plainTextButtonStyle,
      child: Text(
        text,
      ),
    );
  }
}