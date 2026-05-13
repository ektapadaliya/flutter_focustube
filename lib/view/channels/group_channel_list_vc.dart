import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';

import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';

import 'package:focus_tube_flutter/model/channel_group_model.dart';
import 'package:focus_tube_flutter/view/channels/channel_list_vc.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/channel_widgets.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';

class GroupChannelListVC extends StatefulWidget {
  const GroupChannelListVC({super.key, required this.tag});
  final String tag;

  @override
  State<GroupChannelListVC> createState() => _GroupChannelListVCState();
}

class _GroupChannelListVCState extends State<GroupChannelListVC>
    with AutomaticKeepAliveClientMixin {
  late GroupChannelController groupController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    groupController = controller<GroupChannelController>(tag: widget.tag);
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    groupController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    groupController.clear();
    await callApi();
  }

  void _scrollListener() async {
    if (!groupController.loaderController.isLoading.value &&
        groupController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: groupController.page + 1);
        if (groupController.hasData) {
          groupController.incPage();
        }
      }
    }
  }

  Future<void> callApi({int page = 1}) async {
    await ApiFunctions.instance.channelGroupList(
      context,
      controller: groupController,
      page: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<GroupChannelController>(
      tag: widget.tag,
      init: groupController,
      builder: (c) {
        return AppLoader(
          showLoader: c.groups.isEmpty,
          loaderController: c.loaderController,
          child: ScreenBackground(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(top: 15),
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: onRefresh,
                  child:
                      (c.groups.isEmpty && !c.loaderController.isLoading.value)
                      ? ExpandedSingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Text(
                              'No groups found',
                              style: AppTextStyle.body16(color: AppColor.gray),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: scrollController,
                                itemCount: c.groups.length,
                                separatorBuilder: (_, __) => ChannelDivider(),
                                itemBuilder: (_, index) {
                                  final group = c.groups[index];
                                  if (group.channels == null ||
                                      group.channels!.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return _GroupTile(
                                    group: group,
                                    onViewMore: () {
                                      channelMeList.go(
                                        context,
                                        id: group.id?.toString(),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            if (c.loaderController.isLoading.value &&
                                c.groups.isNotEmpty)
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

// --------------------------------------------------
// Single group tile: title + its channels list
// --------------------------------------------------
class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group, this.onViewMore});
  final ChannelGroupModel group;
  final VoidCallback? onViewMore;

  @override
  Widget build(BuildContext context) {
    final channels = group.channels ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle(title: group.title ?? '', onViewMore: onViewMore),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: channels.length,
          separatorBuilder: (_, __) => ChannelDivider(),
          itemBuilder: (_, i) => ChannelTile(
            title: channels[i].title ?? '',
            channelId: channels[i].youtubeId ?? '',
            channelImage: channels[i].imageUrl ?? '',
            tag: 'channel-me',
          ),
        ),
      ],
    );
  }
}
