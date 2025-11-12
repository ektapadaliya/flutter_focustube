import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class SearchVC extends StatefulWidget {
  static const id = "/search";
  const SearchVC({super.key});

  @override
  State<SearchVC> createState() => _SearchVCState();
}

class _SearchVCState extends State<SearchVC> {
  String? selectValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoCompleteField(
            radius: 6,
            hintText: "Search here...",
            suggestions: [
              "The Cold War: Explained in a Nutshell",
              "World War I: Quickfire History Guide",
              "The Renaissance: Spark Notes History",
              "The Rise of Napoleon: Bite-Sized History",
              "The Russian Revolution: Mini Masterclass",
            ],
            onValueSelect: (value) {
              selectValue = value;
              setState(() {});
            },
            hintTextColor: AppColor.gray,
            prefixIcon: Image.asset(AppImage.search, height: 35),
            suffixIcon: selectValue == null
                ? null
                : Icon(Icons.close, size: 22, color: AppColor.gray),
          ),
          SizedBox(height: 20),
          Text("Search results", style: AppTextStyle.title20()),
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => VideoTile(),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
