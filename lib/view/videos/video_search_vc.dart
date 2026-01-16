import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:get/get.dart';

import '../../api/youtube_api.dart';
import '../../const/app_color.dart';
import '../../const/app_text_style.dart';
import '../../controller/app_controller.dart';
import '../../widget/expandable_scollview.dart';
import '../../widget/video_widgets.dart';

class VideoSearchVC extends StatefulWidget {
  const VideoSearchVC({super.key, required this.isLoading, required this.tag});
  final void Function(bool isLoading)? isLoading;
  final String tag;
  @override
  State<VideoSearchVC> createState() => VideoSearchVCState();
}

class VideoSearchVCState extends State<VideoSearchVC>
    with AutomaticKeepAliveClientMixin {
  late VideoController videoController;
  ScrollController scrollController = ScrollController();
  _scrollListener() async {
    if (!videoController.loaderController.isLoading.value &&
        videoController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callSearch(page: videoController.page + 1);
        if (videoController.hasData) {
          videoController.incPage();
        }
      }
    }
  }

  @override
  void initState() {
    videoController = controller<VideoController>(tag: widget.tag);
    super.initState();

    Future.delayed(Duration.zero, () async {
      await callSearch();
    });

    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    videoController.clear();
    callSearch();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: widget.tag,
      init: videoController,
      builder: (videoController) {
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
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      var video = videoController.videos[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VideoTile(video: video),

                          if (videoController
                                  .loaderController
                                  .isLoading
                                  .value &&
                              index == videoController.videos.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemCount: videoController.videos.length,
                  ),
          ),
        );
      },
    );
  }

  Future<void> callSearch({String? searchValue, int page = 1}) async {
    widget.isLoading?.call(true);
    if (videoController.videos.isNotEmpty) {
      scrollController.animateTo(
        scrollController.offset + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    await ApiFunctions.instance.getVideos(
      context,
      controller: videoController,
      search: searchValue,
      page: page,
    );
    widget.isLoading?.call(false);
  }

  @override
  bool get wantKeepAlive => true;
}
