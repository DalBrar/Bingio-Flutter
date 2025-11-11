import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/my_app_bar_button.dart';
import 'package:bingio/shared/profile_pic.dart';
import 'package:bingio/shared/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileCard extends StatefulWidget {
  final String name;
  final int bgColor;
  final int picColor;
  final int picNum;
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;
  final FocusNode? focusNode;
  final bool autoFocus;
  final double width;
  final double height;
  final bool showOptions;

  const ProfileCard({
    super.key,
    required this.name,
    required this.bgColor,
    required this.picColor,
    required this.picNum,
    required this.onPressed,
    this.onLongPressed,
    this.focusNode,
    this.autoFocus = false,
    this.width = 125,
    this.height = 130,
    this.showOptions = false,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final FocusNode editFocus = FocusNode();
  final FocusNode delFocus = FocusNode();

  bool get _isAnyFocused {
    return (
      widget.focusNode?.hasFocus == true ||
      editFocus.hasFocus == true ||
      delFocus.hasFocus == true
    );
  }

  void _updateFocus() {
    setState(() {});
  }

  void preventLeftRight(FocusNode node) {
    node.onKeyEvent = (node, event) {
      if (event is KeyDownEvent && (
        event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight
      )) {
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_updateFocus);
    editFocus.addListener(_updateFocus);
    delFocus.addListener(_updateFocus);
    preventLeftRight(editFocus);
    preventLeftRight(delFocus);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_updateFocus);
    editFocus.dispose();
    delFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: null,
      child: Column(
        children: [
          FocusTraversalOrder(
            order: NumericFocusOrder(0),
            child: FocusWrap(
              focusNode: widget.focusNode,
              autoFocus: widget.autoFocus,
              onPressSelect: widget.onPressed,
              onLongPressSelect: widget.onLongPressed,
              width: widget.width,
              height: widget.height,
              margin: EdgeInsetsGeometry.all(8),
              padding: EdgeInsetsGeometry.all(3),
              animationDurationMilliseconds: 400,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  ProfilePic(
                    bgColor: widget.bgColor,
                    picColor: widget.picColor,
                    picNum: widget.picNum,
                    width: widget.width * 0.65,
                    height: widget.width * 0.65,
                  ),
                  ResponsiveText(
                    text: widget.name,
                    style: AppStyles.title2Text,
                    width: widget.width * 0.85,
                    height: widget.width * 0.25,
                  )
                ],
              ),
            ),
          ),
    
          if (widget.showOptions)
            AnimatedOpacity(
              opacity: _isAnyFocused ? 1 : 0,
              duration: Duration(milliseconds: 750),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1),
                    child: Focus(
                      focusNode: editFocus,
                      child: MyAppBarButton(
                        onPressed: (){ showAppToast('Edit not implemented yet'); },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: editFocus.hasFocus ? AppColors.shadow : AppColors.hint,
                        )
                      ),
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(2),
                    child: Focus(
                      focusNode: delFocus,
                      child: MyAppBarButton(
                        onPressed: (){ showAppToast('Delete not implemented yet'); },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: delFocus.hasFocus ? const Color.fromARGB(255, 255, 0, 0) : AppColors.hint,
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
