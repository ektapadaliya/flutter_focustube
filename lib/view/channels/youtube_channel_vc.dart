import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/api/youtube_api.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:get/get.dart';

import '../../const/app_image.dart';
import '../../widget/app_text_form_field.dart';

class YoutubeChannelVC extends StatefulWidget {
  static const id = "/channels";
  const YoutubeChannelVC({super.key});

  @override
  State<YoutubeChannelVC> createState() => _YoutubeChannelVCState();
}

class _YoutubeChannelVCState extends State<YoutubeChannelVC>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  String? searchValue;
  int selectedIndex = 0;
  LoaderController loaderController = controller<LoaderController>(
    tag: "youtube_channel",
  );
  YoutubeChannelController youtubeChannelController =
      controller<YoutubeChannelController>();

  ScrollController youtubeScrollController = ScrollController();

  _youtubeScrollListener() {
    if (!youtubeChannelController.isLoading &&
        youtubeChannelController.nextPageToken.trim().isNotEmpty) {
      if (youtubeScrollController.offset >=
              youtubeScrollController.position.maxScrollExtent &&
          !youtubeScrollController.position.outOfRange) {
        callYoutubeSearch();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    youtubeScrollController.addListener(_youtubeScrollListener);
    Future.delayed(Duration.zero, () async {
      await callYoutubeSearch();
    });
  }

  @override
  void dispose() {
    youtubeScrollController.removeListener(_youtubeScrollListener);
    youtubeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: GetBuilder(
          init: youtubeChannelController,
          builder: (youtubeChannelController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: AppTextFormField(
                    controller: searchController,
                    radius: 6,
                    onFieldSubmitted: onSearch,
                    hintText: "Search here...",
                    hintTextColor: AppColor.gray,
                    prefixIcon: Image.asset(AppImage.search, height: 35),
                    suffixIcon: searchValue == null
                        ? null
                        : GestureDetector(
                            onTap: clearSearch,
                            child: Icon(
                              Icons.close,
                              size: 22,
                              color: AppColor.gray,
                            ),
                          ),
                  ),
                ),

                Text("Search Results", style: AppTextStyle.title20()),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    controller: youtubeScrollController,
                    itemBuilder: (context, index) {
                      var channel = youtubeChannelController.channels[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChannelTile(
                            title: channel.snippet?.title ?? "",
                            channelImage:
                                channel.snippet?.thumbnails?.high?.url ?? "",
                            channelId: channel.id?.channelId ?? "",
                            onAddChannel: () {
                              ApiFunctions.instance.channelAdd(
                                context,
                                youtubeId: channel.snippet?.channelId ?? "",
                                title: channel.snippet?.title ?? "",
                                imageUrl:
                                    channel.snippet?.thumbnails?.medium?.url ??
                                    "",
                                description: channel.snippet?.description ?? "",
                              );
                            },
                          ),
                          if (youtubeChannelController.isLoading &&
                              index ==
                                  youtubeChannelController.channels.length - 1)
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
                    separatorBuilder: (context, index) => ChannelDivider(),
                    itemCount: youtubeChannelController.channels.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void changeYoutubeLoader(bool isLoading) {
    if (youtubeChannelController.channels.isEmpty) {
      loaderController.setLoading(isLoading);
    } else {
      youtubeChannelController.setIsLoading(isLoading);
    }
  }

  Future<void> callYoutubeSearch() async {
    changeYoutubeLoader(true);
    if (youtubeChannelController.channels.isNotEmpty) {
      youtubeScrollController.animateTo(
        youtubeScrollController.offset + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    var value = await YoutubeApiConst.fetchYoutubeChannels(
      context,
      query: searchValue == null ? "Recommended" : searchValue!,
      nextPageToken: youtubeChannelController.nextPageToken,
    );
    changeYoutubeLoader(false);
    if (value != null) {
      youtubeChannelController.addChannels(value['channels']);
      youtubeChannelController.setNextPageToken(value['nextPageToken']);
    }
  }

  void onSearch(String? value) {
    if ((value ?? "").trim().isNotEmpty) {
      searchValue = value;
      setState(() {});
      if (selectedIndex == 0) {
        youtubeChannelController.clear();
        callYoutubeSearch();
      }
    }
  }

  void clearSearch() {
    searchValue = null;
    searchController.clear();
    youtubeChannelController.clear();
    setState(() {});
    callYoutubeSearch();
  }

  @override
  bool get wantKeepAlive => true;
}
