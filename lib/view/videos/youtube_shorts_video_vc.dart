import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/model/youtube_video_model.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../controller/app_controller.dart';
import '../../controller/shorts_controller.dart';

class YoutubeShortPlayListVideoVC extends StatefulWidget {
  const YoutubeShortPlayListVideoVC({
    super.key,
    required this.isLoading,
    this.platListId,
    required this.tag,
  });

  final void Function(bool isLoading)? isLoading;
  final String? platListId;
  final String tag;

  @override
  State<YoutubeShortPlayListVideoVC> createState() =>
      YoutubeShortPlayListVideoVCState();
}

class YoutubeShortPlayListVideoVCState
    extends State<YoutubeShortPlayListVideoVC>
    with AutomaticKeepAliveClientMixin {
  late ShortsController shortsController;

  @override
  void initState() {
    super.initState();
    shortsController = controller<ShortsController>(tag: widget.tag);
    if (widget.platListId != null) {
      Future.delayed(Duration.zero, () async {
        widget.isLoading?.call(true);
        await shortsController.setPlaylistId(context, widget.platListId!);
        widget.isLoading?.call(false);
      });
    }
  }

  @override
  void dispose() {
    if (widget.platListId != null) {
      shortsController.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ShortsController>(
      init: shortsController,
      tag: widget.tag,
      builder: (c) {
        if (c.isLoading && c.videos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.videos.isEmpty) {
          return const Center(child: Text('No shorts found'));
        }
        return PageView.builder(
          controller: c.pageController,
          scrollDirection: Axis.vertical,
          itemCount: c.videos.length,
          onPageChanged: (index) => c.onPageChanged(context, index),
          itemBuilder: (_, index) => _ShortsPlayerTile(
            video: c.videos[index],
            // Retrieve the cached controller — never recreated for the same videoId
            playerController: c.playerFor(c.videos[index].id?.videoId ?? ''),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// --------------------------------------------------
// Single Shorts tile — uses a controller owned by ShortsController
// --------------------------------------------------
class _ShortsPlayerTile extends StatelessWidget {
  const _ShortsPlayerTile({
    required this.video,
    required this.playerController,
  });

  final YoutubeVideoModel video;
  final YoutubePlayerController playerController;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: playerController,
        showVideoProgressIndicator: false,
      ),
      builder: (context, player) => SizedBox.expand(child: player),
    );
  }
}
