
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
  final bool autoFocus;

  const ProfileCard({
    super.key,
    required this.name,
    required this.bgColor,
    required this.picColor,
    required this.picNum,
    required this.onPressed,
    this.onLongPressed,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: WidgetButton(
        autoFocus: autoFocus,
        onPressed: onPressed,
        onLongPressed: onLongPressed,
        child: SizedBox(
          width: 80,
          height: 122,
          child: Column(
            children: [
              SizedBox(height: 10),
              ProfilePic(
                bgColor: bgColor,
                picColor: picColor,
                picNum: picNum,
              ),
              ResponsiveText(
                text: name,
                style: AppStyles.title2Text,
              )
            ],
          ),
        ),
      ),
    );
  }
}
