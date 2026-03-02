import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/controller/youtube_playlist_video_controller.dart';
import 'package:get/get.dart';

import '../../api/youtube_api.dart';
import '../../controller/app_controller.dart';
import '../../widget/video_widgets.dart';

class YoutubePlayListVideoVC extends StatefulWidget {
  const YoutubePlayListVideoVC({
    super.key,
    required this.isLoading,
    this.channelId,
    required this.tag,
  });
  final void Function(bool isLoading)? isLoading;
  final String? channelId;
  final String tag;
  @override
  State<YoutubePlayListVideoVC> createState() => YoutubePlayListVideoVCState();
}

class YoutubePlayListVideoVCState extends State<YoutubePlayListVideoVC>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlaylistVideoController youtubeVideoController;
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
    youtubeVideoController = controller<YoutubePlaylistVideoController>(
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
        if (youtubeVideoController.playListVideos.isEmpty) {
          return Center(child: Text("No videos found"));
        }
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          controller: youtubeScrollController,
          itemBuilder: (context, index) {
            var playList = youtubeVideoController.playListVideos[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                YoutubeVideoTile(
                  isFromYoutube: true,
                  isFromChannel: true,
                  title: playList.snippet?.title ?? "",
                  thumbnailUrl: playList.snippet?.thumbnails?.high?.url ?? "",
                  videoId: playList.snippet?.resourceId?.videoId ?? "",
                ),
                if (youtubeVideoController.isLoading &&
                    index == youtubeVideoController.playListVideos.length - 1)
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
          itemCount: youtubeVideoController.playListVideos.length,
        );
      },
    );
  }

  Future<void> callYoutubeSearch({String? searchValue}) async {
    widget.isLoading?.call(true);
    if (youtubeVideoController.playListVideos.isNotEmpty) {
      youtubeScrollController.animateTo(
        youtubeScrollController.offset + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    var value = await YoutubeApiConst.fetchPlayListItems(
      context,
      query: widget.tag == "search" ? (searchValue ?? "Recommended") : null,
      playlistId: widget.channelId,
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
