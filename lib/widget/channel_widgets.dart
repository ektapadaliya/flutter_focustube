import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';

class ChannelTile extends StatelessWidget {
  const ChannelTile({super.key, required this.value});
  final int value;
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
                Text("Channle ${value + 1}", style: AppTextStyle.title20()),
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
          SizedBox(width: 10),
          AppButton(
            label: "Add channel",
            radius: 7,
            alignment: null,
            backgroundColor: AppColor.primary,
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            fontSize: 12,
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
