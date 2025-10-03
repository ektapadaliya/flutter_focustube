import 'package:flutter/cupertino.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class SettingsVC extends StatefulWidget {
  static const id = "/settings";
  const SettingsVC({super.key});

  @override
  State<SettingsVC> createState() => _SettingsVCState();
}

class _SettingsVCState extends State<SettingsVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(body: Container());
  }
}
