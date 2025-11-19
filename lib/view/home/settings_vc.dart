import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/general_dialog.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

import '../../widget/app_button.dart';

class SettingsVC extends StatefulWidget {
  static const id = "/settings";
  const SettingsVC({super.key});

  @override
  State<SettingsVC> createState() => _SettingsVCState();
}

class _SettingsVCState extends State<SettingsVC> {
  bool isNotificationOn = false;
  @override
  Widget build(BuildContext context) {
    return ExpandedSingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: FormScreenBoundries(
        child: Column(
          children: [
            SettingsTile(
              icon: AppImage.userIcon,
              label: "My Profile",
              onTap: () => profile.go(context),
            ),
            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.notificationIcon,
              label: "Notifications",
              isSelected: isNotificationOn,
              onTap: () {
                isNotificationOn = !isNotificationOn;
                setState(() {});
              },
            ),
            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.historyIcon,
              label: "My History",
              onTap: () {
                videos.go(context, extra: "My History");
              },
            ),
            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.channels,
              label: "Select Channels",
              onTap: () {
                selectChannels.go(context);
              },
              iconSize: 32,
            ),

            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.subjectIcon,
              label: "Select Subjects",
              onTap: () {
                selectSubjects.go(context);
              },
            ),
            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.targetIcon,
              label: "Set Daily Goals",
              onTap: () {
                setDailyGoal.go(context);
              },
            ),
            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.limitIcon,
              label: "Set Daily Limits",
              onTap: () {
                editDailyLimit.go(context);
              },
            ),
            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.userIntrestIcon,
              label: "Choose My Interests",
              iconSize: 20,
              onTap: () {
                editYourInterest.go(context);
              },
            ),

            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.privacyPolicyIcon,
              label: "Privacy & Legal",
              iconSize: 20,
              onTap: () {
                content.go(context, id: 'p');
              },
            ),

            SizedBox(height: 15),
            SettingsTile(
              icon: AppImage.termsConditionsIcon,
              iconSize: 20,
              label: "Terms of Service",
              onTap: () {
                content.go(context, id: 't');
              },
            ),
            SizedBox(height: 30),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                generalDialog(
                  context,
                  title: "Logout",
                  message: "Are you sure you want to log out?",
                  submitText: "Logout",
                  onSubmit: () {},
                );
              },
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              child: Text("Logout", style: AppTextStyle.title16()),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                generalDialog(
                  context,
                  title: "Delete account",
                  message: "Are you sure you want to Delete your account?",
                  submitText: "Delete",
                  submitColor: AppColor.red,
                  onSubmit: () {},
                );
              },
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              child: Text(
                "Delete account",
                style: AppTextStyle.title16(color: AppColor.red),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    this.onTap,
    this.iconSize = 18,
    this.isSelected,
    required this.icon,
    required this.label,
  });
  final String icon, label;
  final double iconSize;
  final bool? isSelected;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.tileBackground,
          border: Border.all(color: AppColor.borderColor),
          borderRadius: BorderRadius.circular(56),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.lightGray.opacityToAlpha(.25),
              child: (icon.split(".").last == "svg")
                  ? SvgPicture.asset(
                      icon,
                      height: iconSize,
                      colorFilter: ColorFilter.mode(
                        AppColor.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  : Image.asset(
                      icon,
                      height: iconSize,
                      color: AppColor.primary,
                      colorBlendMode: BlendMode.srcIn,
                    ),
            ),
            SizedBox(width: 10),
            Expanded(child: Text(label, style: AppTextStyle.title16())),
            SizedBox(width: 10),
            if (isSelected == null)
              Icon(Icons.arrow_forward_ios, color: AppColor.primary, size: 20)
            else
              AppSwitch(
                isSelected: isSelected!,
                onChanged: (_) => onTap?.call(),
              ),
          ],
        ),
      ),
    );
  }
}
