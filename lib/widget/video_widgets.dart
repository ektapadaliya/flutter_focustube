import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required this.title, this.onViewMore});
  final String title;
  final void Function()? onViewMore;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(title, style: AppTextStyle.title20())),
        if (onViewMore != null)
          InkWell(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            onTap: onViewMore,
            child: Text(
              "View More",
              style: AppTextStyle.title16(color: AppColor.gray),
            ),
          ),
      ],
    );
  }
}

class PopularVideoTile extends StatelessWidget {
  const PopularVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        videoDetail.go(context);
      },
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: SizedBox(
        width: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NetworkImageClass(
                  height: 160,
                  borderRadius: BorderRadius.circular(12),
                  placeHolder: AppImage.videoPlaceHolder,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: SvgPicture.asset(
                    AppImage.bookmarkIcon,
                    height: 25,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white.opacityToAlpha(.3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_outlined, color: AppColor.white),
                        SizedBox(width: 5),
                        Text(
                          "1423 Views",
                          style: AppTextStyle.body12(color: AppColor.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Text(
                "Chemical Bonding: Crash Course",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.title18().copyWith(height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectVideoTile extends StatelessWidget {
  const SubjectVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        videoDetail.go(context);
      },
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: SizedBox(
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                NetworkImageClass(
                  height: 110,
                  borderRadius: BorderRadius.circular(12),
                  placeHolder: AppImage.videoPlaceHolder,
                ),
                PlayPauseIcon(),
                Positioned(
                  top: 8,
                  right: 8,
                  child: SvgPicture.asset(
                    AppImage.bookmarkIcon,
                    height: 25,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Chemical Bonding: Crash Course",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.title18().copyWith(height: 1.2),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility_outlined, color: AppColor.gray),
                SizedBox(width: 5),
                Text(
                  "1423 Views",
                  style: AppTextStyle.body12(color: AppColor.gray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkVideoTile extends StatelessWidget {
  const BookmarkVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        videoDetail.go(context);
      },
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 390, maxHeight: 230),
        child: Stack(
          children: [
            NetworkImageClass(
              height: 230,
              borderRadius: BorderRadius.circular(12),
              placeHolder: AppImage.videoPlaceHolder,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppImage.bookmarkIcon,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          "Chemical Bonding: Crash Course",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.title18(
                            color: AppColor.white,
                          ).copyWith(height: 1.2),
                        ),
                      ),
                      SizedBox(width: 5),
                      PlayPauseIcon(),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(12),
                      backgroundColor: AppColor.white.opacityToAlpha(.3),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.white),
                      value: .5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoTile extends StatefulWidget {
  const VideoTile({super.key});

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        videoDetail.go(context);
      },
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: SizedBox(
        height: 110,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                NetworkImageClass(
                  height: 110,
                  width: 168,
                  borderRadius: BorderRadius.circular(12),
                  placeHolder: AppImage.videoPlaceHolder,
                ),
                PlayPauseIcon(),
                Positioned(
                  top: 8,
                  left: 8,
                  child: SvgPicture.asset(
                    AppImage.bookmarkIcon,
                    height: 25,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chemical Bonding: Crash Course",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.title18().copyWith(height: 1.2),
                    ),
                    Expanded(child: Container()),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_outlined, color: AppColor.gray),
                        SizedBox(width: 5),
                        Text(
                          "1423 Views",
                          style: AppTextStyle.body12(color: AppColor.gray),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayPauseIcon extends StatefulWidget {
  const PlayPauseIcon({super.key});

  @override
  State<PlayPauseIcon> createState() => _PlayPauseIconState();
}

class _PlayPauseIconState extends State<PlayPauseIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(color: AppColor.white, shape: BoxShape.circle),
      child: Center(
        child: Icon(Icons.play_arrow_rounded, color: AppColor.primary),
      ),
    );
  }
}
