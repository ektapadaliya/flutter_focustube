import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class VideoDetailVC extends StatefulWidget {
  static const id = "/video/:id";
  const VideoDetailVC({super.key});

  @override
  State<VideoDetailVC> createState() => _VideoDetailVCState();
}

class _VideoDetailVCState extends State<VideoDetailVC> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context).aspectRatio > 1
        ? Size(
            MediaQuery.sizeOf(context).height,
            MediaQuery.sizeOf(context).width / 3,
          )
        : Size(
            MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height / 3,
          );
    return ScreenBackground(
      appBar: customAppBar(
        context,
        title: "Lesson",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: SvgPicture.asset(AppImage.noteIcon, height: 20),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    NetworkImageClass(
                      height: size.height,
                      width: size.width,
                      placeHolder: AppImage.videoPlaceHolder,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    PlayPauseIcon(),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: SvgPicture.asset(
                        AppImage.bookmarkIcon,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "The french revolution:crash course world history #2",
                style: AppTextStyle.title24(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "World History Vault • 1200 Views",
                      style: AppTextStyle.body16(color: AppColor.gray),
                    ),
                  ),
                  SvgPicture.asset(AppImage.playListIcon),
                ],
              ),
              SizedBox(height: 20),
              AppButton(
                label: "Rate This Lesson",
                backgroundColor: AppColor.primary,
                isFilled: false,
                fontSize: 18,
              ),
              SizedBox(height: 20),
              AppTitle(
                title: "Recommended video",
                onViewMore: () {
                  videos.go(context, extra: "Recommended");
                },
              ),
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => VideoTile(),
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
