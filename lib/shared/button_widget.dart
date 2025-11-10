import 'dart:async';
import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetButton extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onPressSelect;
  final VoidCallback? onLongPressSelect;
  final VoidCallback? onPressBack;
  final VoidCallback? onLongPressBack;
  final VoidCallback? onPressMenu;
  final VoidCallback? onLongPressMenu;
  final ValueChanged<bool>? onHover;
  final Duration longPressThreshold;
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
  final AlignmentGeometry alignment;

  const WidgetButton({
    super.key,
    this.child,
    this.onPressSelect,
    this.onLongPressSelect,
    this.onPressBack,
    this.onLongPressBack,
    this.onPressMenu,
    this.onLongPressMenu,
    this.onHover,
    this.longPressThreshold = Durations.long2,
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
    this.alignment = AlignmentGeometry.center,
  });

  @override
  State<WidgetButton> createState() => _WidgetButtonState();
}

class _WidgetButtonState extends State<WidgetButton> {
  static const List<LogicalKeyboardKey> _dPadKeys = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowDown];
  late FocusNode _focusNode;
  final FocusNode _btnNode = FocusNode();
  Timer? _longPressTimer;
  bool _ownFocusNode = false;
  // _keyDownReceived: Prevents accidental ShortPresses when KeyDown is popping a page and KeyUp happens on previous page
  bool _keyDownReceived = false;
  bool _longPressTriggered = false;

  KeyEventResult _handleKeyEvents(FocusNode node, KeyEvent event, Duration longPressThreshold) {
    final LogicalKeyboardKey key = event.logicalKey;
    //print('WidgetButton: ${DateTime.now().millisecond}, Event: ${event is KeyUpEvent ? 'Up' : event is KeyDownEvent ? 'Down' : 'Repeat'}, Key: ${key.keyLabel}, longPressTriggered: $_longPressTriggered');

    // D-Pad movement is handled automatically on KeyDown so prevent from firing again on KeyUp
    if (event is KeyUpEvent &&  _dPadKeys.contains(key)) {
      // return _handleDPadNavigation(key);
      return KeyEventResult.handled;
    }
    // Don't allow propagation of keys when held down unless its the D-Pad
    else if (event is KeyRepeatEvent && _dPadKeys.contains(key) == false) {
      return KeyEventResult.handled;
    }
    // Ignore the keydown but start timer incase we have a Long Press
    else if (event is KeyDownEvent && _dPadKeys.contains(key) == false) {
      _keyDownReceived = true;
      _longPressTriggered = false;

      _longPressTimer?.cancel();
      _longPressTimer = Timer(longPressThreshold, (){
        _longPressTriggered = true;
        _handleLongPress(key);
      });

      // Ignoring here allows the child ElevatedButton to make it's press sound
      return KeyEventResult.ignored;
    }
    // Short/Long Press were handled, clean up the timer.
    else if (event is KeyUpEvent && _keyDownReceived) {
      _longPressTimer?.cancel();
      _longPressTimer = null;
      _keyDownReceived = false;

      if (!_longPressTriggered) {
        return _handleShortPress(key);
      }

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /*
  KeyEventResult _handleDPadNavigation(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowLeft) {
      FocusScope.of(context).focusInDirection(TraversalDirection.left);
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.arrowRight) {
      FocusScope.of(context).focusInDirection(TraversalDirection.right);
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.arrowUp) {
      FocusScope.of(context).focusInDirection(TraversalDirection.up);
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.arrowDown) {
      FocusScope.of(context).focusInDirection(TraversalDirection.down);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
  */

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
    return KeyEventResult.ignored;
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
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _btnNode.dispose();
    _focusNode.removeListener(_handleFocusChange);
    if (_ownFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.margin),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autoFocus,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _btnNode.requestFocus();
            }
            if (widget.onHover != null) {
              widget.onHover!(hasFocus);
            }
          },
          onKeyEvent: (FocusNode node, KeyEvent event) {
            return _handleKeyEvents(node, event, widget.longPressThreshold);
          },
          child: ElevatedButton(
            focusNode: _btnNode,
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              alignment: widget.alignment,
              padding:EdgeInsets.all(2),
              backgroundColor: _focusNode.hasFocus ? widget.backgroundColorFocused : widget.backgroundColor,
              foregroundColor: widget.backgroundColorFocused,
              side: BorderSide(
                color: _focusNode.hasFocus ? widget.borderColorFocused : widget.borderColor,
                width: widget.borderWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}