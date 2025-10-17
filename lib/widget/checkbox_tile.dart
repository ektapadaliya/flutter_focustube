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
      AppCheckBoxButton(isSelected: isSelected, onChanged: onChanged),
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

class AppCheckBoxButton extends StatelessWidget {
  const AppCheckBoxButton({
    super.key,
    required this.onChanged,
    required this.isSelected,
  });
  final bool isSelected;
  final void Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.3,
      child: Checkbox(
        visualDensity: const VisualDensity(horizontal: -4),
        value: isSelected,
        activeColor: AppColor.primary,
        side: BorderSide(color: AppColor.borderColor, width: 1),
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.primary, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class AppRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final void Function(T) onChanged;
  final double size;
  final double borderWidth;
  final Color selectedColor;
  final Color unselectedColor;
  final double innerPadding;
  final Widget? child;

  const AppRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 18,
    this.borderWidth = 1.5,
    this.selectedColor = AppColor.primary,
    this.unselectedColor = AppColor.gray,
    this.innerPadding = 2.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    var isSelected = value == groupValue;
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        onChanged(value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? selectedColor : unselectedColor,
                width: borderWidth,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(innerPadding),
              child: isSelected
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedColor,
                      ),
                    )
                  : null,
            ),
          ),
          if (child != null) ...[SizedBox(width: 8), child!],
        ],
      ),
    );
  }
}
