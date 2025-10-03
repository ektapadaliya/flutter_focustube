import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ChooseYourInterestVC extends StatefulWidget {
  static const id = "/choose-your-Interest";
  const ChooseYourInterestVC({super.key});

  @override
  State<ChooseYourInterestVC> createState() => _ChooseYourInterestVCState();
}

class _ChooseYourInterestVCState extends State<ChooseYourInterestVC> {
  List<int> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      isInSafeArea: false,
      body: ExpandedSingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Choose your Interests", style: AppTextStyle.title28()),
            Text(
              "Get better recommendations",
              style: AppTextStyle.body18(color: AppColor.gray),
            ),
            SizedBox(height: 20),
            Wrap(
              runSpacing: 20,
              spacing: 15,
              children: List.generate(12, (index) {
                var isSelected = selectedItems.contains(index);
                return InterestTile(
                  title: interentTitle(index),
                  image: interentImage(index),
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) {
                      selectedItems.remove(index);
                    } else {
                      selectedItems.add(index);
                    }
                    setState(() {});
                  },
                );
              }),
            ),
            SizedBox(height: 30),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: AppButton(
                label: "Continue",
                backgroundColor: AppColor.primary,
                onTap: () {
                  dailyLimit.go(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String interentImage(int index) {
    return switch (index) {
      0 => AppImage.history,
      1 => AppImage.mathematics,
      2 => AppImage.fashionStyle,
      3 => AppImage.reading,
      4 => AppImage.careerDevelopment,
      5 => AppImage.art,
      6 => AppImage.mindfullnessMeditation,
      7 => AppImage.scienceTechnology,
      8 => AppImage.music,
      9 => AppImage.selfImprovement,
      10 => AppImage.productivity,
      11 => AppImage.businessFinance,
      _ => "",
    };
  }

  String interentTitle(int index) {
    return switch (index) {
      0 => "History",
      1 => "Mathematics",
      2 => "Fashion & Style",
      3 => "Reading",
      4 => "Career Development",
      5 => "Art",
      6 => "Mindfulness & Meditation",
      7 => "Science & Technology",
      8 => "Music",
      9 => "Self-Improvement",
      10 => "Productivity",
      11 => "Business & Finance",
      _ => "",
    };
  }
}

class InterestTile extends StatelessWidget {
  const InterestTile({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });
  final bool isSelected;
  final String title, image;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.lightGray,
          ),
          borderRadius: BorderRadius.circular(33),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              image,
              height: 23,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColor.white : AppColor.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyle.body16(
                color: isSelected ? AppColor.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
