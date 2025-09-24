// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';

class AppTextFormField extends StatelessWidget {
  AppTextFormField({
    super.key,
    this.label,
    this.controller,
    this.hintText,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.readOnly = false,
    this.obscureText,
    this.borderColor,
    this.validator,
    this.maxLength,
    this.onChanged,
    this.suffixIconSize = 60,
    this.textColor,
    this.isFieldDisable = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefix,
  });
  TextEditingController? controller;
  FocusNode? focusNode;
  String? hintText;
  String? label;
  Color? fillColor;
  Color? borderColor;
  final int maxLines;
  final int? minLines;
  int? maxLength;
  bool? obscureText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  double suffixIconSize;
  Color? textColor;
  bool isFieldDisable;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  void Function()? onTap;
  void Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  bool readOnly;
  Widget? prefix;
  List<TextInputFormatter>? inputFormatters;
  void Function(String)? onChanged;
  TextCapitalization textCapitalization;
  get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(
      color: borderColor ?? AppColor.textFieldBorder,
      width: 1,
    ),
    gapPadding: 8,
  );
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false, fontFamily: AppTextStyle.fontFamily)
          .copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(
              primary: AppColor.black,
              secondary: AppColor.gray,
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: AppTextStyle.body16.copyWith(color: AppColor.gray),
            ),
            const SizedBox(height: 2),
          ],
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            readOnly: isFieldDisable == true ? true : readOnly,
            textCapitalization: textCapitalization,
            autocorrect: true,
            obscuringCharacter: "*",
            obscureText: obscureText ?? false,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onTap: onTap,
            maxLength: maxLength,
            onFieldSubmitted: onFieldSubmitted,
            minLines: minLines,
            validator: validator,
            onChanged: onChanged,
            maxLines: maxLines,
            cursorColor: AppColor.black,
            inputFormatters: inputFormatters,
            style: AppTextStyle.body16.copyWith(
              color: textColor ?? AppColor.black,
            ),
            decoration: InputDecoration(
              fillColor: fillColor ?? AppColor.textFieldBackground,
              filled: true,
              prefix: prefix,
              prefixIcon: prefixIcon != null
                  ? Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? Container(
                      width: suffixIconSize,
                      alignment: Alignment.center,
                      child: suffixIcon,
                    )
                  : null,
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              hintStyle: AppTextStyle.body16.copyWith(
                color: textColor ?? AppColor.black,
              ),
              focusedBorder: border,
              border: border,
              enabledBorder: border,
              disabledBorder: border,
              errorMaxLines: 2,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
                gapPadding: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FirstLatterUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: firstLatterCapitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

class WordFirstLatterUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: everyWordCapitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(text: newValue.text, selection: newValue.selection);
  }
}

String firstLatterCapitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0]}${value.substring(1)}";
}

String everyWordCapitalize(String value) {
  if (value.trim().isEmpty) return "";
  return value
      .split(' ')
      .map(
        (word) => word.isNotEmpty
            ? "${word[0]}${word.substring(1).toLowerCase()}"
            : '',
      )
      .join(' ');
}
