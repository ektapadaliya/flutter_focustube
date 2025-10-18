import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class AddChannelsVC extends StatefulWidget {
  static const id = "/add-channels";
  const AddChannelsVC({super.key});

  @override
  State<AddChannelsVC> createState() => _AddChannelsVCState();
}

class _AddChannelsVCState extends State<AddChannelsVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Add Channels"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ).copyWith(bottom: 15),
        child: Column(
          children: [
            AutoCompleteField(
              radius: 6,
              hintText: "Search here...",
              suggestions: [
                "Channels 1",
                "Channels 2",
                "Channels 3",
                "Channels 4",
                "Channels 5",
              ],
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
      ),
    );
  }
}
