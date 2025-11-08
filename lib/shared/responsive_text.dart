import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final TextStyle style;

  const ResponsiveText({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.style = AppStyles.regularText
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
