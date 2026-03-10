import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/view/channels/youtube_channel_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class AddChannelsVC extends StatefulWidget {
  static const id = "/select-channels";
  const AddChannelsVC({super.key});
  @override
  State<AddChannelsVC> createState() => _AddChannelsVCState();
}

class _AddChannelsVCState extends State<AddChannelsVC> {
  String? selectValue;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Select Channels"),
      body: YoutubeChannelVC(isFirstTime: true),
    );
  }
}
