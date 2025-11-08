import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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