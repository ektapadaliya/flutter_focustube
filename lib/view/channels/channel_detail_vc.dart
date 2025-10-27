import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ChannelDetailVC extends StatefulWidget {
  static const id = "/detail/:id";
  const ChannelDetailVC({super.key, required this.channelId});
  final String channelId;
  @override
  State<ChannelDetailVC> createState() => _ChannelDetailVCState();
}

class _ChannelDetailVCState extends State<ChannelDetailVC>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Channel details"),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              height: 140,
              padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
              child: Row(
                children: [
                  CircleAvatar(radius: 60, backgroundColor: AppColor.lightGray),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "Science Academy, Science Academy",
                            maxFontSize: 24,
                            minFontSize: 18,
                            style: AppTextStyle.title24(),
                            maxLines: 2,
                          ),
                          Text(
                            "124k Followers",
                            style: AppTextStyle.body16(color: AppColor.gray),
                          ),
                          Expanded(child: Container()),
                          AppButton(
                            label: "Add channel",
                            radius: 7,
                            alignment: null,
                            backgroundColor: AppColor.primary,
                            height: 32,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColor.primary,
              dividerColor: AppColor.gray,
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              labelStyle: AppTextStyle.title18(),
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.gray,
              tabs: [
                Tab(text: "Videos"),
                // Tab(text: "Playlist"),
                Tab(text: "About"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ChannelVideos(),
                  /* ChannelPlaylist(), */ ChannelAbout(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
