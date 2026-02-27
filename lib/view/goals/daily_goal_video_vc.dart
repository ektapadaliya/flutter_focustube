import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';
import '../../controller/app_controller.dart';
import '../../model/daily_goal_video_list_model.dart';
import '../../widget/app_loader.dart';
import '../../widget/expandable_scollview.dart';
import '../../widget/video_widgets.dart';

class DailyGoalVideoVC extends StatefulWidget {
  const DailyGoalVideoVC({super.key});

  @override
  State<DailyGoalVideoVC> createState() => _DailyGoalVideoVCState();
}

class _DailyGoalVideoVCState extends State<DailyGoalVideoVC> {
  late DailyGoalVideoController goalVideoController;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    goalVideoController = controller<DailyGoalVideoController>();
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (!goalVideoController.loaderController.isLoading.value &&
        goalVideoController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: goalVideoController.page + 1);
        if (goalVideoController.hasData) {
          goalVideoController.incPage();
        }
      }
    }
  }

  callApi({int page = 1}) async {
    await ApiFunctions.instance.getDailyGoalVideo(context, page: page);
  }

  Future<void> onRefresh() async {
    goalVideoController.clear();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: goalVideoController,
      builder: (goalVideoController) {
        return AppLoader(
          showLoader: goalVideoController.subjectGoalVideos.isEmpty,
          loaderController: goalVideoController.loaderController,
          child: Column(
            children: [
              SizedBox(height: 20),
              if (goalVideoController.totalDailyGoal > 0)
                GoalProgress(
                  totalTargets: goalVideoController.totalDailyGoal,
                  completedTargets: goalVideoController.totalDailyCompletedGoal,
                ),
              Expanded(
                child: Obx(() {
                  var isLoading =
                      goalVideoController.loaderController.isLoading.value;
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child:
                        (goalVideoController.subjectGoalVideos.isEmpty &&
                            !isLoading)
                        ? ExpandedSingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "No videos found",
                                style: AppTextStyle.body16(
                                  color: AppColor.gray,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: goalVideoController
                                      .subjectGoalVideos
                                      .length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: GoalSubjects(
                                      dailyGoalVideoList: goalVideoController
                                          .subjectGoalVideos[index],
                                    ),
                                  ),
                                ),
                              ),
                              if (goalVideoController
                                      .loaderController
                                      .isLoading
                                      .value &&
                                  goalVideoController
                                      .subjectGoalVideos
                                      .isNotEmpty)
                                Container(
                                  height: 50,
                                  width: MediaQuery.sizeOf(context).width,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GoalSubjects extends StatelessWidget {
  const GoalSubjects({super.key, required this.dailyGoalVideoList});
  final DailyGoalVideoListModel dailyGoalVideoList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                dailyGoalVideoList.subjectTitle ?? "",
                style: AppTextStyle.title20(),
              ),
            ),
            Text(
              "${dailyGoalVideoList.totalDailyCompletedGoalBySubject}/${dailyGoalVideoList.dailyGoal} completed",
              style: AppTextStyle.body16(color: AppColor.gray),
            ),
          ],
        ),
        ...List.generate(
          dailyGoalVideoList.videos?.length ?? 0,
          (index) => Padding(
            padding: EdgeInsetsGeometry.only(top: 15),
            child: VideoTile(
              video: dailyGoalVideoList.videos![index],
              onVideoSeen: () =>
                  controller<DailyGoalVideoController>().setVideoSeen(
                    dailyGoalVideoList.subjectId ?? "",
                    dailyGoalVideoList.videos![index].id.toString(),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class GoalProgress extends StatelessWidget {
  const GoalProgress({
    super.key,
    required this.totalTargets,
    required this.completedTargets,
  }) : assert(
         completedTargets <= totalTargets,
         "Completed target must be less then or equal to total targets",
       );
  final int totalTargets, completedTargets;
  int get percentage => ((completedTargets * 100 / totalTargets) * 100).round();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Your progress",
            style: AppTextStyle.body12(color: AppColor.white),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Today's target",
                  style: AppTextStyle.title16(color: AppColor.white),
                ),
              ),
              Text(
                "$completedTargets/$totalTargets",
                style: AppTextStyle.title16(color: AppColor.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white.opacityToAlpha(.26),
              borderRadius: BorderRadius.circular(64),
            ),
            height: 14,
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: percentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(64),
                        ),
                      ),
                    ),
                    Expanded(flex: 10000 - percentage, child: Container()),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 14,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      totalTargets,
                      (index) => Container(
                        decoration: BoxDecoration(
                          color: (index + 1) <= completedTargets
                              ? AppColor.primary
                              : AppColor.white,
                          shape: BoxShape.circle,
                        ),
                        height: 4,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
