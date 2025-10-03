import 'package:flutter/cupertino.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ChannelsVC extends StatefulWidget {
  static const id = "/channles";
  const ChannelsVC({super.key});

  @override
  State<ChannelsVC> createState() => _ChannelsVCState();
}

class _ChannelsVCState extends State<ChannelsVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(body: Container());
  }
}
