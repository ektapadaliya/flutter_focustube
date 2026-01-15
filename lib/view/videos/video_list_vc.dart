import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/video_controller.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class VideoListVC extends StatefulWidget {
  static const id = "/videos";
  const VideoListVC({super.key, required this.tag});
  final String tag;
  @override
  State<VideoListVC> createState() => _VideoListVCState();
}

class _VideoListVCState extends State<VideoListVC> {
  late VideoController videoController;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    videoController = controller<VideoController>(
      tag: getTitleFromControllerTag(widget.tag),
    );
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callVideoListApi();
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    videoController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    videoController.clear();
    callVideoListApi();
  }

  _scrollListener() async {
    if (!videoController.loaderController.isLoading.value &&
        videoController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callVideoListApi(page: videoController.page + 1);
        if (videoController.hasData) {
          videoController.incPage();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: videoController.loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context, title: getTitleFromTag(widget.tag)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: GetBuilder(
            tag: getTitleFromControllerTag(widget.tag),
            init: videoController,
            builder: (context) {
              return Obx(
                () => RefreshIndicator(
                  onRefresh: onRefresh,
                  child:
                      (videoController.videos.isEmpty &&
                          !(videoController.loaderController.isLoading.value))
                      ? ExpandedSingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No videos found",
                              style: AppTextStyle.body16(color: AppColor.gray),
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          itemBuilder: (context, index) => VideoTile(
                            video: videoController.videos[index],
                            onBookmark: (id) {
                              videoController.changeBookmarkStatus(id);
                              ApiFunctions.instance.bookmarkVideo(
                                context,
                                videoId: id,
                              );
                            },
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15),
                          itemCount: videoController.videos.length,
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String getTitleFromTag(String tag) {
    return switch (tag) {
      "bookmark" => "Bookmarked",
      "popular" => "Popular",
      "recommended" => "Recommended",
      "my_history" => "My History",
      "bookmarks" => "Bookmarks",
      "history" => "History",
      _ => "",
    };
  }

  String getTitleFromControllerTag(String tag) {
    return switch (tag) {
      "bookmark" => "bookmark",
      "popular" => "popular",
      "recommended" => "recommended",
      "my_history" => "history",
      "bookmarks" => "bookmark",
      "history" => "history",
      _ => "",
    };
  }

  Future<void> callVideoListApi({int page = 1}) async {
    if (widget.tag == "bookmark" || widget.tag == "bookmarks") {
      await ApiFunctions.instance.getBookmarkVideos(
        context,
        page: page,
        controller: videoController,
      );
    } else if (widget.tag == "popular") {
      await ApiFunctions.instance.getPopularVideos(
        context,
        page: page,
        controller: videoController,
      );
    } else if (widget.tag == "recommended") {
      await ApiFunctions.instance.getRecommenedVideos(
        context,
        page: page,
        controller: videoController,
      );
    }
  }
}
