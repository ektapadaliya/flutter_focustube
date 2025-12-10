import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';

class AppTextStyle {
  static const String fontFamily = "Rubik";

  static TextStyle _h({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.primary,
    );
  }

  static TextStyle title40({Color? color}) => _h(fontSize: 40, color: color);
  static TextStyle title36({Color? color}) => _h(fontSize: 36, color: color);
  static TextStyle title28({Color? color}) => _h(fontSize: 28, color: color);
  static TextStyle title24({Color? color}) => _h(fontSize: 24, color: color);
  static TextStyle title20({Color? color}) => _h(fontSize: 20, color: color);
  static TextStyle title18({Color? color}) => _h(fontSize: 18, color: color);
  static TextStyle title16({Color? color}) => _h(fontSize: 16, color: color);

  static TextStyle _b({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.primary,
    );
  }

  static TextStyle body22({Color? color}) => _b(fontSize: 22, color: color);
  static TextStyle body20({Color? color}) => _b(fontSize: 20, color: color);
  static TextStyle body18({Color? color}) => _b(fontSize: 18, color: color);
  static TextStyle body16({Color? color}) => _b(fontSize: 16, color: color);
  static TextStyle body14({Color? color}) => _b(fontSize: 14, color: color);
  static TextStyle body12({Color? color}) => _b(fontSize: 12, color: color);
  static TextStyle body11({Color? color}) => _b(fontSize: 11, color: color);
}
