
import 'package:bingio/shared/button_widget.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/profile_pic.dart';
import 'package:bingio/shared/responsive_text.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final int bgColor;
  final int picColor;
  final int picNum;
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;
  final FocusNode? focusNode;
  final bool autoFocus;
  final double width;
  final double height;

  const ProfileCard({
    super.key,
    required this.name,
    required this.bgColor,
    required this.picColor,
    required this.picNum,
    required this.onPressed,
    this.onLongPressed,
    this.focusNode,
    this.autoFocus = false,
    this.width = 125,
    this.height = 125,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: WidgetButton(
        focusNode: focusNode,
        autoFocus: autoFocus,
        onPressSelect: onPressed,
        onLongPressSelect: onLongPressed,
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(height: 5),
            ProfilePic(
              bgColor: bgColor,
              picColor: picColor,
              picNum: picNum,
              width: width * 0.65,
              height: height * 0.65,
            ),
            ResponsiveText(
              text: name,
              style: AppStyles.title2Text,
              width: width * 0.9,
              height: height * 0.25,
            )
          ],
        ),
      ),
    );
  }
}
