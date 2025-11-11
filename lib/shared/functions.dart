import 'package:bingio/shared/btn_plain_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void closeAllDialogs(BuildContext context) {
  Navigator.of(context).popUntil((route) => route is PageRoute);
}

void showAppToast(String message, {Toast toastLength = Toast.LENGTH_SHORT, bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    timeInSecForIosWeb: (toastLength == Toast.LENGTH_SHORT) ? 2 : 6,
    backgroundColor: Colors.black,
    textColor: isError ? AppColors.error : Colors.white,
    fontSize: 16.0,
  );
  return;
}

void showAppError(String message, {Toast toastLength = Toast.LENGTH_LONG}) {
  showAppToast(message, toastLength: toastLength, isError: true);
}

void showYesNoDialog({
  required BuildContext context,
  String? title,
  Widget? body,
  String yesText = AppStrings.btnYes,
  String noText = AppStrings.btnNo,
  required VoidCallback onYes,
  VoidCallback? onNo,
}) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: AppColors.shadow,
        title: Text(title ?? AppStrings.dialogConfirm),
        content: body ?? Text(AppStrings.dialogAreYouSure),
        actions: <Widget>[
          PlainTextBtn(
            autoFocus: true,
            text: noText,
            onPressed: () { Navigator.of(ctx).pop(false); },
          ),
          PlainTextBtn(
            text: yesText,
            onPressed: () { Navigator.of(ctx).pop(true); },
          ),
        ]
      );
    }
  ).then((result) {
    if (result == true) {
      onYes();
    } else if (onNo != null) {
      onNo();
    }
  });
}

BuildContext? spinnerContext;
void loadingSpinnerHide() {
  if (spinnerContext != null) {
    Future.delayed(Duration(milliseconds: 1), (){
      Navigator.of(spinnerContext!).pop();
      spinnerContext = null;
    });
  }
}

void loadingSpinnerShow(BuildContext context) {
  if (spinnerContext == null) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        spinnerContext = dialogContext;
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}
