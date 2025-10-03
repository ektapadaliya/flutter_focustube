import 'package:flutter/cupertino.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class PlaylistVC extends StatefulWidget {
  static const id = "/playlist";
  const PlaylistVC({super.key});

  @override
  State<PlaylistVC> createState() => _PlaylistVCState();
}

class _PlaylistVCState extends State<PlaylistVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(body: Container());
  }
}
