import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/model/playlist_model.dart';
import 'checkbox_tile.dart';

enum PlayListTileType { normal, selection, edit }

class PlayListTile extends StatelessWidget {
  const PlayListTile({
    super.key,
    this.isSelected = false,
    required this.onTap,
    required this.value,
    this.tileType = PlayListTileType.normal,
  });
  final PlaylistModel value;
  final bool isSelected;
  final PlayListTileType tileType;
  final void Function(PlaylistModel? playList) onTap;
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
                  Text(value.title ?? "", style: AppTextStyle.title20()),
                  Text(
                    "${value.totalVideos} videos",
                    style: AppTextStyle.body14(color: AppColor.gray),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: tileType == PlayListTileType.selection
                  ? AppCheckBoxButton(
                      isSelected: isSelected,
                      onChanged: (isSelected) => onTap(value),
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
