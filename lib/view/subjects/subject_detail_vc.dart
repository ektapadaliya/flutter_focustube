import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/loader_cotroller.dart';
import 'package:focus_tube_flutter/model/sub_subject_model.dart';
import 'package:focus_tube_flutter/model/subject_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/get.dart';

class SubjectDetailVC extends StatefulWidget {
  final String subjectId;
  static const id = "/subject/:id";
  const SubjectDetailVC({super.key, required this.subjectId});

  @override
  State<SubjectDetailVC> createState() => _SubjectDetailVCState();
}

class _SubjectDetailVCState extends State<SubjectDetailVC> {
  SubjectModel? subjectModel;
  LoaderController loaderController = controller<LoaderController>(
    tag: "SubSubject",
  );
  PageController pageController = PageController();
  int get selectedIndex =>
      pageController.hasClients ? pageController.page?.toInt() ?? 0 : 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      loaderController.setLoading(true);
      var data = await ApiFunctions.instance.getSubject(
        context,
        subjectId: widget.subjectId,
      );
      if (data?.isNotEmpty ?? false) {
        subjectModel = data!.first;
        setState(() {});
      }
      loaderController.setLoading(false);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context, title: subjectModel?.title ?? ""),
        body: subjectModel != null
            ? SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  buildCategoryTile(index),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10),
                              itemCount: subjectModel!.subSubjects?.length ?? 0,
                            ),
                          ),
                          SizedBox(height: 20),
                          AppTitle(title: "Videos"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        itemCount: subjectModel!.subSubjects?.length ?? 0,
                        itemBuilder: (context, index) => SubjectVideoList(
                          subSubject: subjectModel!.subSubjects![index],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  buildCategoryTile(int index) {
    bool isSelected = index == selectedIndex;
    return InkWell(
      onTap: () {
        pageController.jumpToPage(index);
        setState(() {});
      },
      child: Container(
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
          subjectModel!.subSubjects![index].title ?? "",
          style: AppTextStyle.title16(
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ),
      ),
    );
  }
}

class SubjectVideoList extends StatefulWidget {
  const SubjectVideoList({super.key, required this.subSubject});
  final SubSubjectModel subSubject;
  @override
  State<SubjectVideoList> createState() => _SubjectVideoListState();
}

class _SubjectVideoListState extends State<SubjectVideoList>
    with AutomaticKeepAliveClientMixin {
  late VideoController videoController;
  String get classId => "sub-subject-${widget.subSubject.id}";
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    videoController = controller<VideoController>(tag: classId);
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callVideoListApi();
    });
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    videoController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    videoController.clear();
    callVideoListApi();
  }

  _scrollListener() async {
    if (!videoController.loaderController.isLoading.value &&
        videoController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callVideoListApi(page: videoController.page + 1);
        if (videoController.hasData) {
          videoController.incPage();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: classId,
      init: videoController,
      builder: (videoController) {
        return AppLoader(
          showLoader: videoController.videos.isEmpty,
          loaderController: videoController.loaderController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Obx(
              () => RefreshIndicator(
                onRefresh: onRefresh,
                child:
                    (videoController.videos.isEmpty &&
                        !(videoController.loaderController.isLoading.value))
                    ? ExpandedSingleChildScrollView(
                        physics: ClampingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "No videos found",
                            style: AppTextStyle.body16(color: AppColor.gray),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.separated(
                              physics: ClampingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              controller: scrollController,
                              itemBuilder: (context, index) => VideoTile(
                                video: videoController.videos[index],
                                onBookmark: (id) {
                                  videoController.changeBookmarkStatus(id);
                                  ApiFunctions.instance.bookmarkVideo(
                                    context,
                                    videoId: id,
                                  );
                                },
                              ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 15),
                              itemCount: videoController.videos.length,
                            ),
                          ),
                          if (videoController
                                  .loaderController
                                  .isLoading
                                  .value &&
                              videoController.videos.isNotEmpty)
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
        );
      },
    );
  }

  Future<void> callVideoListApi({int page = 1}) async {
    await ApiFunctions.instance.getVideos(
      context,
      controller: videoController,
      page: page,
      subSubjectId: widget.subSubject.id.toString(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
