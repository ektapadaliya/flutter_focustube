import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';

PreferredSize sizeZeroAppBar(context, {Color? color, Brightness? brightness}) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, 0),
    child: AppBar(
      backgroundColor: color ?? Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:
            brightness ??
            (io.Platform.isAndroid ? Brightness.dark : Brightness.light),
        statusBarBrightness: brightness ?? Brightness.light,
        statusBarColor: color ?? Colors.transparent,
        systemNavigationBarColor: AppColor.white,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      scrolledUnderElevation: 0.0,
      elevation: 0,
    ),
  );
}

AppBar customAppBar(
  context, {
  dynamic title,
  List<Widget>? actions,
  Widget? leading,
  double? leadingWidth,
  bool automaticallyImplyLeading = true,
  bool centerTitle = true,
  Widget? flexibleSpace,
  SystemUiOverlayStyle? style,
}) {
  return AppBar(
    systemOverlayStyle:
        style ??
        SystemUiOverlayStyle(
          statusBarIconBrightness: io.Platform.isAndroid
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColor.white,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
        ),
    centerTitle: centerTitle,
    backgroundColor: Colors.transparent,
    title: (title is Widget)
        ? title
        : Text(title ?? "", style: AppTextStyle.title20()),
    scrolledUnderElevation: 0.0,
    elevation: 0,
    leadingWidth: leadingWidth,
    leading: leading,
    bottom: flexibleSpace != null
        ? PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 10),
            child: flexibleSpace,
          )
        : null,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
    iconTheme: const IconThemeData(color: AppColor.primary),
  );
}
