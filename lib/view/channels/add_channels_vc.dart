import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

import '../../const/app_color.dart';
import '../../const/app_image.dart';

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
              onValueSelect: (value) {
                selectValue = value;
                setState(() {});
              },
              hintTextColor: AppColor.gray,
              prefixIcon: Image.asset(AppImage.search, height: 35),
              suffixIcon: selectValue == null
                  ? null
                  : Icon(Icons.close, size: 22, color: AppColor.gray),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ChannelTile(),
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
