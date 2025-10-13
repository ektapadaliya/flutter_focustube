import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';

class SettingsVC extends StatefulWidget {
  static const id = "/settings";
  const SettingsVC({super.key});

  @override
  State<SettingsVC> createState() => _SettingsVCState();
}

class _SettingsVCState extends State<SettingsVC> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [SettingsTile(icon: AppImage.userIcon, label: "Profile")],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected,
  });
  final bool? isSelected;
  final String icon, label;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.tileBackground,
        border: Border.all(color: AppColor.borderColor),
        borderRadius: BorderRadius.circular(56),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColor.lightGray,
            child: SvgPicture.asset(
              icon,
              height: 18,
              colorFilter: ColorFilter.mode(AppColor.primary, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(label, style: AppTextStyle.title16())),
          SizedBox(width: 10),
          if (isSelected == null)
            Icon(Icons.arrow_forward_ios, color: AppColor.primary, size: 20),
        ],
      ),
    );
  }
}
