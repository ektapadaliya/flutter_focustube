import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/view/dialog/feedback_vc.dart';
import 'package:focus_tube_flutter/view/dialog/save_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
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
  late String title;
  late String thumbnailUrl;
  late String channelTitle;
  double? aspectRatio;
  @override
  void initState() {
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
      title = "The french revolution:crash course world history #2";
      thumbnailUrl = "";
      channelTitle = "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(
        context,
        title: "Lesson",
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
                    MediaQuery.of(context).orientation == Orientation.landscape
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
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _videoPlayer(),
                    SizedBox(height: 20),
                    ..._nonYoutubeWidgets(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildYoutubePlayer() {
    return YoutubePlayer(
      controller: _youtubePlayerController!,

      progressColors: ProgressBarColors(
        backgroundColor: AppColor.borderColor,
        bufferedColor: AppColor.gray,
        playedColor: AppColor.red,
      ),
      progressIndicatorColor: AppColor.red,
      showVideoProgressIndicator: true,
    );
  }

  Widget _buildVideoTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.title20()),
        Text(channelTitle, style: AppTextStyle.body16(color: AppColor.gray)),
      ],
    );
  }

  Widget _videoPlayer() {
    var size = MediaQuery.sizeOf(context).aspectRatio > 1
        ? Size(
            MediaQuery.sizeOf(context).height,
            MediaQuery.sizeOf(context).width / 3,
          )
        : Size(
            MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height / 3,
          );
    return Center(
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          NetworkImageClass(
            height: size.height,
            width: size.width,
            placeHolder: AppImage.videoPlaceHolder,
            borderRadius: BorderRadius.circular(12),
            image: thumbnailUrl,
          ),
          PlayPauseIcon(),
          if (!widget.isFromYoutube)
            Positioned(
              top: 15,
              left: 15,
              child: SvgPicture.asset(
                AppImage.bookmarkIcon,
                height: 30,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
        ],
      ),
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
    SizedBox(height: 20),
    Center(
      child: AppButton(
        label: "Rate This Lesson",
        backgroundColor: AppColor.primary,
        isFilled: false,
        fontSize: 18,
        onTap: () {
          showDialog(context: context, builder: (context) => FeedbackVC());
        },
      ),
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
  ];
}
