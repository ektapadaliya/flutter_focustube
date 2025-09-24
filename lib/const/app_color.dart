import 'package:flutter/material.dart';

class AppColor {
  static const gray = Color(0xFF808080);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static const lightOrange = Color(0xFFFDE7C7);
  static final textFieldBackground = white.opacityToAlpha(.3);
  static final textFieldBorder = Color(0xFFB3B3B3).opacityToAlpha(.7);
}

extension ColorExtension on Color {
  Color opacityToAlpha(double opacity) {
    return withAlpha((opacity * 255).toInt());
  }
}
