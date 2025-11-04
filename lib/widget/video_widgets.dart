import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
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
        constraints: BoxConstraints(
          maxWidth: AppConst.maxWidth(context) > 450
              ? 390
              : AppConst.maxWidth(context) - 60,
          maxHeight: 230,
        ),
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
                  // SizedBox(height: 10),
                  // SizedBox(
                  //   height: 6,
                  //   child: LinearProgressIndicator(
                  //     borderRadius: BorderRadius.circular(12),
                  //     backgroundColor: AppColor.white.opacityToAlpha(.3),
                  //     valueColor: AlwaysStoppedAnimation<Color>(AppColor.white),
                  //     value: .5,
                  //   ),
                  // ),
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
  final bool isSlidable;
  final void Function()? onRemoved;
  const VideoTile({super.key, this.isSlidable = false, this.onRemoved});
  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSlidable) {
      return Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          dragDismissible: true,
          dismissible: DismissiblePane(onDismissed: widget.onRemoved ?? () {}),
          children: [
            CustomSlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (context) {
                setState(() {});
                Slidable.of(context)?.close();
                if (widget.onRemoved != null) {
                  widget.onRemoved!();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.lightYellow.opacityToAlpha(0),
                      AppColor.lightYellow.opacityToAlpha(.1),
                      AppColor.red.opacityToAlpha(.1),
                      AppColor.red.opacityToAlpha(.3),
                      AppColor.red.opacityToAlpha(.5),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColor.red,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget get child => InkWell(
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
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
/* 
Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.red.opacityToAlpha(0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Slidable(
        key: ValueKey(widget.value),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          dragDismissible: true,
          dismissible: DismissiblePane(onDismissed: widget.onDismissed),
          children: [
            CustomSlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (context) {
                widget.onDismissed();
                setState(() {});
                Slidable.of(context)?.close();
              },
              child: Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.grey.opacityToAlpha(.08)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Opacity(
            opacity: widget.isRead ? 0.5 : 1,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: AppColors.black.opacityToAlpha(.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(widget.badgePath, height: 45),
                        Image.asset(widget.iconPath, height: 25),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: AppTextStyles.bold70014()),
                        SizedBox(height: 3),
                        Text(
                          widget.description,
                          style: AppTextStyles.bold40012(color: AppColors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3),
                        Text(
                          widget.timeAgo,
                          style: AppTextStyles.bold40012(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
 */