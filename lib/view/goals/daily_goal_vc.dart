import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/view/auth/daily_limit_vc.dart';
import 'package:focus_tube_flutter/view/goals/daily_goal_video_vc.dart';

import 'set_daily_goal_vc.dart';

class DailyGoalVC extends StatefulWidget {
  static const id = "/daily-goal";
  const DailyGoalVC({super.key});

  @override
  State<DailyGoalVC> createState() => _DailyGoalVCState();
}

class _DailyGoalVCState extends State<DailyGoalVC> {
  PageController pageController = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                SetDailyGoalVC(isFromNav: true),
                DailyGoalVideoVC(),
                DailyLimitVC(isFromGoal: true, isFromEdit: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildCategoryTile(int index) {
    bool isSelected =
        (pageController.hasClients ? (pageController.page ?? 1) : 1) == index;
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
      0 => "Set Daily Goals",
      1 => "Daily Goals",
      2 => "Set Daily Limit",

      //4 => "Select Channels",
      _ => "",
    };
  }
}
