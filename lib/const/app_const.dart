import 'package:flutter/material.dart';

class AppConst {
  //App Name
  static const appName = "FocusTube";

  //App Bundle ID
  static const appBundleId = "com.heelfinfotech.focustube";

  /// The maximum width (in logical pixels) that form fields and buttons
  /// should occupy when the device is in landscape orientation.
  static const double kMaxLandscapeFormWidth = 700.0;

  /// Returns `true` if the device is currently in landscape orientation.
  static bool isLandscape(context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Returns `true` if the device is currently in portrait orientation.
  static bool isPortrait(context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Returns the maximum available width for the current screen.
  static double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns the maximum available height for the current screen.
  static double maxHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

enum ContentType { termsAndConditions, privacyPolicy }

extension ContentTypeExtension on ContentType {
  String get slug {
    switch (this) {
      case ContentType.termsAndConditions:
        return "terms-of-use";
      case ContentType.privacyPolicy:
        return "privacy-policy";
    }
  }
}
