import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';

import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';
import '../../controller/app_controller.dart';
import '../../widget/app_loader.dart';
import '../../widget/expandable_scollview.dart';

class ChannelListVC extends StatefulWidget {
  const ChannelListVC({super.key, required this.tag});
  final String tag;
  @override
  State<ChannelListVC> createState() => _ChannelListVCState();
}

class _ChannelListVCState extends State<ChannelListVC>
    with AutomaticKeepAliveClientMixin {
  late ChannelController channelController;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    channelController = controller<ChannelController>(tag: widget.tag);
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    channelController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    channelController.clear();
    callApi();
  }

  _scrollListener() async {
    if (!channelController.loaderController.isLoading.value &&
        channelController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: channelController.page + 1);
        if (channelController.hasData) {
          channelController.incPage();
        }
      }
    }
  }

  callApi({int page = 1}) async {
    await ApiFunctions.instance.channelList(
      context,
      controller: channelController,
      page: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: channelController.tag,
      init: channelController,
      builder: (channelController) {
        return AppLoader(
          showLoader: channelController.channels.isEmpty,
          loaderController: channelController.loaderController,
          child: ScreenBackground(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(top: 15),

              child: Obx(
                () => RefreshIndicator(
                  onRefresh: onRefresh,
                  child:
                      (channelController.channels.isEmpty &&
                          !(channelController.loaderController.isLoading.value))
                      ? ExpandedSingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Channels found",
                              style: AppTextStyle.body16(color: AppColor.gray),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ListView.separated(
                                physics: AlwaysScrollableScrollPhysics(),
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  var channel =
                                      channelController.channels[index];
                                  return ChannelTile(
                                    title: channel.title ?? "",
                                    channelId: channel.youtubeId ?? "",
                                    channelImage: channel.imageUrl ?? "",
                                    showAddChannels:
                                        channelController.tag ==
                                        "channel-scholartube",
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    ChannelDivider(),
                                itemCount: channelController.channels.length,
                              ),
                            ),
                            if (channelController
                                    .loaderController
                                    .isLoading
                                    .value &&
                                channelController.channels.isNotEmpty)
                              Container(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
