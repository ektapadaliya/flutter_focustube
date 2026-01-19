import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/api/youtube_api.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/view/dialog/feedback_vc.dart';
import 'package:focus_tube_flutter/view/dialog/save_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/state_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailVC extends StatefulWidget {
  static const id = "/video/:id";
  static const youtubeId = "/youtube-video/:id";
  const VideoDetailVC({
    super.key,
    this.isFromYoutube = false,
    required this.videoId,
  });
  final bool isFromYoutube;
  final String videoId;
  @override
  State<VideoDetailVC> createState() => _VideoDetailVCState();
}

class _VideoDetailVCState extends State<VideoDetailVC> {
  YoutubePlayerController? _youtubePlayerController;
  String? title;
  String? thumbnailUrl;
  String? channelTitle;
  double? aspectRatio;
  LoaderController loaderController = controller<LoaderController>(
    tag: "video-detail",
  );
  VideoController? videoController;
  late final ValueNotifier<bool> isRatedNotifier;
  @override
  void initState() {
    isRatedNotifier = ValueNotifier(false);
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (widget.isFromYoutube) {
        var video = controller<YoutubeVideoController>().videos
            .where((e) => e.id?.videoId == widget.videoId)
            .firstOrNull;
        if (video != null) {
          aspectRatio = Size(
            (video.snippet?.thumbnails?.high?.width ?? 0).toDouble(),
            (video.snippet?.thumbnails?.high?.height ?? 0).toDouble(),
          ).aspectRatio;
          title = video.snippet?.title ?? "";
          thumbnailUrl = video.snippet?.thumbnails?.high?.url ?? "";
          channelTitle = video.snippet?.channelTitle ?? "";
          _youtubePlayerController = YoutubePlayerController(
            initialVideoId: widget.videoId,
            flags: const YoutubePlayerFlags(autoPlay: true),
          );
        }
      } else {
        loaderController.setLoading(true);
        await callVideoDetailsApi();
        loaderController.setLoading(false);
      }
    });
  }

  Future<void> callVideoDetailsApi() async {
    var video = await ApiFunctions.instance.getVideoDetails(
      context,
      videoId: widget.videoId,
    );

    if (video != null) {
      videoController = controller<VideoController>(tag: video.id.toString());
      ApiFunctions.instance.getRecommenedVideos(
        context,
        videoId: widget.videoId,
        controller: videoController!,
      );

      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: video.youtubeId ?? "",
        flags: const YoutubePlayerFlags(autoPlay: true),
      );
      loaderController.setLoading(false);
      title = video.title ?? "";
      thumbnailUrl = YoutubeApiConst.thubnailFromId(video.youtubeId ?? "");
      channelTitle = video.channelName ?? "";

      isRatedNotifier.value = video.isFeedback ?? false;

      setState(() {});
    }
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    isRatedNotifier.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(
          context,
          title: title,
          actions: widget.isFromYoutube
              ? null
              : [
                  InkWell(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    onTap: () {
                      notes.go(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 30),
                      child: SvgPicture.asset(AppImage.noteIcon, height: 20),
                    ),
                  ),
                ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          top: false,
          child: widget.isFromYoutube
              ? ExpandedSingleChildScrollView(
                  physics:
                      MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? const AlwaysScrollableScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height:
                            MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.height -
                                  (kToolbarHeight + 70)
                            : null,
                        width:
                            MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.width
                            : null,
                        child: _buildYoutubePlayer(),
                      ),
                      SizedBox(height: 20),
                      _buildVideoTitle(),
                    ],
                  ),
                )
              : _youtubePlayerController != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildYoutubePlayer(),
                      SizedBox(height: 20),
                      ..._nonYoutubeWidgets(),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  Widget _buildYoutubePlayer() {
    if (_youtubePlayerController != null) {
      return YoutubePlayer(
        controller: _youtubePlayerController!,

        progressColors: ProgressBarColors(
          backgroundColor: AppColor.borderColor,
          bufferedColor: AppColor.gray,
          playedColor: AppColor.red,
          handleColor: AppColor.red,
        ),
        progressIndicatorColor: AppColor.red,
        showVideoProgressIndicator: true,
      );
    }
    return SizedBox();
  }

  Widget _buildVideoTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? "", style: AppTextStyle.title20()),
        Text(
          channelTitle ?? "",
          style: AppTextStyle.body16(color: AppColor.gray),
        ),
      ],
    );
  }

  List<Widget> _nonYoutubeWidgets() => [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildVideoTitle()),
        if (!widget.isFromYoutube)
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (context) => SavePlaylistVC(),
            ),
            child: SvgPicture.asset(AppImage.playListIcon),
          ),
      ],
    ),
    ValueListenableBuilder<bool>(
      valueListenable: isRatedNotifier,
      builder: (context, isRated, _) {
        if (isRated) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: AppButton(
              label: "Rate This Lesson",
              backgroundColor: AppColor.primary,
              isFilled: false,
              fontSize: 18,
              onTap: () async {
                var value = await showDialog(
                  context: context,
                  builder: (context) => FeedbackVC(),
                );

                if (value != null) {
                  loaderController.setLoading(true);

                  var isSuccess = await ApiFunctions.instance.addVideoFeedBack(
                    context,
                    videoId: widget.videoId,
                    rating: value.toString(),
                  );

                  loaderController.setLoading(false);

                  if (isSuccess) {
                    isRatedNotifier.value = true;
                  }
                }
              },
            ),
          ),
        );
      },
    ),
    if (videoController != null) ...[
      SizedBox(height: 20),
      AppTitle(
        title: "Recommended video",
        onViewMore: () {
          videos.go(context, id: "recommended-${widget.videoId}");
        },
      ),
      SizedBox(height: 10),
      GetBuilder(
        tag: videoController?.tag,
        init: videoController,
        builder: (videoController) {
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                VideoTile(video: videoController.videos[index]),
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemCount: videoController.videos.length,
          );
        },
      ),
    ],
  ];
}
