import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/youtube_api.dart';
import '../../controller/app_controller.dart';
import '../../widget/video_widgets.dart';

class YoutubeVideoVC extends StatefulWidget {
  const YoutubeVideoVC({
    super.key,
    required this.isLoading,
    this.channelId,
    required this.tag,
  });
  final void Function(bool isLoading)? isLoading;
  final String? channelId;
  final String tag;
  @override
  State<YoutubeVideoVC> createState() => YoutubeVideoVCState();
}

class YoutubeVideoVCState extends State<YoutubeVideoVC>
    with AutomaticKeepAliveClientMixin {
  late YoutubeVideoController youtubeVideoController;
  ScrollController youtubeScrollController = ScrollController();
  _youtubeScrollListener() {
    if (!youtubeVideoController.isLoading &&
        youtubeVideoController.nextPageToken.trim().isNotEmpty) {
      if (youtubeScrollController.offset >=
              youtubeScrollController.position.maxScrollExtent &&
          !youtubeScrollController.position.outOfRange) {
        callYoutubeSearch();
      }
    }
  }

  @override
  void initState() {
    youtubeVideoController = controller<YoutubeVideoController>(
      tag: widget.tag,
    );
    super.initState();
    if (widget.channelId != null) {
      Future.delayed(Duration.zero, () async {
        await callYoutubeSearch();
      });
    }
    youtubeScrollController.addListener(_youtubeScrollListener);
  }

  @override
  void dispose() {
    youtubeScrollController.removeListener(_youtubeScrollListener);
    youtubeScrollController.dispose();
    if (widget.channelId != null) {
      youtubeVideoController.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: youtubeVideoController,
      builder: (youtubeVideoController) {
        if (youtubeVideoController.videos.isEmpty) {
          return Center(child: Text("No videos found"));
        }
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          controller: youtubeScrollController,
          itemBuilder: (context, index) {
            var video = youtubeVideoController.videos[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                YoutubeVideoTile(
                  isFromYoutube: true,
                  title: video.snippet?.title ?? "",
                  thumbnailUrl: video.snippet?.thumbnails?.high?.url ?? "",
                  videoId: video.id?.videoId ?? "",
                ),
                if (youtubeVideoController.isLoading &&
                    index == youtubeVideoController.videos.length - 1)
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
          itemCount: youtubeVideoController.videos.length,
        );
      },
    );
  }

  Future<void> callYoutubeSearch({String? searchValue}) async {
    widget.isLoading?.call(true);
    if (youtubeVideoController.videos.isNotEmpty) {
      youtubeScrollController.animateTo(
        youtubeScrollController.offset + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    var value = await YoutubeApiConst.fetchYoutubeVideos(
      context,
      query: widget.tag == "search" ? (searchValue ?? "Recommended") : null,
      channelId: widget.channelId,
      nextPageToken: youtubeVideoController.nextPageToken,
    );
    widget.isLoading?.call(false);
    if (value != null) {
      youtubeVideoController.addVideos(value['videos']);
      youtubeVideoController.setNextPageToken(value['nextPageToken']);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
