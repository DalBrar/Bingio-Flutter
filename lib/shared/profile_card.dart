import 'package:bingio/shared/btn_icon.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/profile_pic.dart';
import 'package:bingio/shared/responsive_text.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_updateFocus);
    editFocus.addListener(_updateFocus);
    delFocus.addListener(_updateFocus);
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
      policy: ProfileCardTraversalPolicy(allowedNode: widget.focusNode),
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
                    child: IconBtn(
                      focusNode: editFocus,
                      text: 'Edit',
                      icon: Icons.edit_outlined,
                      color: AppColors.hint,
                      iconSize: 15,
                      textSize: 14,
                      fixedHeight: 30,
                      onPressed: (){ showAppToast('Edit not implemented yet'); },
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(2),
                    child: IconBtn(
                      focusNode: delFocus,
                      text: 'Delete',
                      icon: Icons.delete_forever_outlined,
                      color: delFocus.hasFocus ? AppColors.error : AppColors.hint,
                      iconSize: 15,
                      textSize: 14,
                      fixedHeight: 30,
                      onPressed: (){ showAppToast('Delete not implemented yet'); },
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

class ProfileCardTraversalPolicy extends WidgetOrderTraversalPolicy {
  final FocusNode? allowedNode;

  ProfileCardTraversalPolicy({this.allowedNode});

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    if ((direction == TraversalDirection.left || direction == TraversalDirection.right)
        && currentNode != allowedNode) {
          // Block left/right traversal for nodes other than the allowed one
          return false;
        }
    return super.inDirection(currentNode, direction);
  }
}
