import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldBtn extends StatefulWidget {
  final FocusNode? focusNode;
  final bool autoFocus;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? textController;
  final TextStyle style;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool obscureText;
  final TextInputType textInputType;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const InputFieldBtn({
    super.key,
    this.focusNode,
    this.autoFocus = false,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.textController,
    this.style = AppStyles.mediumText,
    this.hintText,
    this.hintStyle = AppStyles.hintText,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.autofillHints,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<InputFieldBtn> createState() => _InputFieldBtnState();
}

class _InputFieldBtnState extends State<InputFieldBtn> {
  final FocusNode _textFocusNode = FocusNode();
  late FocusNode _mainFocusNode;
  bool _ownFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _mainFocusNode = FocusNode();
      _ownFocusNode = true;
    } else {
      _mainFocusNode = widget.focusNode!;
    }

    _textFocusNode.onKeyEvent = (node, event) {
      final key = event.logicalKey;

      if (event is KeyDownEvent &&
          (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.arrowDown)
      ) {
        _textFocusNode.unfocus();
        _mainFocusNode.requestFocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    if (_ownFocusNode) _mainFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusWrap(
      focusNode: widget.focusNode,
      autoFocus: widget.autoFocus,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding ?? EdgeInsets.all(0),
      borderColor: AppColors.hint,
      onPressSelect: () { 
        _textFocusNode.requestFocus();
      },
      child: TextFormField(
          focusNode: _textFocusNode,
          controller: widget.textController,
          obscureText: widget.obscureText,
          keyboardType: widget.textInputType,
          autofillHints: widget.autofillHints,
          maxLength: widget.maxLength,
          buildCounter:(context, {required currentLength, required isFocused, required maxLength}) => null,
          style: widget.style,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted ?? (val) { _mainFocusNode.requestFocus(); },
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsetsGeometry.all(0),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
      )
    );
  }
}