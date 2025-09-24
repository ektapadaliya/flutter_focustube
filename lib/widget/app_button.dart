import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
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
    this.padding,
  });
  final dynamic label;
  final bool isFilled;
  final bool isDisable;
  final Color? textColor, borderColor;
  final Color backgroundColor;
  final Color? disableBackgroundColor;
  final void Function()? onTap;
  final AlignmentGeometry? alignment;
  final double? fontSize;
  final double height;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisable ? null : onTap,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Container(
        height: height,

        padding: padding ?? const EdgeInsets.symmetric(horizontal: 47.5),
        decoration: BoxDecoration(
          color: isFilled
              ? (isDisable ? disableBackgroundColor : backgroundColor)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
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
                style: AppTextStyle.buttonTextStyleBold(
                  fontSize: fontSize,
                  color:
                      textColor ??
                      (isFilled ? AppColor.white : backgroundColor),
                ),
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
