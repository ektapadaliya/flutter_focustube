import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';

class AppTextStyle {
  static const String fontFamily = "Rubik";

  static TextStyle onBoardingTitle = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: AppColor.black,
  );
  static TextStyle onBoardingBody = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColor.gray,
  );
  static TextStyle appBarTitle = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColor.black,
  );
  static TextStyle title40 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColor.black,
  );
  static TextStyle title28 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColor.black,
  );
  static TextStyle title20 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColor.black,
  );
  static TextStyle body18 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.black,
  );
  static TextStyle body16 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.black,
  );
  static TextStyle buttonTextStyleBold({Color? color, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w500,
        color: color ?? AppColor.white,
      );

  static TextStyle buttonTextStyleNormal({Color? color, double? fontSize}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w400,
        color: color ?? AppColor.white,
      );
}
