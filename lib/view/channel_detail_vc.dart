import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
              height: 120,
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
                          Text(
                            "Science Academy",
                            style: AppTextStyle.title24(),
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
                Tab(text: "Playlist"),
                Tab(text: "About"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [ChannelVideos(), ChannelPlaylist(), ChannelAbout()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelPlaylist extends StatelessWidget {
  const ChannelPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("Playlist", style: AppTextStyle.title20()),
          SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                PlayListTile(value: index, onTap: (_) {}),
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemCount: 10,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ChannelVideos extends StatelessWidget {
  const ChannelVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("Videos", style: AppTextStyle.title20()),
          SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => VideoTile(),
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemCount: 10,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ChannelAbout extends StatelessWidget {
  const ChannelAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("About", style: AppTextStyle.title20()),
          SizedBox(height: 5),
          Text(
            """Lorem ipsum dolor sit amet consectetur. Ph asellus nisl mi feugiat orci nunc mauris nulla varius. Facilisis porttitor diam risus eu erat tempor. Viverra phasellus quis dignissim adipiscing aenean arcu. Non aliquam laoreet viverra nulla ornare. Et eget laoreet ultrices eu risus.

Lorem ipsum dolor sit amet consectetur. Ph asellus nisl mi feugiat orci nunc mauris nulla varius. Facilisis porttitor diam risus eu erat tempor. Viverra phasellus quis dignissim adipiscing aenean arcu. Non aliquam laoreet viverra nulla ornare. Et eget laoreet ultrices eu risus.

Lorem ipsum dolor sit amet consectetur. Ph asellus nisl mi feugiat orci nunc mauris nulla varius. Facilisis porttitor diam risus eu erat tempor. Viverra phasellus quis dignissim adipiscing aenean arcu. Non aliquam laoreet viverra nulla ornare. Et eget laoreet ultrices eu risus.
""",
            style: AppTextStyle.body18(color: AppColor.gray),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
