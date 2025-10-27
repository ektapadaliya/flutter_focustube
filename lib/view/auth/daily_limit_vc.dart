import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class DailyLimitVC extends StatefulWidget {
  static const id = "/daily-limit";
  static const editId = "$id/edit";

  const DailyLimitVC({super.key, this.isFromEdit = false});
  final bool isFromEdit;
  @override
  State<DailyLimitVC> createState() => _DailyLimitVCState();
}

class _DailyLimitVCState extends State<DailyLimitVC> {
  //int selectedVideo = 10;
  TextEditingController videoSelectionController = TextEditingController(
    text: "10",
  );
  List<int> videoSelectionOption = [10, 20, 50, 100, 200];
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Daily Limit"),
      body: ExpandedSingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 140,
                constraints: BoxConstraints(maxWidth: 390),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage(AppImage.videoLimitBackground),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: TextFormField(
                    autofocus: true,
                    controller: videoSelectionController,
                    expands: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyle.title40(color: AppColor.white),
                    cursorColor: AppColor.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter the maximum amount of videos you want to watch per day",
              style: AppTextStyle.title20(),
            ),
            // SizedBox(height: 70),
            // Wrap(
            //   runSpacing: 20,
            //   spacing: 20,
            //   alignment: WrapAlignment.center,
            //   children: List.generate(
            //     videoSelectionOption.length,
            //     (index) => VideoSelectionTile(
            //       onTap: () {
            //         selectedVideo = videoSelectionOption[index];
            //         setState(() {});
            //       },
            //       videos: videoSelectionOption[index],
            //       isSelected: selectedVideo == videoSelectionOption[index],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 50),
            // SizedBox(
            //   height: 30,
            //   child: SfSliderTheme(
            //     data: SfSliderThemeData(
            //       thumbRadius: 19,
            //       trackCornerRadius: 33,
            //       activeTrackHeight: 20,
            //       inactiveTrackHeight: 20,
            //       thumbColor: AppColor.primary,
            //       activeTrackColor: AppColor.primary,
            //       inactiveTrackColor: AppColor.lightGray.opacityToAlpha(.5),
            //       tooltipBackgroundColor: AppColor.primary,
            //       tooltipTextStyle: AppTextStyle.title28(color: AppColor.white),
            //     ),
            //     child: SfSlider(
            //       min: 10,
            //       max: 200,
            //       interval: 1,
            //       value: selectedVideo,
            //       enableTooltip: true,
            //       onChanged: (value) {
            //         selectedVideo = value.round();
            //         setState(() {});
            //       },
            //     ),
            //   ),
            // ),
            Expanded(child: Container()),
            SizedBox(height: 20),
            Text(
              "You can change this anytime in Settings.",
              style: AppTextStyle.body16(color: AppColor.gray),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: AppButton(
                label: widget.isFromEdit ? "Save" : "Continue",
                backgroundColor: AppColor.primary,
                onTap: () {
                  if (widget.isFromEdit) {
                    context.pop();
                  } else {
                    home.go(context);
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

class VideoSelectionTile extends StatelessWidget {
  const VideoSelectionTile({
    super.key,
    required this.onTap,
    required this.videos,
    required this.isSelected,
  });
  final int videos;
  final bool isSelected;
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
        child: Text.rich(
          TextSpan(
            text: "$videos",
            style: AppTextStyle.title24(
              color: isSelected ? AppColor.white : null,
            ),
            children: [
              TextSpan(
                text: " Videos",
                style: AppTextStyle.body16(
                  color: isSelected ? AppColor.white : null,
                ).copyWith(fontFeatures: [FontFeature.subscripts()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
