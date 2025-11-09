import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class MyAppBarButton extends StatelessWidget {
  final Function() onPressed;
  final Widget icon;
  final double offsetX;
  final double offsetY;
  final bool flipX;
  final bool flipY;

  const MyAppBarButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.offsetX = 0,
    this.offsetY = 0,
    this.flipX = false,
    this.flipY = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusColor: AppColors.active.withAlpha(125),
      hoverColor: AppColors.active.withAlpha(125),
      onPressed: onPressed,
      icon: Transform.flip(
        flipX: flipX,
        flipY: flipY,
        origin: Offset(offsetX, offsetY),
        child: icon,
      ),
    );
  }
}