import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/view/channels/youtube_channel_vc.dart';

import '../channels/channel_list_vc.dart';

class ChannelsVC extends StatefulWidget {
  static const id = "/channels";
  const ChannelsVC({super.key});

  @override
  State<ChannelsVC> createState() => _ChannelsVCState();
}

class _ChannelsVCState extends State<ChannelsVC> {
  TextEditingController searchController = TextEditingController();
  String? searchValue;
  PageController pageController = PageController(initialPage: 0);
  //List<GlobalKey> itemKeys = [];
  @override
  void initState() {
    //itemKeys = List.generate(5, (index) => GlobalKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => buildCategoryTile(index),
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemCount: 4,
            ),
          ),
        ),
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              YoutubeChannelVC(),
              ChannelListVC(tag: "channel-me"),
              ChannelListVC(tag: "channel-curated"),
              ChannelListVC(tag: "channel-scholartube"),
            ],
          ),
        ),
      ],
    );
  }

  buildCategoryTile(int index) {
    bool isSelected = pageController.hasClients
        ? (pageController.page?.round() ?? 0) == index
        : false;
    return InkWell(
      onTap: () {
        pageController.jumpToPage(index);
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
/* 
Hi, may I please take leave? I need to accompany my father for his MRI and thyroid report, Sorry for urgent request hope you understand.
 */