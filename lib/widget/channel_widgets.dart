import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';

class ChannelTile extends StatelessWidget {
  const ChannelTile({
    super.key,
    this.title = "Channel",
    this.channelId = "",
    this.channelImage = "",
    this.showAddChannels = true,
    this.onAddChannel,
  });

  final String title;
  final String channelId;
  final String channelImage;
  final bool showAddChannels;
  final void Function()? onAddChannel;
  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: () {
        if (showAddChannels) {
          youtubeChannelDetail.go(context);
        } else {
          channelDetail.go(context, id: channelId);
        }
      },

      child: Row(
        children: [
          NetworkImageClass(
            height: 56,
            width: 56,
            image: channelImage,
            shape: BoxShape.circle,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstLatterCapitalize(title.trim()),
                  style: AppTextStyle.title20(),
                ),

                // Wrap(
                //   spacing: 15,
                //   children: [
                //     infoIconText(AppImage.userIcon, "124k Followers"),
                //     infoIconText(AppImage.videoIcon, "120 Videos"),
                //   ],
                // ),
              ],
            ),
          ),
          // if (showAddChannels)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 10),
          //     child: AppButton(
          //       label: "Add channel",
          //       onTap: onAddChannel,
          //       radius: 7,
          //       alignment: null,
          //       backgroundColor: AppColor.primary,
          //       height: 32,
          //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          //       fontSize: 12,
          //     ),
          //   ),
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

class ChannelAbout extends StatelessWidget {
  const ChannelAbout({super.key, required this.description});

  final String description;

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
          Text(description, style: AppTextStyle.body18(color: AppColor.gray)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
