import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';

import '../../api/api_functions.dart';
import '../../const/app_text_style.dart';
import '../../controller/app_controller.dart';
import '../../controller/playlist_controller.dart';
import '../../widget/app_bar.dart';
import '../../widget/app_loader.dart';
import '../../widget/expandable_scollview.dart';
import '../../widget/playlist_widgets.dart';
import '../dialog/add_edit_playlist_vc.dart';

class PlaylistVC extends StatefulWidget {
  static const id = "/playlist";
  const PlaylistVC({super.key});

  @override
  State<PlaylistVC> createState() => _PlaylistVCState();
}

class _PlaylistVCState extends State<PlaylistVC> {
  TextEditingController searchController = TextEditingController();
  PlaylistController playlistController = controller<PlaylistController>(
    tag: "playlist-list",
  );
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    playlistController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    playlistController.clear();
    callApi();
  }

  _scrollListener() async {
    if (!playlistController.loaderController.isLoading.value &&
        playlistController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: playlistController.page + 1);
        if (playlistController.hasData) {
          playlistController.incPage();
        }
      }
    }
  }

  callApi({int page = 1}) async {
    await ApiFunctions.instance.playlistList(
      context,
      page: page,
      controller: playlistController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: playlistController.tag,
      init: playlistController,
      builder: (playlistController) {
        return AppLoader(
          showLoader: playlistController.playList.isEmpty,
          loaderController: playlistController.loaderController,
          child: ScreenBackground(
            appBar: customAppBar(
              context,
              centerTitle: true,
              title: "Playlists",
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: InkWell(
                    onTap: () async {
                      var value = await showDialog(
                        context: context,
                        builder: (context) => AddEditPlaylistVC(),
                      );
                      if (value is String) {
                        var playList = await ApiFunctions.instance
                            .playlistCreateEdit(context, title: value);
                        if (playList != null) {
                          playlistController.addPlayList(playList);
                        }
                      }
                    },
                    child: Icon(Icons.add, size: 25, color: AppColor.primary),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(top: 15),

              child: Column(
                children: [
                  AppTextFormField(
                    hintText: "Search here...",
                    controller: searchController,
                    prefixIcon: Image.asset(AppImage.search, height: 35),
                    radius: 6,
                    onFieldSubmitted: (value) async {
                      if (value.trim().isNotEmpty &&
                          playlistController.searchQuery != value.trim()) {
                        playlistController.clearSearch();
                        playlistController.setSearchQuery(
                          value.trim().isEmpty ? null : value.trim(),
                        );
                        await callApi();
                      } else if (value.trim().isEmpty) {
                        playlistController.setSearchQuery(null);
                        playlistController.clearSearch();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Obx(
                      () => RefreshIndicator(
                        onRefresh: onRefresh,
                        child:
                            (playlistController.playList.isEmpty &&
                                !(playlistController
                                    .loaderController
                                    .isLoading
                                    .value))
                            ? ExpandedSingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No playlist found",
                                    style: AppTextStyle.body16(
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ),
                              )
                            : _buildPlayListListView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayListListView() {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemBuilder: (context, index) => PlayListTile(
                  onTap: (_) {
                    playListDetail.go(
                      context,
                      id: playlistController.playList[index].id,
                    );
                  },
                  value: playlistController.playList[index],
                ),
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: playlistController.playList.length,
              ),
            ),
            if (playlistController.loaderController.isLoading.value &&
                playlistController.playList.isNotEmpty)
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
