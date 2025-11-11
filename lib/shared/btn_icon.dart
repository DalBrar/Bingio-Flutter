import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:flutter/material.dart';

class IconBtn extends StatefulWidget {
  final FocusNode? focusNode;
  final IconData icon;
  final Function() onPressed;
  final double offsetX;
  final double offsetY;
  final bool flipX;
  final bool flipY;
  final String? text;
  final Color color;
  final double? fixedWidth;
  final double? fixedHeight;
  final double? iconSize;
  final double? textSize;

  const IconBtn({
    super.key,
    this.focusNode,
    required this.icon,
    required this.onPressed,
    this.offsetX = 0,
    this.offsetY = 0,
    this.flipX = false,
    this.flipY = false,
    this.text,
    this.color = AppColors.text,
    this.fixedWidth,
    this.fixedHeight,
    this.iconSize = 25,
    this.textSize = 18,
  });

  @override
  State<IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<IconBtn> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusWrap(
      focusNode: widget.focusNode,
      width: widget.fixedWidth,
      height: widget.fixedHeight,
      borderRadius: BorderRadius.circular(50),
      padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 2),
      animationDurationMilliseconds: 250,
      animationCurve: Curves.easeInOut,
      onPressSelect: widget.onPressed,
      onFocusChanged: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.flip(
            flipX: widget.flipX,
            flipY: widget.flipY,
            origin: Offset(widget.offsetX, widget.offsetY),
            child: Icon(
              widget.icon,
              color: widget.color,
              size: widget.iconSize,
            ),
          ),
          if (widget.text != null && widget.text!.isNotEmpty && _isFocused) Text(
            ' ${widget.text!}',
            style: TextStyle(
              color: widget.color,
              fontSize: widget.textSize,
              fontFamily: 'Audiowide',
            ),
          ),
        ],
      ),
    );
  }
}