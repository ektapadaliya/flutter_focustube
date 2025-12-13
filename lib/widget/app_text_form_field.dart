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
    this.radius = 50,
    this.textColor,
    this.hintTextColor,
    this.isFieldDisable = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefix,
  });
  TextEditingController? controller;
  FocusNode? focusNode;
  String? label, hintText;
  Color? fillColor, borderColor;
  int maxLines;
  int? minLines, maxLength;
  bool? obscureText;
  Widget? prefixIcon, suffixIcon, prefix;
  double suffixIconSize, radius;
  Color? textColor, hintTextColor;
  bool isFieldDisable, readOnly;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  void Function()? onTap;
  void Function(String)? onFieldSubmitted, onChanged;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  TextCapitalization textCapitalization;
  OutlineInputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(
      color: borderColor ?? AppColor.borderColor,
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
              primary: AppColor.primary,
              secondary: AppColor.gray,
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label!, style: AppTextStyle.body16(color: AppColor.gray)),
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
            cursorColor: AppColor.primary,
            inputFormatters: inputFormatters,
            style: AppTextStyle.body16(color: textColor ?? AppColor.primary),
            decoration: InputDecoration(
              fillColor: fillColor ?? AppColor.tileBackground,
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
              hintStyle: AppTextStyle.body16(color: hintTextColor ?? textColor),
              focusedBorder: border,
              border: border,
              enabledBorder: border,
              disabledBorder: border,
              errorMaxLines: 4,
              errorStyle: AppTextStyle.body11(color: AppColor.red),
              focusedErrorBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColor.red, width: 1.2),
              ),
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColor.red, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AutoCompleteField extends StatefulWidget {
  const AutoCompleteField({
    super.key,
    this.label,
    this.hintText,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 50,
    this.onValueSelect,
    this.hintTextColor,
    required this.suggestions,
  });
  final double radius;
  final String? label, hintText;
  final List<String> suggestions;
  final Color? textColor, hintTextColor;
  final Widget? prefixIcon, suffixIcon;
  final void Function(String?)? onValueSelect;

  @override
  State<AutoCompleteField> createState() => AutoCompleteFieldState();
}

class AutoCompleteFieldState extends State<AutoCompleteField> {
  RenderBox? get renderBox => context.findRenderObject() as RenderBox?;
  Size? get size => renderBox?.size;
  TextEditingController? editingController;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void clearSearch() {
    editingController?.clear();
    widget.onValueSelect!(null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textValue) {
        var value = textValue.text.trim().isEmpty
            ? <String>[]
            : widget.suggestions.where((option) {
                return option.toLowerCase().contains(
                  textValue.text.toLowerCase(),
                );
              });
        if (value.isEmpty) {
          return widget.suggestions;
        } else {
          return value;
        }
      },
      optionsViewBuilder: (contxet, onSelect, list) => Container(
        alignment: Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 250,
            maxWidth: size?.width ?? double.infinity,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.gray, width: 0.5),
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.gray.opacityToAlpha(.4),
                offset: const Offset(1, 1),

                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list
                  .map(
                    (e) => ListTile(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (widget.onValueSelect != null) {
                          widget.onValueSelect!(e);
                        }
                        onSelect(e);

                        setState(() {});
                      },
                      title: Text(
                        e,
                        style: AppTextStyle.body16(color: AppColor.gray),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      fieldViewBuilder: (context, controller, focusNode, onTap) {
        editingController = controller;
        return AppTextFormField(
          controller: editingController,
          focusNode: focusNode,
          label: widget.label,
          textColor: widget.textColor,
          hintTextColor: widget.hintTextColor,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon != null
              ? InkWell(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  onTap: clearSearch,
                  child: widget.suffixIcon,
                )
              : null,
          radius: widget.radius,
          onFieldSubmitted: (value) {
            widget.onValueSelect!(value);
          },
          hintText: widget.hintText,
        );
      },
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
