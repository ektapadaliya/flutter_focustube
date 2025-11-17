import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class ChooseYourInterestVC extends StatefulWidget {
  static const id = "/choose-your-interest";
  static const editId = "/edit-your-interest";
  const ChooseYourInterestVC({super.key, this.isFromEdit = false});
  final bool isFromEdit;
  @override
  State<ChooseYourInterestVC> createState() => _ChooseYourInterestVCState();
}

class _ChooseYourInterestVCState extends State<ChooseYourInterestVC> {
  List<UserInterestModel> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: widget.isFromEdit
          ? customAppBar(context, title: "Choose My Interests")
          : null,
      body: ExpandedSingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (!widget.isFromEdit) ...[
              Text("Choose your Interests", style: AppTextStyle.title28()),
              Text(
                "Get personalized recommendations",
                style: AppTextStyle.body18(color: AppColor.gray),
              ),
              SizedBox(height: 20),
            ],

            Wrap(
              runSpacing: 20,
              spacing: 15,
              children: List.generate(AppConst.userInterests.length, (index) {
                var interest = AppConst.userInterests[index];
                var isSelected = selectedItems
                    .where((e) => e.id == interest.id)
                    .isNotEmpty;
                return InterestTile(
                  title: interest.title,
                  image: interest.image,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) {
                      selectedItems.removeWhere((e) => e.id == interest.id);
                    } else {
                      selectedItems.add(interest);
                    }
                    setState(() {});
                  },
                );
              }),
            ),
            SizedBox(height: 30),
            Expanded(child: Container()),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: AppButton(
                label: widget.isFromEdit ? "Save" : "Continue",
                backgroundColor: AppColor.primary,
                onTap: () {
                  if (widget.isFromEdit) {
                    context.pop();
                  } else {
                    dailyLimit.go(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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
