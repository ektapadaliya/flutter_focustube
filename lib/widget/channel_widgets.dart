import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class ChannelTile extends StatelessWidget {
  const ChannelTile({
    super.key,
    required this.value,
    this.showAddChannels = true,
  });

  final int value;
  final bool showAddChannels;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        channelDetail.go(context, id: value.toString());
      },
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: AppColor.lightGray),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Channel ${value + 1}", style: AppTextStyle.title20()),
                Wrap(
                  spacing: 15,
                  children: [
                    infoIconText(AppImage.userIcon, "124k Followers"),
                    infoIconText(AppImage.videoIcon, "120 Videos"),
                  ],
                ),
              ],
            ),
          ),
          if (showAddChannels)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AppButton(
                label: "Add channel",
                radius: 7,
                alignment: null,
                backgroundColor: AppColor.primary,
                height: 32,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

Widget infoIconText(String iconPath, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SvgPicture.asset(iconPath, height: 12),
      const SizedBox(width: 3),
      Text(text, style: AppTextStyle.body12(color: AppColor.gray)),
    ],
  );
}

class ChannelDivider extends StatelessWidget {
  const ChannelDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .8,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primary.opacityToAlpha(0),
            AppColor.primary.opacityToAlpha(.4),
            AppColor.primary.opacityToAlpha(.5),
            AppColor.primary.opacityToAlpha(.4),
            AppColor.primary.opacityToAlpha(0),
          ],
          stops: [0, .2, .5, .8, 1],
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
