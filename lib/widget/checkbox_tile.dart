import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';

enum AppCheckBoxTileAlign { left, right }

class AppCheckBoxTile extends StatelessWidget {
  const AppCheckBoxTile({
    super.key,
    required this.isSelected,
    required this.title,
    this.align = AppCheckBoxTileAlign.left,
    required this.onChanged,
  });
  final bool isSelected;
  final void Function(bool?) onChanged;
  final Widget title;
  final AppCheckBoxTileAlign align;
  @override
  Widget build(BuildContext context) {
    var children = [
      Transform.scale(
        scale: 1.3,
        child: Checkbox(
          visualDensity: const VisualDensity(horizontal: -4),
          value: isSelected,
          activeColor: AppColor.primary,
          side: BorderSide(color: AppColor.textFieldBorder, width: 1),
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColor.primary, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      const SizedBox(width: 7),
      Flexible(child: title),
    ];
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () {
        onChanged(!isSelected);
      },
      child: Row(
        children: align == AppCheckBoxTileAlign.right
            ? children.reversed.toList()
            : children,
      ),
    );
  }
}
