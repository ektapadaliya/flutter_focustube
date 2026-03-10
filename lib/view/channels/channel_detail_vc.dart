import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/api/youtube_api.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/youtube_playlist_video_controller.dart';
import 'package:focus_tube_flutter/model/channel_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import '../videos/youtube_playlist_video_vc.dart';

class ChannelDetailVC extends StatefulWidget {
  static const id = "/detail/:id";

  const ChannelDetailVC({
    super.key,
    required this.channelId,
    required this.tag,
  });
  final String channelId;
  final String tag;
  @override
  State<ChannelDetailVC> createState() => _ChannelDetailVCState();
}

class _ChannelDetailVCState extends State<ChannelDetailVC>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showAddChannel = false;
  ChannelModel? channel;
  LoaderController loaderController = controller<LoaderController>(
    tag: "channel-detail",
  );

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
    Future.delayed(Duration.zero, () async {
      await getChannelDetails();

      loaderController.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getChannelDetails() async {
    ApiFunctions.instance
        .channelIsMyChannel(context, youtubeId: widget.channelId)
        .then((value) {
          showAddChannel = !value;
          setState(() {});
        });
    if (widget.tag == "channel-youtube") {
      loaderController.setLoading(true);
      var details = await YoutubeApiConst.fetchYoutubeChannelDetails(
        context,
        id: widget.channelId,
      );
      if (details != null) {
        channel = details.channelModel;
      }
      loaderController.setLoading(false);
    } else {
      channel = controller<ChannelController>(
        tag: widget.tag,
      ).channels.where((e) => e.youtubeId == widget.channelId).firstOrNull;
    }
    setState(() {});
  }

  YoutubePlaylistVideoController youtubeVideoController =
      controller<YoutubePlaylistVideoController>(tag: "channel");
  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context, title: "Channel details"),
        body: SafeArea(
          child: channel != null
              ? Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 140,
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          NetworkImageClass(
                            height: 120,
                            width: 120,
                            shape: BoxShape.circle,
                            image: channel?.imageUrl ?? "",
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    channel?.title ?? "",
                                    maxFontSize: 24,
                                    minFontSize: 18,
                                    style: AppTextStyle.title24(),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "${formattedSubscriberCount(channel?.followers ?? "0")} Followers",
                                    style: AppTextStyle.body16(
                                      color: AppColor.gray,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  if (widget.tag == "channel-youtube" &&
                                      showAddChannel)
                                    AppButton(
                                      label: "Add channel",
                                      radius: 7,
                                      alignment: null,
                                      onTap: () async {
                                        loaderController.setLoading(true);
                                        var isSuccess = await ApiFunctions
                                            .instance
                                            .channelAdd(
                                              context,
                                              youtubeId:
                                                  channel?.youtubeId ?? "",
                                              title: channel?.title ?? "",
                                              imageUrl: channel?.imageUrl,
                                              description: channel?.description,
                                              followers: channel?.followers,
                                            );
                                        if (isSuccess) {
                                          showAddChannel = false;
                                          setState(() {});
                                        }
                                        loaderController.setLoading(false);
                                      },
                                      backgroundColor: AppColor.primary,
                                      height: 32,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      fontSize: 12,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColor.primary,
                      dividerColor: AppColor.gray,
                      indicatorSize: TabBarIndicatorSize.tab,
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      labelStyle: AppTextStyle.title18(),
                      labelColor: AppColor.primary,
                      unselectedLabelColor: AppColor.gray,
                      tabs: [
                        Tab(text: "Videos"),
                        Tab(text: "About"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: YoutubePlayListVideoVC(
                              tag: "channel",
                              channelId: channel?.youtubePlaylistId,
                              isLoading: (isLoading) {
                                changeYoutubeLoader(isLoading);
                              },
                            ),
                          ),
                          ChannelAbout(description: channel?.description ?? ""),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: Container()),
        ),
      ),
    );
  }

  void changeYoutubeLoader(bool isLoading) {
    if (youtubeVideoController.playListVideos.isEmpty) {
      loaderController.setLoading(isLoading);
    } else {
      youtubeVideoController.setIsLoading(isLoading);
    }
  }

  String formattedSubscriberCount(String? subscriberCount) {
    if (subscriberCount == null) return "0";
    double count = double.tryParse(subscriberCount) ?? 0;

    if (count >= 1000000000) {
      return "${(count / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B";
    } else if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K";
    } else {
      return count.toStringAsFixed(0);
    }
  }
}
