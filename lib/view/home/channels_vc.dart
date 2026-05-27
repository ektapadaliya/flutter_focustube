import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/channels_vc_controller.dart';
import 'package:focus_tube_flutter/view/auth/is_auth.dart';
import 'package:focus_tube_flutter/view/channels/youtube_channel_vc.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../channels/channel_grouplist_vc.dart';
import '../channels/channel_list_vc.dart';
import '../channels/group_channel_list_vc.dart';

class ChannelsVC extends StatefulWidget {
  static const id = "/channels";
  const ChannelsVC({super.key});

  @override
  State<ChannelsVC> createState() => _ChannelsVCState();
}

class _ChannelsVCState extends State<ChannelsVC> {
  @override
  void initState() {
    channelTabScrollController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: channelTabScrollController,
      builder: (channelTabScrollController) {
        if (!channelTabScrollController.pageController.hasClients) Container();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(top: 15),
              child: SizedBox(
                height: 40,
                child: ScrollablePositionedList.separated(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemScrollController:
                      channelTabScrollController.categoryScrollController,
                  itemPositionsListener:
                      channelTabScrollController.itemPositionsListener,
                  itemCount: channelTabScrollController.categoryCount,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) => _CategoryTile(
                    index: index,
                    controller: channelTabScrollController,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GetBuilder(
                init: controller<UserController>(),
                builder: (userController) {
                  return PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: channelTabScrollController.pageController,
                    children: [
                      YoutubeChannelVC(isFirstTime: true),

                      IsAuth(
                        message: "To view your channels, please log in.",
                        child: GroupChannelListVC(tag: 'channel-groups'),
                      ),

                      ChannelListVC(tag: "channel-curated"),
                      ChannelListVC(tag: "channel-scholartube"),
                      ChannelListVC(tag: "channel-kidstube"),
                    ],
                  );
                },
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
  final TabScrollController controller;

  const _CategoryTile({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
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
    });
  }

  String _label(int index) => switch (index) {
    0 => "Select Channels",
    1 => "My Channels",
    2 => "Curated Channels",
    3 => "Scholar Tube",
    4 => "KidsWatch",
    _ => "",
  };
}
