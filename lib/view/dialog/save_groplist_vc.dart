import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/channel_group_model.dart';
import 'package:focus_tube_flutter/view/dialog/add_edit_group_vc.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/groplist_widget.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SaveGroplistVC extends StatefulWidget {
  const SaveGroplistVC({super.key, this.selectedGroupId, this.loading});
  final String? selectedGroupId;
  final void Function(bool loading)? loading;
  @override
  State<SaveGroplistVC> createState() => _SaveGroplistVCState();
}

class _SaveGroplistVCState extends State<SaveGroplistVC> {
  String? selectedGroupId;
  GroupListController groupListController = controller<GroupListController>(
    tag: 'save-group',
  );
  ScrollController scrollController = ScrollController();

  void isLoading(bool state) {
    if (widget.loading != null) {
      widget.loading!(state);
    }
  }

  @override
  void initState() {
    selectedGroupId = widget.selectedGroupId;
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (groupListController.groupList.isEmpty) {
        await callApi();
      } else {
        callApi();
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

  void selectGroup(GroupModel? value) {
    setState(() {
      selectedGroupId = value?.id?.toString();
    });
  }

  Future<void> onRefresh() async {
    groupListController.clear();
    await callApi();
  }

  void _scrollListener() async {
    if (!groupListController.loaderController.isLoading.value &&
        groupListController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: groupListController.page + 1);
        if (groupListController.hasData) {
          groupListController.incPage();
        }
      }
    }
  }

  Future<void> callApi({int page = 1}) async {
    await ApiFunctions.instance.channelGroupListOnly(
      context,
      controller: groupListController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupListController>(
      tag: groupListController.tag,
      init: groupListController,
      builder: (c) {
        return AppLoader(
          showLoader: c.groupList.isEmpty,
          loaderController: c.loaderController,
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
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('Save to group', style: AppTextStyle.title20()),
                        Expanded(child: Container(width: 10)),
                        AppInkWell(
                          onTap: context.pop,
                          child: Icon(
                            Icons.close,
                            color: AppColor.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: c.groupList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemBuilder: (_, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (index == 0) ...[
                                AppButton(
                                  isFilled: false,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  height: 48,
                                  radius: 12,
                                  onTap: () async {
                                    var value = await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AddEditGroupListVC(),
                                    );
                                    if (value is String &&
                                        value.trim().isNotEmpty) {
                                      c.loaderController.setLoading(true);
                                      var group = await ApiFunctions.instance
                                          .groupCreate(
                                            context,
                                            title: value.capitalizeFirst!,
                                          );
                                      if (group != null) {
                                        groupListController.addAtTopGroup(
                                          group,
                                        );
                                      }
                                      c.loaderController.setLoading(false);
                                    }
                                  },
                                  backgroundColor: AppColor.primary,
                                  label: "+ Add Group",
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColor.borderColor,
                                ),
                              ],
                              GropListTile(
                                onTap: selectGroup,
                                value: c.groupList[index],
                                isSelected:
                                    c.groupList[index].id.toString() ==
                                    selectedGroupId,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    AppButton(
                      label: 'Save',
                      backgroundColor: AppColor.primary,
                      onTap: () {
                        Navigator.of(context).pop(
                          c.groupList
                              .where((e) => e.id.toString() == selectedGroupId)
                              .firstOrNull,
                        );
                      },
                    ),
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
