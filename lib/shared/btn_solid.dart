import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:flutter/material.dart';

class SolidBtn extends StatelessWidget {
  final FocusNode? focusNode;
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final String? image;
  final bool isDisabled;

  const SolidBtn({
    super.key,
    this.focusNode,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 45,
    this.margin = EdgeInsetsGeometry.zero,
    this.padding = EdgeInsetsGeometry.zero,
    this.image,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return FocusWrap(
      focusNode: focusNode,
      margin: margin,
      padding: (padding == EdgeInsetsGeometry.zero) ? EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10) : padding,
      width: width,
      height: height,
      borderWidth: 0,
      borderRadius: BorderRadius.circular(8),
      backgroundColor: AppColors.link,
      backgroundColorFocused: isDisabled ? AppColors.shadow : AppColors.active,
      animationDurationMilliseconds: 300,
      onPressSelect: isDisabled ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Image.asset(
              image!,
              fit: BoxFit.contain,
            ),
          if (image != null && text.isNotEmpty) Text('  ', style: AppStyles.solidButtonText,),
          Text(
            text,
            style: isDisabled ? AppStyles.solidButtonDisabledText : AppStyles.solidButtonText,
          ),
        ],
      ),
    );
  }

}