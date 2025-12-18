import 'package:bingio/shared/btn_plain_text.dart';
import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

void closeAllDialogs(BuildContext context) {
  Navigator.of(context).popUntil((route) => route is PageRoute);
}

void showAppToast(String message, {int toastLength = 3, bool isError = false}) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: toastLength),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            color: isError ? AppColors.error : Colors.white,
            thickness: 2,          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isError ? AppColors.error : Colors.white,
              fontSize: 20.0,
            ),
          ),
          Divider(
            color: isError ? AppColors.error : Colors.white,
            thickness: 2,
          ),
        ],
      ),
    )
  );
  return;
}

void showAppError(String message, {int toastLength = 6}) {
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
  Future.delayed(Duration(milliseconds: 50), (){
    if (spinnerContext != null) {
      Navigator.of(spinnerContext!).pop();
      spinnerContext = null;
    }
  });
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
