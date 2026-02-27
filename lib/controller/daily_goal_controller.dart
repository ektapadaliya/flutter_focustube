import 'package:get/get.dart';
import '../model/daily_goal_model.dart';
import 'app_controller.dart';

class DailyGoalController extends GetxController {
  static final List<DailyGoalModel> _goals = [];
  List<DailyGoalModel> goals = _goals;

  static final List<DailyGoalModel> _newGoals = [];
  List<DailyGoalModel> newGoals = _newGoals;

  void addGoals(List<DailyGoalModel> goals) {
    for (var element in goals) {
      addGoal(element);
    }
  }

  void addGoal(DailyGoalModel goal) {
    var index = _goals.indexWhere((e) => e.id == goal.id);
    if (index == -1) {
      _goals.add(goal);
    } else {
      _goals[index] = goal;
    }
    update();
  }

  void addNewGoal(int id, String count) {
    var index = newGoals.indexWhere((e) => e.id == id);
    var goalIndex = goals.indexWhere((e) => e.id == id);

    if (count ==
        ((goals[goalIndex].dailyGoal ?? "0").trim().isEmpty
            ? "0"
            : (goals[goalIndex].dailyGoal ?? "0"))) {
      _newGoals.removeWhere((e) => e.id == id);
    } else if (index == -1) {
      DailyGoalModel goal = DailyGoalModel.fromJson(goals[goalIndex].toJson());
      _newGoals.add(goal..dailyGoal = count);
    } else {
      _newGoals[index].dailyGoal = count;
    }

    update();
  }

  void setNewGoalInGoal() {
    for (var element in newGoals) {
      var index = goals.indexWhere((e) => e.id == element.id);
      if (index != -1) {
        _goals[index] = element;
      }
    }
    clearNewGoal();
  }

  LoaderController get loaderController =>
      controller<LoaderController>(tag: "daily-goal-list");
  void setIsLoading(bool isLoading) {
    controller<LoaderController>(tag: "daily-goal-list").setLoading(isLoading);
  }

  static bool _hasData = true;
  bool get hasData => _hasData;

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

  void clearNewGoal() {
    _newGoals.clear();
    update();
  }

  void clear() {
    _newGoals.clear();
    _goals.clear();
    _page = 1;
    _hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
