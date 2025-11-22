import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/view/auth/daily_limit_vc.dart';

import 'package:focus_tube_flutter/widget/video_widgets.dart';

import 'set_daily_goal_vc.dart';

class DailyGoalVC extends StatefulWidget {
  static const id = "/daily-goal";
  const DailyGoalVC({super.key});

  @override
  State<DailyGoalVC> createState() => _DailyGoalVCState();
}

class _DailyGoalVCState extends State<DailyGoalVC> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    /* ScreenBackground(
      appBar: customAppBar(
        context,
        title: "Daily Goals",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                setDailyGoal.go(context);
              },
              child: Icon(Icons.add, size: 25, color: AppColor.primary),
            ),
          ),
        ],
      ),
      body: */

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => buildCategoryTile(index),
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemCount: 3,
            ),
          ),
          if (selectedIndex == 0)
            Expanded(child: SetDailyGoalVC(isFromNav: true))
          else if (selectedIndex == 1)
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  GoalProgress(totalTargets: 3, completedTargets: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GoalSubjects(
                          title: "Subject",
                          totalTargets: 2,
                          completedTargets: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(child: DailyLimitVC(isFromGoal: true, isFromEdit: true)),
        ],
      ),
    );
  }

  buildCategoryTile(int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        selectedIndex = index;
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
      0 => "Set Daily Goals",
      1 => "Daily Goals",
      2 => "Set Daily Limit",

      //4 => "Select Channels",
      _ => "",
    };
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
