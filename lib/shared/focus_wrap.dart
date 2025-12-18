import 'dart:async';

import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusWrap extends StatefulWidget {
  final FocusNode? focusNode;
  final bool autoFocus;
  final VoidCallback? onPressSelect;
  final VoidCallback? onPressBack;
  final VoidCallback? onPressMenu;
  final VoidCallback? onLongPressSelect;
  final VoidCallback? onLongPressBack;
  final VoidCallback? onLongPressMenu;
  final ValueChanged<bool>? onFocusChanged;
  final Duration longPressThreshold;
  final bool preventBtnPressesNotExplicitlyHandled;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color backgroundColorFocused;
  final Color borderColor;
  final Color borderColorFocused;
  final double borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final bool disableAnimation;
  final int animationDurationMilliseconds;
  final Curve animationCurve;
  final Widget? child;
  
  const FocusWrap({
    super.key,
    this.focusNode,
    this.autoFocus = false,
    this.onPressSelect,
    this.onPressBack,
    this.onPressMenu,
    this.onLongPressSelect,
    this.onLongPressBack,
    this.onLongPressMenu,
    this.onFocusChanged,
    this.longPressThreshold = Durations.long2,
    this.preventBtnPressesNotExplicitlyHandled = false,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.alignment = AlignmentGeometry.center,
    this.width,
    this.height,
    this.backgroundColor = AppColors.background,
    this.backgroundColorFocused = AppColors.background,
    this.borderColor = AppColors.background,
    this.borderColorFocused = AppColors.active,
    this.borderWidth = 3,
    this.borderRadius,
    this.disableAnimation = false,
    this.animationDurationMilliseconds = 250,
    this.animationCurve = Curves.easeInToLinear,
    this.child,
  });

  @override
  State<FocusWrap> createState() => _FocusWrapState();
}

class _FocusWrapState extends State<FocusWrap> {
  static const List<LogicalKeyboardKey> _dPadKeys = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowDown];
  late FocusNode _focusNode;
  bool _ownFocusNode = false;
  bool _keyDownReceived = false;
  bool _longPressTriggered = false;
  Timer? _longPressTimer;

  KeyEventResult handleKeyEvents(FocusNode node, KeyEvent event) {
    final LogicalKeyboardKey key = event.logicalKey;

    // Prevent repeated presses other than DPad
    if (event is KeyRepeatEvent && _dPadKeys.contains(key) == false) {
      return KeyEventResult.handled;
    }
    // Start testing for Short Press or Long Press
    else if (event is KeyDownEvent && _dPadKeys.contains(key) == false) {
      _keyDownReceived = true;
      _longPressTriggered = false;

      _longPressTimer?.cancel();
      _longPressTimer = Timer(widget.longPressThreshold, ()
      {
        _longPressTriggered = true;
        _handleLongPress(key);
      });
    }
    else if (event is KeyUpEvent && _keyDownReceived == true) {
      _longPressTimer?.cancel();
      _longPressTimer = null;
      _keyDownReceived = false;

      if (_longPressTriggered) {
        return KeyEventResult.handled;
      }
      return _handleShortPress(key);
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _handleShortPress(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.select || key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.gameButtonA) {
      if (widget.onPressSelect != null) {
        widget.onPressSelect!();
        return KeyEventResult.handled;
      }
    }
    else if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.gameButtonB) {
      if (widget.onPressBack != null) {
        widget.onPressBack!();
        return KeyEventResult.handled;
      }
    }
    else if (key == LogicalKeyboardKey.contextMenu || key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.gameButtonSelect) {
      if (widget.onPressMenu != null) {
        widget.onPressMenu!();
        return KeyEventResult.handled;
      }
    }
    return widget.preventBtnPressesNotExplicitlyHandled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  KeyEventResult _handleLongPress(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.select || key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.gameButtonA) {
      if (widget.onLongPressSelect != null) {
        widget.onLongPressSelect!();
        return KeyEventResult.handled;
      }
    }
    else if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.gameButtonB) {
      if (widget.onLongPressBack != null) {
        widget.onLongPressBack!();
        return KeyEventResult.handled;
      }
    }
    else if (key == LogicalKeyboardKey.contextMenu || key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.gameButtonSelect) {
      if (widget.onLongPressMenu != null) {
        widget.onLongPressMenu!();
        return KeyEventResult.handled;
      }
    }
    return widget.preventBtnPressesNotExplicitlyHandled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  void _handleFocusChange() {
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _ownFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownFocusNode) _focusNode.dispose();
    _longPressTimer?.cancel();
    _longPressTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = widget.disableAnimation
      ? Container(
          alignment: widget.alignment,
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: _focusNode.hasFocus ? widget.backgroundColorFocused : widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            border: (widget.borderWidth <= 0) ? null : BoxBorder.all(
              color: _focusNode.hasFocus ? widget.borderColorFocused : widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          ),
        )
      : AnimatedSize(
        duration: Duration(milliseconds: widget.animationDurationMilliseconds),
        curve: widget.animationCurve,
        child: AnimatedContainer(
            alignment: widget.alignment,
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              color: _focusNode.hasFocus ? widget.backgroundColorFocused : widget.backgroundColor,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              border: (widget.borderWidth <= 0) ? null : BoxBorder.all(
                color: _focusNode.hasFocus ? widget.borderColorFocused : widget.borderColor,
                width: widget.borderWidth,
              ),
            ),
            duration: Duration(milliseconds: widget.animationDurationMilliseconds),
            curve: widget.animationCurve,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
      );
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Focus(
          focusNode: _focusNode,
          autofocus: widget.autoFocus,
          onFocusChange: (hasFocus) {
            if (widget.onFocusChanged != null) {
              widget.onFocusChanged!(hasFocus);
            }
          },
          onKeyEvent: handleKeyEvents,
          child: GestureDetector(
            onTap: () {
              if (widget.onPressSelect != null) widget.onPressSelect!();
            },
            onLongPress: () {
              if (widget.onLongPressSelect != null) widget.onLongPressSelect!();
            },
            child: MouseRegion(
              onEnter: (_) => { _focusNode.requestFocus() },
              onExit: (_) => { _focusNode.unfocus() },
              child: container,
            ),
          ),
        ),
      ],
    );
  }
}