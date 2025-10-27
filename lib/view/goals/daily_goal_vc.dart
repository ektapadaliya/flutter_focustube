import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class DailyGoalVC extends StatefulWidget {
  static const id = "/daily-goal";
  const DailyGoalVC({super.key});

  @override
  State<DailyGoalVC> createState() => _DailyGoalVCState();
}

class _DailyGoalVCState extends State<DailyGoalVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Daily Goals"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          children: [
            GoalProgress(totalTargets: 3, completedTargets: 2),
            ...List.generate(
              2,
              (index) => Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GoalSubjects(
                  title: "Subject",
                  totalTargets: 2,
                  completedTargets: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalSubjects extends StatelessWidget {
  const GoalSubjects({
    super.key,
    required this.title,
    required this.totalTargets,
    required this.completedTargets,
  });
  final String title;
  final int totalTargets, completedTargets;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyle.title20())),
            Text(
              "$completedTargets/$totalTargets completed",
              style: AppTextStyle.body16(color: AppColor.gray),
            ),
          ],
        ),
        ...List.generate(
          totalTargets,
          (index) => Padding(
            padding: EdgeInsetsGeometry.only(top: 15),
            child: VideoTile(),
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
