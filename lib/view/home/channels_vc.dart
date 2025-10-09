import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
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
    return Container(); /* Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),

      child: Column(
        children: [
          AppTextFormField(
            hintText: "Search here...",

            prefixIcon: Image.asset(AppImage.search, height: 35),
            radius: 6,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => ChannelTile(value: index),
              separatorBuilder: (context, index) => ChannelDivider(),
              itemCount: 10,
            ),
          ),
        ],
      ),
    ); */
  }
}
