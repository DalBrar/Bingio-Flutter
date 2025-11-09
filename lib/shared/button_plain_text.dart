import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class PlainTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double paddingHorizontal;
  final double paddingVertical;
  final double height;

  const PlainTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.paddingHorizontal = 5,
    this.paddingVertical = 0,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: AppStyles.plainTextButtonStyle,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}