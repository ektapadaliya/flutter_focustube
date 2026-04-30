import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/channels_vc_controller.dart';
import 'package:focus_tube_flutter/view/channels/youtube_channel_vc.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:get/get.dart';
import '../channels/channel_list_vc.dart';

class ChannelsVC extends StatefulWidget {
  static const id = "/channels";
  const ChannelsVC({super.key});

  @override
  State<ChannelsVC> createState() => _ChannelsVCState();
}

class _ChannelsVCState extends State<ChannelsVC> {
  late ChannelsVCController channelVController;
  @override
  void initState() {
    channelVController = controller<ChannelsVCController>();
    channelVController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: channelVController,
      builder: (channelVController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(top: 15),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  controller: channelVController.categoryScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) => Container(
                    key: channelVController.categoryKeys[index],
                    child: _CategoryTile(
                      index: index,
                      controller: channelVController,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: channelVController.pageController,
                children: [
                  YoutubeChannelVC(isFirstTime: true),
                  ChannelListVC(tag: "channel-me"),
                  ChannelListVC(tag: "channel-curated"),
                  ChannelListVC(tag: "channel-scholartube"),
                  Container(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final int index;
  final ChannelsVCController controller;

  const _CategoryTile({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedIndex == index;

    return AppInkWell(
      onTap: () => controller.jumpToPage(index),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? AppColor.primary : null,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.gray,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _label(index),
          style: AppTextStyle.title16(
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ),
      ),
    );
  }

  String _label(int index) => switch (index) {
    0 => "Select Channels",
    1 => "My Channels",
    2 => "Curated Channels",
    3 => "Scholar Tube",
    4 => "KidsTube",
    _ => "",
  };
}
