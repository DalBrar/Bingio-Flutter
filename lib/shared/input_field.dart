import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/input_navigation.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final bool autoFocus;
  final FocusNode? nextFocus;
  final TextInputType textInputType;
  final Iterable<String>? autofillHints;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double paddingHorizontal;
  final double paddingVertical;
  final TextStyle style;
  final bool obscureText;
  final Function(String)? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    this.autoFocus = false,
    this.nextFocus,
    this.textInputType = TextInputType.text,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
    this.style = AppStyles.largeText,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}
  
class _InputFieldState extends State<InputField> {
  final FocusNode _textFocusNode = FocusNode();

  @override
  void dispose() {
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: EdgeInsets.symmetric(horizontal: widget.paddingHorizontal, vertical: widget.paddingVertical),
      child: InputNavigation(
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        childFocus: _textFocusNode,
        child: TextFormField(
          controller: widget.controller,
          focusNode: _textFocusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.textInputType,
          autofillHints: widget.autofillHints,
          onChanged: widget.onChanged,
          onFieldSubmitted: (value) {
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppStyles.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.link),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.active),
            ),
          ),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: widget.style,
        ),
      ),
    );
  }
}
