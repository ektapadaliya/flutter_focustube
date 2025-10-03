import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';

import 'package:get/get.dart';

Future<dynamic> generalDialog(
  BuildContext context, {
  required String title,
  required String message,
  bool barrierDismissible = true,
  String submitText = "Ok",
  String cancelText = "Cancel",
  void Function()? onSubmit,
  void Function()? onCancel,
}) async {
  return await showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      Text titleText = Text(title, style: AppTextStyle.title20());
      Text messageText = Text(message);
      List<Widget> actions = [
        if (onSubmit != null)
          TextButton(
            onPressed: onSubmit,
            child: Text(submitText, style: AppTextStyle.body16()),
          ),
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel();
            } else {
              Get.back();
            }
          },
          child: Text(cancelText, style: AppTextStyle.body16()),
        ),
      ];
      dialog() {
        if (kIsWeb) {
          return AlertDialog(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            title: titleText,
            content: messageText,
            actions: actions,
          );
        } else if (io.Platform.isIOS) {
          return CupertinoAlertDialog(
            title: titleText,
            content: messageText,
            actions: actions,
          );
        } else {
          return AlertDialog(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            title: titleText,
            content: messageText,
            actions: actions,
          );
        }
      }

      return PopScope(canPop: barrierDismissible, child: dialog());
    },
  );
}

Future<T?> generalBottomSheet<T>(
  context, {
  required Widget child,
  bool isScrollControlled = true,
  Color backgroundColor = AppColor.white,
  BoxConstraints? constraints,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    constraints: constraints,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return child;
    },
  );
}
