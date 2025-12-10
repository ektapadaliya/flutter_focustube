import 'package:flutter/material.dart';

class AppColor {
  static const gray = Color(0xFF808080);
  static const red = Colors.red;
  static const green = Colors.green;
  static const white = Color(0xFFFFFFFF);
  static const primary = Color(0xFF000000);
  static const lightGray = Color(0xFFB3B3B3);
  static const lightYellow = Color(0xFFFDE7C7);
  static const profileBackground = Color(0xFF2E2E2E);
  static final tileBackground = white.opacityToAlpha(.3);
  static final borderColor = lightGray.opacityToAlpha(.7);
}

extension ColorExtension on Color {
  Color opacityToAlpha(double opacity) {
    return withAlpha((opacity * 255).toInt());
  }
}
