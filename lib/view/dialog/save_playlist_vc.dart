import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/playlist_controller.dart';
import 'package:focus_tube_flutter/view/dialog/add_edit_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../model/playlist_model.dart';

class SavePlaylistVC extends StatefulWidget {
  const SavePlaylistVC({super.key, this.playList});
  final String? playList;
  @override
  State<SavePlaylistVC> createState() => _SavePlaylistVCState();
}

class _SavePlaylistVCState extends State<SavePlaylistVC> {
  String? selectedPlayListId;
  PlaylistController playlistController = controller<PlaylistController>(
    tag: "save-playlist",
  );
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    selectedPlayListId = widget.playList;
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (playlistController.playList.isEmpty) {
        await callApi();
      }
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void selectIndex(PlaylistModel? value) {
    setState(() {
      selectedPlayListId = value?.id?.toString();
    });
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

          child: Center(
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 450,
                  minWidth: 350,
                  maxHeight: MediaQuery.sizeOf(context).height / 1.3,
                ),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Save to playlist", style: AppTextStyle.title20()),
                        Expanded(child: Container(width: 10)),
                        InkWell(
                          onTap: context.pop,
                          overlayColor: WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColor.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => PlayListTile(
                          onTap: selectIndex,
                          value: playlistController.playList[index],
                          isSelected:
                              playlistController.playList[index].id
                                  .toString() ==
                              selectedPlayListId,
                          tileType: PlayListTileType.selection,
                        ),

                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15),
                        itemCount: playlistController.playList.length,
                      ),
                    ),
                    SizedBox(height: 30),
                    AppButton(
                      label: "Save",
                      backgroundColor: AppColor.primary,
                      onTap: () {
                        Navigator.of(context).pop(
                          playlistController.playList
                              .where(
                                (e) => selectedPlayListId == e.id.toString(),
                              )
                              .firstOrNull,
                        );
                      },
                    ),

                    /*   SizedBox(height: 15),
                    AppButton(
                      label: "Create playlist",
                      isFilled: false,
                      backgroundColor: AppColor.primary,
                      onTap: () {
                        context.pop();
                        showDialog(
                          context: context,
                          builder: (context) => AddEditPlaylistVC(),
                        );
                      },
                    ), */
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
