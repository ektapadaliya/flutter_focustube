import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/model/channel_group_model.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'checkbox_tile.dart';

class GropListTile extends StatelessWidget {
  const GropListTile({
    super.key,
    this.isSelected = false,
    required this.onTap,
    required this.value,
  });
  final GroupModel value;
  final bool isSelected;
  final void Function(GroupModel group) onTap;
  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: () => onTap(value),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.borderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value.title ?? "", style: AppTextStyle.title20()),
                  Text(
                    "${value.totalChannels ?? 0} channels",
                    style: AppTextStyle.body14(color: AppColor.gray),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: AppCheckBoxButton(
                isSelected: isSelected,
                onChanged: (isSelected) => onTap(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
