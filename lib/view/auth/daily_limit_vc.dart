import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/loader_cotroller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class DailyLimitVC extends StatefulWidget {
  static const id = "/daily-limit";
  static const editId = "$id/edit";

  const DailyLimitVC({
    super.key,
    this.isFromEdit = false,
    this.isFromGoal = false,
  });
  final bool isFromEdit, isFromGoal;
  @override
  State<DailyLimitVC> createState() => _DailyLimitVCState();
}

class _DailyLimitVCState extends State<DailyLimitVC> {
  var userController = controller<UserController>();
  late final TextEditingController videoSelectionController;
  late final TextEditingController videoMinuteController;
  LoaderController loaderController = controller<LoaderController>(
    tag: "/daily-limit",
  );

  bool countLimitEnabled = true;
  bool minuteLimitEnabled = true;

  @override
  void initState() {
    videoSelectionController = TextEditingController(
      text: userController.user?.preference?.dailyVideoLimit ?? "10",
    );
    videoMinuteController = TextEditingController(
      text: userController.user?.preference?.dailyVideoTimeLimit ?? "50",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var child = ExpandedSingleChildScrollView(
      padding: widget.isFromGoal
          ? const EdgeInsets.only(top: 20)
          : const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Container(
        constraints: BoxConstraints(maxWidth: 450),
        child: Column(
          children: [
            LimitCard(
              title: "Video Count Limit",
              subtitle: "Limit how many videos you can watch per day",
              isEnabled: countLimitEnabled,
              onToggle: (value) {
                setState(() {
                  countLimitEnabled = value;
                });
              },
              controller: videoSelectionController,
              backgroundImage: AppImage.videoLimitBackground,
            ),
            SizedBox(height: 20),
            LimitCard(
              title: "Video Time Limit",
              subtitle: "Limit how much time you can spend watching videos",
              isEnabled: minuteLimitEnabled,
              onToggle: (value) {
                setState(() {
                  minuteLimitEnabled = value;
                });
              },
              controller: videoMinuteController,
              backgroundImage: AppImage.videoLimitBackground,
            ),

            // Column(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         border: Border.all(color: AppColor.borderColor, width: 1),
            //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            //       ),
            //       padding: EdgeInsets.all(16),

            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "Video Count Limit",
            //                   style: AppTextStyle.title16(),
            //                 ),
            //                 Text(
            //                   "Limit how many videos you can watch per day",
            //                   style: AppTextStyle.body12(color: AppColor.gray),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           AppSwitch(onChanged: (value) {}, isSelected: true),
            //         ],
            //       ),
            //     ),

            //     Container(
            //       height: 140,
            //       constraints: BoxConstraints(maxWidth: 390),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.vertical(
            //           bottom: Radius.circular(24),
            //         ),
            //         image: DecorationImage(
            //           image: AssetImage(AppImage.videoLimitBackground),
            //           fit: BoxFit.fill,
            //         ),
            //       ),
            //       alignment: Alignment.center,
            //       //     child: Center(
            //       child: TextFormField(
            //         autofocus: true,
            //         controller: videoSelectionController,
            //         expands: false,
            //         keyboardType: TextInputType.number,
            //         textInputAction: TextInputAction.done,
            //         textAlign: TextAlign.center,
            //         decoration: InputDecoration(
            //           border: InputBorder.none,
            //           isDense: true,
            //         ),
            //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //         style: AppTextStyle.title40(color: AppColor.white),
            //         cursorColor: AppColor.white,
            //       ),
            //     ),
            //   ],
            // ),

            // Center(
            //   child: Container(
            //     height: 140,
            //     constraints: BoxConstraints(maxWidth: 390),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(24),
            //       image: DecorationImage(
            //         image: AssetImage(AppImage.videoLimitBackground),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //     alignment: Alignment.center,
            //     child: Center(
            //       child: TextFormField(
            //         autofocus: true,
            //         controller: videoSelectionController,
            //         expands: false,
            //         keyboardType: TextInputType.number,
            //         textInputAction: TextInputAction.done,
            //         textAlign: TextAlign.center,
            //         decoration: InputDecoration(
            //           border: InputBorder.none,
            //           isDense: true,
            //         ),
            //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //         style: AppTextStyle.title40(color: AppColor.white),
            //         cursorColor: AppColor.white,
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(child: Container()),
            SizedBox(height: 20),
            Text(
              "Enter the maximum number of videos or minutes you want to watch each day.",
              style: AppTextStyle.title20(),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),
            Text(
              "You can change this anytime in Settings.",
              style: AppTextStyle.body16(color: AppColor.gray),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.isFromGoal ? 15 : 30,
              ),
              child: AppButton(
                label: widget.isFromEdit ? "Save" : "Continue",
                backgroundColor: AppColor.primary,
                onTap: updateLimit,
              ),
            ),
          ],
        ),
      ),
    );
    return AppLoader(
      loaderController: loaderController,
      child: widget.isFromGoal
          ? child
          : ScreenBackground(
              appBar: customAppBar(
                context,
                title: widget.isFromEdit
                    ? "Edit Daily Limit"
                    : "Set Daily Limit",
              ),
              body: child,
            ),
    );
  }

  void updateLimit() async {
    if (videoSelectionController.text.isEmpty) {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Please enter daily limit",
        isError: true,
      );
      return;
    } else if (int.tryParse(videoSelectionController.text) == null) {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Please enter valid daily limit",
        isError: true,
      );
      return;
    }
    if (videoMinuteController.text.isEmpty) {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Please enter daily time limit",
        isError: true,
      );
      return;
    } else if (int.tryParse(videoMinuteController.text) == null) {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Please enter valid daily time limit",
        isError: true,
      );
      return;
    } else {
      loaderController.setLoading(true);
      bool isUpdated = await ApiFunctions.instance.updateDailyLimit(
        context,
        videoLimit: int.parse(videoSelectionController.text),
        timeLimit: int.parse(videoMinuteController.text),
      );
      loaderController.setLoading(false);
      if (isUpdated && (!widget.isFromGoal)) {
        if (widget.isFromEdit) {
          context.pop();
        } else {
          home.off(context);
        }
      }
    }
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
    return AppInkWell(
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

class LimitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  final TextEditingController controller;
  final String backgroundImage;

  const LimitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    required this.onToggle,
    required this.controller,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Top Section (Header)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.borderColor, width: 1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              /// Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.title16()),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyle.body12(color: AppColor.gray),
                    ),
                  ],
                ),
              ),

              /// Toggle
              //AppSwitch(onChanged: onToggle, isSelected: isEnabled),
            ],
          ),
        ),

        /// Bottom Section (Input)
        Container(
          height: 140,

          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: TextFormField(
            controller: controller,
            enabled: isEnabled, // 🔥 disables input when off
            autofocus: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyle.title40(color: AppColor.white),
            cursorColor: AppColor.white,
          ),
        ),
      ],
    );
  }
}
