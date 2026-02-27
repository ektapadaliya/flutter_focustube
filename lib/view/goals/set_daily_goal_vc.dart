import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/daily_goal_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SetDailyGoalVC extends StatefulWidget {
  static const id = "/set-daily-goal";
  final bool isFromNav;
  const SetDailyGoalVC({super.key, this.isFromNav = false});

  @override
  State<SetDailyGoalVC> createState() => _SetDailyGoalVCState();
}

class _SetDailyGoalVCState extends State<SetDailyGoalVC> {
  late DailyGoalController goalController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    goalController = controller<DailyGoalController>();
    super.initState();
    Future.delayed(Duration.zero, () async {
      goalController.clearNewGoal();
      if (goalController.goals.isEmpty) {
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

  Future<void> onRefresh() async {
    goalController.clear();
    callApi();
  }

  _scrollListener() async {
    if (!goalController.loaderController.isLoading.value &&
        goalController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: goalController.page + 1);
        if (goalController.hasData) {
          goalController.incPage();
        }
      }
    }
  }

  Future<void> callApi({int page = 1}) async {
    await ApiFunctions.instance.getDailyGoal(context, page: page);
  }

  bool isUpdate = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: goalController,
      builder: (goalController) {
        return AppLoader(
          showLoader: goalController.goals.isEmpty || isUpdate,
          loaderController: goalController.loaderController,
          child: (widget.isFromNav)
              ? child(goalController)
              : ScreenBackground(
                  appBar: customAppBar(context, title: "Set Daily Goals"),
                  body: child(goalController),
                ),
        );
      },
    );
  }

  Widget child(DailyGoalController goalController) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(
        horizontal: widget.isFromNav ? 0 : 30,
      ).copyWith(top: widget.isFromNav ? 15 : 0),
      child: FormScreenBoundries(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: onRefresh,
            child:
                (goalController.goals.isEmpty &&
                    !(goalController.loaderController.isLoading.value))
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
                : Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: goalController.goals.length,
                                itemBuilder: (context, index) {
                                  var goal = goalController.goals[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: SetGoalTile(
                                      goal: goal,
                                      goalController: goalController,
                                      onCountChanged: (newCount) {
                                        goalController.addNewGoal(
                                          goal.id ?? 0,
                                          newCount.toString(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),

                            if (!isUpdate &&
                                goalController
                                    .loaderController
                                    .isLoading
                                    .value &&
                                goalController.goals.isNotEmpty)
                              Container(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                      if (goalController.goals.isNotEmpty) ...[
                        SizedBox(height: 20),
                        AppButton(
                          label: "Save Goals",
                          onTap: () async {
                            setState(() {
                              isUpdate = true;
                            });
                            goalController.setIsLoading(true);
                            await ApiFunctions.instance.setDailyGoal(context);
                            goalController.setIsLoading(false);
                            setState(() {
                              isUpdate = false;
                            });
                            if (!widget.isFromNav) {
                              context.pop();
                            }
                          },
                          backgroundColor: AppColor.primary,
                        ),
                        if (!widget.isFromNav) SizedBox(height: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SetGoalTile extends StatelessWidget {
  const SetGoalTile({
    super.key,
    required this.goal,
    required this.onCountChanged,
    required this.goalController,
  });
  final DailyGoalModel goal;
  final void Function(int) onCountChanged;
  final DailyGoalController goalController;
  @override
  Widget build(BuildContext context) {
    var count =
        int.tryParse(
          goalController.newGoals
                  .firstWhereOrNull((e) => e.id == goal.id)
                  ?.dailyGoal ??
              goal.dailyGoal ??
              "0",
        ) ??
        0;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.tileBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Text(goal.title ?? "", style: AppTextStyle.title16()),
          ),

          buildButton(Icons.add, () {
            onCountChanged(count + 1);
          }, isDisabled: false),
          SizedBox(
            width: 50,
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyle.body16(),
            ),
          ),
          buildButton(Icons.remove, () {
            onCountChanged(count - 1);
          }, isDisabled: count <= 0),
        ],
      ),
    );
  }

  buildButton(IconData icon, void Function() onTap, {bool isDisabled = false}) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDisabled ? AppColor.lightGray : AppColor.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: isDisabled ? AppColor.primary : AppColor.white,
        ),
      ),
    );
  }
}
