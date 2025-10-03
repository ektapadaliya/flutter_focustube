import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class HomeVC extends StatefulWidget {
  static const id = "/";
  const HomeVC({super.key});

  @override
  State<HomeVC> createState() => _HomeVCState();
}

class _HomeVCState extends State<HomeVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    AppTitle(
                      title: "Bookmarked video",
                      onViewMore: () {
                        videos.go(context, extra: "Bookmarked");
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => BookmarkVideoTile(),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 15),
                        itemCount: 5,
                      ),
                    ),
                    SizedBox(height: 30),
                    AppTitle(
                      title: "Popular Videos",
                      onViewMore: () {
                        videos.go(context, extra: "Popular");
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => PopularVideoTile(),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 15),
                        itemCount: 5,
                      ),
                    ),
                    SizedBox(height: 30),
                    AppTitle(
                      title: "Recommended videos",
                      onViewMore: () {
                        videos.go(context, extra: "Recommended");
                      },
                    ),
                    SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => VideoTile(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: 10,
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

  _buildHeader() {
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning!",
            style: AppTextStyle.body18(color: AppColor.gray),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(AppImage.appIconLight),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Leslie Alexander",
                  style: AppTextStyle.title28(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.more_vert),
            ],
          ),
        ],
      ),
    );
  }
}

class PopularVideoTile extends StatelessWidget {
  const PopularVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                top: 5,
                right: 5,
                child: Icon(
                  Icons.bookmark_outline_rounded,
                  size: 30,
                  color: AppColor.white,
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
    );
  }
}

class BookmarkVideoTile extends StatelessWidget {
  const BookmarkVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
                Icon(
                  Icons.bookmark_outline_rounded,
                  size: 30,
                  color: AppColor.white,
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
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
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
    return SizedBox(
      height: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              NetworkImageClass(
                height: 110,
                width: 168,
                borderRadius: BorderRadius.circular(12),
                placeHolder: AppImage.videoPlaceHolder,
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Icon(
                  Icons.bookmark_outline_rounded,
                  size: 30,
                  color: AppColor.white,
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
    );
  }
}
