import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/controller/subject_video_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/view/subjects/select_subject_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/state_manager.dart';

import '../../const/app_text_style.dart';
import '../../controller/app_controller.dart';

class SubjectVC extends StatefulWidget {
  static const id = "/subjects";
  static const mySubjectId = "/my-subjects";
  final bool isMySubjects, isFromNav;
  const SubjectVC({
    super.key,
    this.isMySubjects = false,
    this.isFromNav = false,
  });

  @override
  State<SubjectVC> createState() => _SubjectVCState();
}

class _SubjectVCState extends State<SubjectVC> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  int get selectedIndex =>
      pageController.hasClients ? (pageController.page ?? 0).toInt() : 0;

  @override
  Widget build(BuildContext context) {
    var child = SafeArea(
      minimum: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: widget.isMySubjects ? 15 : 0,
      ),
      child: Column(
        children: [
          if (!widget.isMySubjects)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => buildCategoryTile(index),
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemCount: 3,
              ),
            ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SelectSubjectVC(isFromNav: true),
                ),
                SubjectVideoVC(tag: "my-subject"),
                SubjectVideoVC(tag: "subject"),
              ],
            ),
          ),
        ],
      ),
    );
    if (widget.isFromNav) {
      return ScreenBackground(
        appBar: customAppBar(
          context,
          title: (widget.isMySubjects || selectedIndex == 1)
              ? "My Subjects"
              : "Subjects",
        ),
        body: child,
      );
    } else {
      return child;
    }
  }

  buildCategoryTile(int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        pageController.jumpToPage(index);
        // Scrollable.ensureVisible(
        //   itemKeys[index].currentContext!,
        //   duration: const Duration(milliseconds: 300),
        //   alignment: .5, // 0.0 = left, 1.0 = right, 0.5 = center
        //   curve: Curves.easeInOut,
        // );
        setState(() {});
      },
      child: Container(
        //key: itemKeys[index],
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? AppColor.primary : null,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.gray,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _channelsType(index),
          style: AppTextStyle.title16(
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ),
      ),
    );
  }

  _channelsType(int index) {
    return switch (index) {
      // 0 => "Channels",
      0 => "Select Subject",
      1 => "My Subjects",
      2 => "Subjects",

      //4 => "Select Channels",
      _ => "",
    };
  }
}

class SubjectVideoVC extends StatefulWidget {
  final String tag;

  const SubjectVideoVC({super.key, required this.tag});

  @override
  State<SubjectVideoVC> createState() => _SubjectVideoVCState();
}

class _SubjectVideoVCState extends State<SubjectVideoVC>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  late SubjectVideoController subjectVideoCtrl;

  @override
  void initState() {
    subjectVideoCtrl = controller<SubjectVideoController>(tag: widget.tag);
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    subjectVideoCtrl.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    subjectVideoCtrl.clear();
    callApi();
  }

  _scrollListener() async {
    if (!subjectVideoCtrl.loaderController.isLoading.value &&
        subjectVideoCtrl.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: subjectVideoCtrl.page + 1);
        if (subjectVideoCtrl.hasData) {
          subjectVideoCtrl.incPage();
        }
      }
    }
  }

  Future<void> callApi({int page = 1}) async {
    if (widget.tag == "subject") {
      await ApiFunctions.instance.getSubjectVideos(
        context,
        controller: subjectVideoCtrl,
        page: page,
      );
    } else {
      await ApiFunctions.instance.getMySubjectVideos(
        context,
        controller: subjectVideoCtrl,
        page: page,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: widget.tag,
      init: subjectVideoCtrl,
      builder: (subjectVideoCtrl) {
        return AppLoader(
          overlayColor: Colors.transparent,
          showLoader: subjectVideoCtrl.subjects.isEmpty,
          loaderController: subjectVideoCtrl.loaderController,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child:
                  (subjectVideoCtrl.subjects.isEmpty &&
                      !(subjectVideoCtrl.loaderController.isLoading.value))
                  ? ExpandedSingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "No videos found",
                          style: AppTextStyle.body16(color: AppColor.gray),
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: subjectVideoCtrl.subjects.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 30),
                      itemBuilder: (context, index) {
                        final subject = subjectVideoCtrl.subjects[index];

                        return SizedBox(
                          height: 230,
                          child: Column(
                            children: [
                              AppTitle(
                                title: subject.title ?? "",
                                onViewMore: () {
                                  subjectsDetail.go(
                                    context,
                                    id: subject.id ?? "",
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subject.videos?.length ?? 0,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 15),
                                  itemBuilder: (context, index) {
                                    return SubjectVideoTile(
                                      video: subject.videos![index],
                                      onBookmark: (id) {
                                        subjectVideoCtrl.changeBookmarkStatus(
                                          subject.id.toString(),
                                          id,
                                        );
                                        ApiFunctions.instance.bookmarkVideo(
                                          context,
                                          videoId: id,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
