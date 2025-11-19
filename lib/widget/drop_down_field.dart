// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../const/app_text_style.dart';
import '../const/app_color.dart';

class AppDropDownTextField<T> extends StatelessWidget {
  const AppDropDownTextField({
    super.key,
    required this.items,
    required this.onChanged,
    required this.optionChild,
    required this.selectedChild,
    this.value,
    this.borderColor,
    this.label,
    this.readOnly = false,
    this.hintText,
  });

  final T? value;
  final String? hintText;
  final String? label;
  final Widget Function(T, bool) optionChild;
  final Widget Function(T) selectedChild;
  final Color? borderColor;
  final bool readOnly;
  final List<T> items;
  final void Function(T?)? onChanged;

  OutlineInputBorder _border({Color? color}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color ?? AppColor.borderColor, width: 0.5),
    gapPadding: 4.0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              label!,
              style: AppTextStyle.body16(color: AppColor.gray),
            ),
          ),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items.map((e) {
            final isSelected = e == value;
            return DropdownMenuItem<T>(
              value: e,
              child: optionChild(e, isSelected),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return items.map((e) => selectedChild(e)).toList();
          },
          onChanged: readOnly ? null : onChanged,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 350,
          dropdownColor: AppColor.white,
          style: AppTextStyle.body16(color: AppColor.primary),

          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColor.primary,
            size: 20,
          ),
          decoration: InputDecoration(
            hintText: hintText,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 17,
            ),
            isDense: true,
            fillColor: Colors.transparent,
            focusedBorder: _border(),
            border: _border(),
            enabledBorder: _border(),
            disabledBorder: _border(),
            errorMaxLines: 1,
            hintStyle: AppTextStyle.body16(color: AppColor.primary),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.red, width: 1.2),
              gapPadding: 0,
            ),
          ),
        ),
      ],
    );
  }
}
