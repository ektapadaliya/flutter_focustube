import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:go_router/go_router.dart';

import '../../const/app_image.dart';

class AddChannelVC extends StatelessWidget {
  const AddChannelVC({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 450, minWidth: 350),
          margin: EdgeInsets.symmetric(horizontal: 30).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom == 0
                ? 30
                : MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Text("Add channel", style: AppTextStyle.title20()),
                  Expanded(child: Container(width: 10)),
                  InkWell(
                    onTap: context.pop,
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    child: Icon(Icons.close, color: AppColor.primary, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AppTextFormField(
                hintText: "Search Channel",
                prefixIcon: Image.asset(AppImage.search, height: 35),
                hintTextColor: AppColor.gray,
              ),
              SizedBox(height: 15),
              AppTextFormField(label: "Channel name", hintText: "Enter name"),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "OR",
                  style: AppTextStyle.body16(color: AppColor.gray),
                ),
              ),
              SizedBox(height: 30),
              AppTextFormField(
                hintText: "Search subject",
                prefixIcon: Image.asset(AppImage.search, height: 35),
                hintTextColor: AppColor.gray,
              ),
              SizedBox(height: 15),
              AppTextFormField(label: "Subject name", hintText: "Enter name"),

              SizedBox(height: 30),
              AppButton(
                label: "Add channel",
                backgroundColor: AppColor.primary,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
