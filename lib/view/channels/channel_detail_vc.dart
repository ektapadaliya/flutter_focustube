import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/api/youtube_api.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/youtube_channel_detail_model.dart';
import 'package:focus_tube_flutter/view/videos/youtube_video_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ChannelDetailVC extends StatefulWidget {
  static const id = "/detail/:id";
  const ChannelDetailVC({super.key, required this.channelId});
  final String channelId;
  @override
  State<ChannelDetailVC> createState() => _ChannelDetailVCState();
}

class _ChannelDetailVCState extends State<ChannelDetailVC>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  YoutubeChannelDetailModel? channel;
  LoaderController loaderController = controller<LoaderController>(
    tag: "channel-detail",
  );
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
    Future.delayed(Duration.zero, () async {
      loaderController.setLoading(true);
      channel = await YoutubeApiConst.fetchYoutubeChannelDetails(
        context,
        id: widget.channelId,
      );
      loaderController.setLoading(false);
      setState(() {});
    });
  }

  YoutubeVideoController youtubeVideoController =
      controller<YoutubeVideoController>(tag: "channel");
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
                            image:
                                channel?.snippet?.thumbnails?.high?.url ?? "",
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
                                    channel?.snippet?.title ?? "",
                                    maxFontSize: 24,
                                    minFontSize: 18,
                                    style: AppTextStyle.title24(),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "${channel?.statistics?.formattedSubscriberCount ?? "0"} Followers",
                                    style: AppTextStyle.body16(
                                      color: AppColor.gray,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  AppButton(
                                    label: "Add channel",
                                    radius: 7,
                                    alignment: null,
                                    onTap: () async {
                                      loaderController.setLoading(true);
                                      await ApiFunctions.instance.channelAdd(
                                        context,
                                        youtubeId: channel?.id ?? "",
                                        title: channel?.snippet?.title ?? "",
                                        imageUrl: channel
                                            ?.snippet
                                            ?.thumbnails
                                            ?.medium
                                            ?.url,
                                        description:
                                            channel?.snippet?.description,
                                        followers: channel
                                            ?.statistics
                                            ?.subscriberCount,
                                      );
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
                            child: YoutubeVideoVC(
                              tag: "channel",
                              channelId: widget.channelId,
                              isLoading: (isLoading) {
                                changeYoutubeLoader(isLoading);
                              },
                            ),
                          ),
                          ChannelAbout(
                            description: channel?.snippet?.description ?? "",
                          ),
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
    if (youtubeVideoController.videos.isEmpty) {
      loaderController.setLoading(isLoading);
    } else {
      youtubeVideoController.setIsLoading(isLoading);
    }
  }
}
