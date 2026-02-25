import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/model/note_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widget/app_loader.dart';

class NoteListVC extends StatefulWidget {
  static const id = "/notes";
  const NoteListVC({super.key, required this.videoId});
  final String videoId;
  @override
  State<NoteListVC> createState() => _NoteListVCState();
}

class _NoteListVCState extends State<NoteListVC> {
  late NoteController noteController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    noteController = controller<NoteController>();
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  Future<void> callApi({int page = 1}) async {
    await ApiFunctions.instance.noteList(
      context,
      page: page,
      videoId: widget.videoId,
      controller: noteController,
    );
  }

  _scrollListener() async {
    if (!noteController.loaderController.isLoading.value &&
        noteController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: noteController.page + 1);
        if (noteController.hasData) {
          noteController.incPage();
        }
      }
    }
  }

  Future<void> onRefresh() async {
    noteController.clear();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: noteController,
      builder: (noteController) {
        return AppLoader(
          showLoader: noteController.notes.isEmpty,
          loaderController: noteController.loaderController,
          child: ScreenBackground(
            appBar: customAppBar(context, title: "Timestamped Notes"),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                addNote.go(context, id: widget.videoId);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(100),
                side: BorderSide(color: AppColor.primary),
              ),
              backgroundColor: AppColor.primary,
              child: Icon(Icons.add, size: 25, color: AppColor.white),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Obx(() {
                final isLoading =
                    noteController.loaderController.isLoading.value;
                return RefreshIndicator(
                  onRefresh: onRefresh,
                  child: (noteController.notes.isEmpty && !isLoading)
                      ? ExpandedSingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No notes found",
                              style: AppTextStyle.body16(color: AppColor.gray),
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) =>
                              NoteTile(note: noteController.notes[index]),
                          separatorBuilder: (context, index) => Divider(
                            color: AppColor.primary.opacityToAlpha(.3),
                            height: 25,
                          ),
                          itemCount: noteController.notes.length,
                        ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note});
  final NoteModel note;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        detailsNote.go(context, id: note.id.toString());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(note.title ?? "", style: AppTextStyle.title20()),
              ),
              SizedBox(width: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppImage.calendarIcon),
                  SizedBox(width: 3),
                  Text(
                    DateFormat("dd MMM, yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(note.createdAt!),
                    ),
                    style: AppTextStyle.body12(color: AppColor.gray),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3),
          Text(
            note.description ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.body14(color: AppColor.gray),
          ),
        ],
      ),
    );
  }
}
