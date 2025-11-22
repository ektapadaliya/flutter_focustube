import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class SetDailyGoalVC extends StatefulWidget {
  static const id = "/set-daily-goal";
  final bool isFromNav;
  const SetDailyGoalVC({super.key, this.isFromNav = false});

  @override
  State<SetDailyGoalVC> createState() => _SetDailyGoalVCState();
}

class _SetDailyGoalVCState extends State<SetDailyGoalVC> {
  final goals = [
    GoalModel(title: "Math", count: 0),
    GoalModel(title: "Science", count: 0),
    GoalModel(title: "History", count: 0),
    GoalModel(title: "Language", count: 0),
  ];
  @override
  Widget build(BuildContext context) {
    var child = ExpandedSingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isFromNav ? 0 : 30,
      ).copyWith(top: widget.isFromNav ? 15 : 0),
      child: SafeArea(
        child: FormScreenBoundries(
          child: Column(
            children: [
              ...List.generate(goals.length, (index) {
                var goal = goals[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SetGoalTile(
                    goal: goal,
                    onCountChanged: (newCount) {
                      setState(() {
                        goals[index] = goal.copyWith(count: newCount);
                      });
                    },
                  ),
                );
              }),
              Spacer(),
              SizedBox(height: 20),
              AppButton(
                label: "Save Goals",
                onTap: () {
                  if (!widget.isFromNav) {
                    context.pop();
                  }
                },
                backgroundColor: AppColor.primary,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    if (widget.isFromNav) {
      return child;
    } else {
      return ScreenBackground(
        appBar: customAppBar(context, title: "Set Daily Goals"),
        body: child,
      );
    }
  }
}

class SetGoalTile extends StatelessWidget {
  const SetGoalTile({
    super.key,
    required this.goal,
    required this.onCountChanged,
  });
  final GoalModel goal;
  final void Function(int) onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.tileBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Text(goal.title, style: AppTextStyle.title16()),
          Spacer(),
          buildButton(Icons.add, () {
            onCountChanged(goal.count + 1);
          }, isDisabled: goal.count >= 10),
          SizedBox(
            width: 50,
            child: Text(
              goal.count.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyle.body16(),
            ),
          ),
          buildButton(Icons.remove, () {
            onCountChanged(goal.count - 1);
          }, isDisabled: goal.count <= 0),
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

class GoalModel {
  final String title;
  final int count;

  GoalModel({required this.title, required this.count});

  /// Create a copy with updated count
  GoalModel copyWith({String? title, int? count}) {
    return GoalModel(title: title ?? this.title, count: count ?? this.count);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {'title': title, 'count': count};

  /// Create from JSON
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(title: json['title'], count: json['count']);
  }
}
