import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';

import '../../const/app_image.dart';
import '../../widget/app_text_form_field.dart';

class ChannelsVC extends StatefulWidget {
  static const id = "/channels";
  const ChannelsVC({super.key});

  @override
  State<ChannelsVC> createState() => _ChannelsVCState();
}

class _ChannelsVCState extends State<ChannelsVC> {
  String? selectValue;
  int selectedIndex = 0;

  //List<GlobalKey> itemKeys = [];
  @override
  void initState() {
    //itemKeys = List.generate(5, (index) => GlobalKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => buildCategoryTile(index),
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemCount: 4,
            ),
          ),
          if (selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: AutoCompleteField(
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
            )
          else
            SizedBox(height: 20),

          Text(_channelsResults(selectedIndex), style: AppTextStyle.title20()),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => ChannelTile(
                value: index,
                showAddChannels: selectedIndex != 0 && selectedIndex != 1,
              ),
              separatorBuilder: (context, index) => ChannelDivider(),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  buildCategoryTile(int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        selectedIndex = index;
        // Scrollable.ensureVisible(
        //   itemKeys[index].currentContext!,
        //   duration: const Duration(milliseconds: 300),
        //   alignment: .5, // 0.0 = left, 1.0 = right, 0.5 = center
        //   curve: Curves.easeInOut,
        // );
        setState(() {});
      },
      child: Container(
        //key: itemKeys[index],
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? AppColor.primary : null,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.gray,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _channelsType(index),
          style: AppTextStyle.title16(
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ),
      ),
    );
  }

  _channelsType(int index) {
    return switch (index) {
      // 0 => "Channels",
      0 => "Select Channels",
      1 => "My Channels",
      2 => "Curated Channels",
      3 => "Scholar Tube",
      //4 => "Select Channels",
      _ => "",
    };
  }

  _channelsResults(int index) {
    return switch (index) {
      //0 => "Channels",
      0 => "Search Results",
      1 => "My Channels",
      2 => "Curated Channels",
      3 => "Scholar Tube",
      // 4 => "Search Results",
      _ => "",
    };
  }
}
