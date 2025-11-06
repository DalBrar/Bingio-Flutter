import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that manages focus for its child and allows for keyboard navigation. Must be wrapped by a 'FocusScope' to work.
class TVFocus extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode childFocus;
  final Widget child;
  final bool autofocus;

  const TVFocus({
    super.key,
    required this.focusNode,
    required this.childFocus,
    required this.child,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          childFocus.requestFocus();
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            FocusScope.of(context).focusInDirection(TraversalDirection.left);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            FocusScope.of(context).focusInDirection(TraversalDirection.right);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            FocusScope.of(context).focusInDirection(TraversalDirection.up);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            FocusScope.of(context).focusInDirection(TraversalDirection.down);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.gameButtonA) {
            FocusScope.of(context).unfocus();
            Future.delayed(Duration(milliseconds: 1), () {
              childFocus.requestFocus();
            });
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}