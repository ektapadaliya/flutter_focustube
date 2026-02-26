import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/playlist_controller.dart';
import 'package:focus_tube_flutter/model/playlist_model.dart';
import 'package:focus_tube_flutter/view/dialog/add_edit_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';
import '../../widget/expandable_scollview.dart';

class PlayListDetailVC extends StatefulWidget {
  static const id = "/detail/:id";
  const PlayListDetailVC({super.key, required this.playListId});
  final String playListId;
  @override
  State<PlayListDetailVC> createState() => _PlayListDetailVCState();
}

class _PlayListDetailVCState extends State<PlayListDetailVC> {
  PlaylistController playlistController = controller<PlaylistController>(
    tag: "playlist-list",
  );
  late PlaylistModel playlist;
  late VideoController videoController;
  ScrollController scrollController = ScrollController();
  LoaderController loaderController = controller<LoaderController>(
    tag: "playlist-video-list",
  );
  @override
  void initState() {
    videoController = controller<VideoController>(tag: "playlist-video-list");
    playlist = playlistController.playList
        .where((e) => e.id?.toString() == widget.playListId)
        .first;

    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  callApi({int page = 1}) async {
    loaderController.isLoading(true);
    await ApiFunctions.instance.playlistVideoList(
      controller: videoController,
      context,
      playlistId: widget.playListId,
      page: page,
    );
    loaderController.isLoading(false);
  }

  Future<void> onRefresh() async {
    videoController.clear();
    callApi();
  }

  @override
  void dispose() {
    videoController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  _scrollListener() async {
    if (!videoController.loaderController.isLoading.value &&
        videoController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: videoController.page + 1);
        if (videoController.hasData) {
          videoController.incPage();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: videoController.tag,
      init: videoController,
      builder: (videoController) {
        return AppLoader(
          showLoader: videoController.videos.isEmpty,
          loaderController: loaderController,
          child: ScreenBackground(
            appBar: customAppBar(context, title: "Playlist Library"),
            body: SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Column(
                children: [
                  PlayListTile(
                    onTap: (_) async {
                      var value = await showDialog(
                        context: context,
                        builder: (context) =>
                            AddEditPlaylistVC(playlist: playlist.title ?? ""),
                      );
                      if (value is String && value.trim() != playlist.title) {
                        var result = await ApiFunctions.instance
                            .playlistCreateEdit(
                              context,
                              id: playlist.id.toString(),
                              title: value,
                            );
                        if (result != null) {
                          playlist = result;
                          setState(() {});
                          playlistController.addPlayList(playlist);
                        }
                      }
                    },
                    value: playlist,
                    tileType: PlayListTileType.edit,
                  ),
                  SizedBox(height: 20),
                  AppTitle(title: "Videos"),
                  SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      final isLoading = loaderController.isLoading.value;
                      return RefreshIndicator(
                        onRefresh: onRefresh,
                        child: (videoController.videos.isEmpty && !(isLoading))
                            ? ExpandedSingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No videos found",
                                    style: AppTextStyle.body16(
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ),
                              )
                            : _buildVideoList(),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoList() {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (context, index) => VideoTile(
                  video: videoController.videos[index],
                  isSlidable: true,
                  onRemoved: () {
                    ApiFunctions.instance.playlistVideoAddDelete(
                      context,
                      playlistId: widget.playListId,
                      videoId: videoController.videos[index].id.toString(),
                      isDelete: true,
                    );
                    videoController.removeVideo(
                      videoController.videos[index].id.toString(),
                    );

                    playlistController.addPlayList(
                      playlist
                        ..totalVideos = (playlist.totalVideos ?? 1) > 0
                            ? (playlist.totalVideos! - 1)
                            : 0,
                    );
                  },
                ),
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: videoController.videos.length,
              ),
            ),
            if (loaderController.isLoading.value &&
                videoController.videos.isNotEmpty)
              Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
