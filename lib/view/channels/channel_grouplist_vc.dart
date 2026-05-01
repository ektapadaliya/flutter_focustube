import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/model/channel_model.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';
import '../../controller/app_controller.dart';
import '../../widget/app_loader.dart';
import '../../widget/expandable_scollview.dart';

class ChannelGroupListVC extends StatefulWidget {
  const ChannelGroupListVC({super.key, required this.tag});
  final String tag;

  @override
  State<ChannelGroupListVC> createState() => _ChannelGroupListVCState();
}

class _ChannelGroupListVCState extends State<ChannelGroupListVC>
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
    await callApi();
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
    return GetBuilder<ChannelController>(
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
                          children: [
                            Expanded(
                              child: GroupedListView<ChannelModel, String>(
                                elements: channelController.channels,

                                controller: scrollController,
                                physics: AlwaysScrollableScrollPhysics(),

                                /// 🔹 GROUP BY (First Letter)
                                groupBy: (channel) {
                                  final date = channel.createdAt ?? 0;
                                  return DateFormat("yyyy-MM-dd").format(
                                    DateTime.fromMillisecondsSinceEpoch(date),
                                  );
                                },

                                /// 🔹 GROUP HEADER UI
                                groupSeparatorBuilder: (String group) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Text(
                                      group,
                                      style: AppTextStyle.title20(),
                                    ),
                                  );
                                },

                                /// 🔹 ITEM UI
                                itemBuilder: (context, channel) {
                                  return Column(
                                    children: [
                                      ChannelTile(
                                        title: channel.title ?? "",
                                        channelId: channel.youtubeId ?? "",
                                        channelImage: channel.imageUrl ?? "",
                                        tag: channelController.tag!,
                                      ),
                                      ChannelDivider(),
                                    ],
                                  );
                                },

                                /// 🔹 SORT ITEMS
                                itemComparator: (a, b) =>
                                    (a.title ?? "").compareTo(b.title ?? ""),

                                /// 🔹 SORT GROUPS
                                order: GroupedListOrder.ASC,

                                useStickyGroupSeparators: false,
                                floatingHeader: false,
                              ),
                            ),

                            /// 🔹 Pagination Loader
                            if (channelController
                                    .loaderController
                                    .isLoading
                                    .value &&
                                channelController.channels.isNotEmpty)
                              Container(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
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
