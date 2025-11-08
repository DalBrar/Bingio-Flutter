import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class WidgetButton extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;
  final ValueChanged<bool>? onHover;
  final FocusNode? focusNode;
  final bool autoFocus;
  final double? width;
  final double? height;
  final double margin;
  final Color backgroundColor;
  final Color backgroundColorFocused;
  final Color borderColor;
  final Color borderColorFocused;
  final double borderWidth;
  final double borderRadius;
  final Widget child;

  const WidgetButton({
    super.key,
    required this.onPressed,
    this.onLongPressed,
    this.onHover,
    this.focusNode,
    this.autoFocus = false,
    this.width,
    this.height,
    this.margin = 0,
    this.backgroundColor = AppColors.background,
    this.backgroundColorFocused = AppColors.background,
    this.borderColor = AppColors.background,
    this.borderColorFocused = AppColors.active,
    this.borderWidth = 2,
    this.borderRadius = 20,
    required this.child,
  });

  @override
  State<WidgetButton> createState() => _WidgetButtonState();
}

class _WidgetButtonState extends State<WidgetButton> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.margin),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPressed,
          onHover: widget.onHover,
          onFocusChange: (hasFocus) {
            setState(() {
              _hasFocus = hasFocus;
            });
            if (widget.onHover != null) {
              widget.onHover!(hasFocus);
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: _hasFocus ? widget.backgroundColorFocused : widget.backgroundColor,
            foregroundColor: Colors.transparent,
            side: BorderSide(
              color: _hasFocus ? widget.borderColorFocused : widget.borderColor,
              width: widget.borderWidth,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}