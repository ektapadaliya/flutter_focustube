import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'checkbox_tile.dart';

enum PlayListTileType { normal, selection, edit }

class PlayListTile extends StatelessWidget {
  const PlayListTile({
    super.key,
    this.selectedValue,
    required this.onTap,
    required this.value,
    this.tileType = PlayListTileType.normal,
  });
  final int value;
  final int? selectedValue;
  final PlayListTileType tileType;
  final void Function(int? index) onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: tileType == PlayListTileType.edit ? null : () => onTap(value),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.borderColor),
          borderRadius: BorderRadius.circular(
            tileType == PlayListTileType.edit ? 6 : 20,
          ),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PlayList ${value + 1}", style: AppTextStyle.title20()),
                  Text(
                    "${value + 1} videos",
                    style: AppTextStyle.body14(color: AppColor.gray),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: tileType == PlayListTileType.selection
                  ? AppRadioButton(
                      value: value,
                      innerPadding: 4,
                      size: 25,
                      groupValue: selectedValue,
                      onChanged: onTap,
                    )
                  : tileType == PlayListTileType.edit
                  ? InkWell(
                      onTap: () => onTap(value),
                      child: SvgPicture.asset(AppImage.editIcon, height: 20),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: AppColor.primary,
                      size: 20,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
