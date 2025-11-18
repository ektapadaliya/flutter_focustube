import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.isFilled = true,
    required this.label,
    required this.backgroundColor,
    this.isDisable = false,
    this.disableBackgroundColor,
    this.textColor,
    this.borderColor,
    this.onTap,
    this.alignment = Alignment.center,
    this.fontSize,
    this.height = 70,
    this.radius = 50,
    this.padding,
    this.maxWidth = AppConst.kMaxLandscapeFormWidth,
  });
  final dynamic label;
  final bool isFilled, isDisable;
  final Color? textColor, borderColor, disableBackgroundColor;
  final Color backgroundColor;
  final void Function()? onTap;
  final AlignmentGeometry? alignment;
  final double? fontSize;
  final double height, maxWidth, radius;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisable ? null : onTap,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Container(
        height: height,
        constraints: AppConst.isLandscape(context)
            ? BoxConstraints(maxWidth: maxWidth)
            : null,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 47.5),
        decoration: BoxDecoration(
          color: isFilled
              ? (isDisable ? disableBackgroundColor : backgroundColor)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 1.5,
            color:
                borderColor ??
                (isDisable
                    ? disableBackgroundColor ?? backgroundColor
                    : backgroundColor),
          ),
        ),
        alignment: alignment,
        child: (label is String)
            ? Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyle.title20(
                  color:
                      textColor ??
                      (isFilled ? AppColor.white : backgroundColor),
                ).copyWith(fontSize: fontSize),
              )
            : (label is IconData)
            ? Icon(
                (label as IconData),
                size: fontSize,
                color:
                    textColor ?? (isFilled ? AppColor.white : backgroundColor),
              )
            : label,
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.onChanged,
    required this.isSelected,
  });
  final bool isSelected;
  final void Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .7,
      child: CupertinoSwitch(
        value: isSelected,
        activeTrackColor: AppColor.primary,
        inactiveTrackColor: AppColor.lightGray.opacityToAlpha(.4),
        onChanged: onChanged,
      ),
    );
  }
}
