import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:go_router/go_router.dart';

import '../../widget/app_button.dart';

class FeedbackVC extends StatefulWidget {
  const FeedbackVC({super.key});

  @override
  State<FeedbackVC> createState() => _FeedbackVCState();
}

class _FeedbackVCState extends State<FeedbackVC> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 450, minWidth: 350),
          margin: EdgeInsets.symmetric(horizontal: 30).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom == 0
                ? 30
                : MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Container(width: 35)),
                    Text("Feedback", style: AppTextStyle.title20()),
                    Expanded(child: Container(width: 10)),
                    InkWell(
                      onTap: context.pop,
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      child: Icon(
                        Icons.close,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Rate your experience", style: AppTextStyle.title24()),
                Text(
                  "Select one emotion that best describes your reaction.",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body18(color: AppColor.gray),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 25,
                  children: List.generate(
                    6,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            feedbackImage(index),
                            width: AppConst.maxWidth(context) < 450
                                ? AppConst.maxWidth(context) / 6
                                : 100,
                            colorFilter: selectedIndex == index
                                ? ColorFilter.mode(
                                    Colors.amberAccent.shade100,
                                    BlendMode.modulate,
                                  )
                                : null,
                          ),
                          Text(
                            feedbackTitle(index),
                            style: AppTextStyle.body20(),
                          ),
                          Text(
                            "${feedbackRating(index)}/10",
                            style: AppTextStyle.body12(color: AppColor.gray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AppButton(label: "Submit", backgroundColor: AppColor.primary),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String feedbackImage(int index) {
    return switch (index) {
      1 => AppImage.happy,
      2 => AppImage.cool,
      3 => AppImage.bored,
      4 => AppImage.unclear,
      5 => AppImage.horrible,
      _ => AppImage.loved,
    };
  }

  String feedbackTitle(int index) {
    return switch (index) {
      1 => "Happy",
      2 => "Cool",
      3 => "Bored",
      4 => "Unclear",
      5 => "Horrible",
      _ => "Loved",
    };
  }

  int feedbackRating(int index) {
    return switch (index) {
      1 => 8,
      2 => 6,
      3 => 4,
      4 => 3,
      5 => 0,
      _ => 10,
    };
  }
}
