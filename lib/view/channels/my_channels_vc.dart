import 'package:flutter/material.dart';

import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class MyChannelsVC extends StatefulWidget {
  static const id = "/my-channels";
  const MyChannelsVC({super.key});

  @override
  State<MyChannelsVC> createState() => _MyChannelsVCState();
}

class _MyChannelsVCState extends State<MyChannelsVC> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "My Channels"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),

        child: ListView.separated(
          itemBuilder: (context, index) => ChannelTile(),
          separatorBuilder: (context, index) => ChannelDivider(),
          itemCount: 10,
        ),
      ),
    );
  }
}
