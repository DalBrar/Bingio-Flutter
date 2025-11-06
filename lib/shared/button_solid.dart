import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final double width;
  final double height;
  final double paddingHorizontal;
  final double paddingVertical;

  const SolidButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.focusNode,
    this.width = 200,
    this.height = 50,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          focusNode: focusNode,
          onPressed: onPressed,
          style: APPSTYLES.solidButtonStyle,
          child: Text(
            text,
            style: APPSTYLES.solidButtonText,
          ),
        ),
      ),
    );
  }
}