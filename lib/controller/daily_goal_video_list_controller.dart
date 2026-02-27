import '../model/daily_goal_video_list_model.dart';
import 'package:get/get.dart';
import 'app_controller.dart';

class DailyGoalVideoController extends GetxController {
  static final List<DailyGoalVideoListModel> _subjectGoalVideos = [];
  List<DailyGoalVideoListModel> subjectGoalVideos = _subjectGoalVideos;

  void addGoalVideos(List<DailyGoalVideoListModel> goals) {
    for (var element in goals) {
      addGoalVideo(element);
    }
  }

  void addGoalVideo(DailyGoalVideoListModel goal) {
    var index = _subjectGoalVideos.indexWhere((e) => e.id == goal.id);
    if (index == -1) {
      _subjectGoalVideos.add(goal);
    } else {
      _subjectGoalVideos[index] = goal;
    }
    update();
  }

  void setVideoSeen(String subjectId, String videoId) {
    var sIndex = subjectGoalVideos.indexWhere((e) => e.subjectId == subjectId);
    if (sIndex != -1) {
      subjectGoalVideos[sIndex].videos?.removeWhere(
        (e) => e.id.toString() == videoId,
      );
      _subjectGoalVideos[sIndex].totalDailyCompletedGoalBySubject =
          (_subjectGoalVideos[sIndex].totalDailyCompletedGoalBySubject ?? 0) +
          1;
      _totalDailyCompletedGoal += 1;
      update();
    }
  }

  LoaderController get loaderController =>
      controller<LoaderController>(tag: "daily-goal--video-list");
  void setIsLoading(bool isLoading) {
    controller<LoaderController>(
      tag: "daily-goal--video-list",
    ).setLoading(isLoading);
  }

  static bool _hasData = true;
  bool get hasData => _hasData;

  static int _totalDailyGoal = 0;
  int get totalDailyGoal => _totalDailyGoal;

  void setTotalDailyGoal(int totalDailyGoal, int totalDailyCompletedGoal) {
    _totalDailyGoal = totalDailyGoal;
    _totalDailyCompletedGoal = totalDailyCompletedGoal;
    update();
  }

  static int _totalDailyCompletedGoal = 0;
  int get totalDailyCompletedGoal => _totalDailyCompletedGoal;

  void setHasData(bool hasData) {
    _hasData = hasData;
    update();
  }

  static int _page = 1;
  int get page => _page;

  void incPage() {
    _page++;
    update();
  }

  void clear() {
    _subjectGoalVideos.clear();
    _page = 1;
    _hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
