import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '../const/app_color.dart';
import '../const/app_text_style.dart';

class AppTostMessage {
  static Flushbar _flushbar({
    bool isError = false,
    required String message,
    String? title,
    double durationInSec = 3,
  }) => Flushbar(
    icon: isError
        ? const Icon(Icons.info_outline, size: 28, color: AppColor.white)
        : null,
    borderColor: isError ? Colors.red : Colors.green,
    borderRadius: BorderRadius.circular(8),
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    duration: Duration(milliseconds: (durationInSec * 1000).toInt()),
    backgroundColor: isError ? AppColor.red : AppColor.green,
    titleText: title != null
        ? Text(title, style: AppTextStyle.title16(color: AppColor.white))
        : null,
    messageText: Text(
      message,
      style: AppTextStyle.body14(color: AppColor.white),
    ),
  );

  static snackBarMessage(
    context, {
    bool isError = false,
    String? title,
    required String? message,
    double durationInSec = 3,
  }) async {
    if (!context.mounted) return;
    if (message != null && message.trim().isNotEmpty) {
      await _flushbar(
        isError: isError,
        message: message,
        durationInSec: durationInSec,
        title: title,
      ).show(context);
    }
  }
}
