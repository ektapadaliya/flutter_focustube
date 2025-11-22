import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/drop_down_field.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class SearchVC extends StatefulWidget {
  static const id = "/search";
  const SearchVC({super.key});

  @override
  State<SearchVC> createState() => _SearchVCState();
}

class _SearchVCState extends State<SearchVC> {
  String? selectValue;
  bool isYoutubeSearch = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Search:", style: AppTextStyle.body16()),
                SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: AppDropDownTextField(
                    value: isYoutubeSearch ? "YouTube" : "FocusTube",
                    items: ["YouTube", "FocusTube"],
                    onChanged: (value) {
                      isYoutubeSearch = (value == "YouTube");
                      setState(() {});
                    },
                    optionChild: (value, isSelcted) =>
                        Text(value, style: AppTextStyle.body16()),
                    selectedChild: (value) =>
                        Text(value, style: AppTextStyle.body16()),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Text(
          //         "Search ${isYoutubeSearch ? 'Youtube' : 'FocusTube'}",
          //         style: AppTextStyle.title16(),
          //       ),
          //     ),
          //     AppSwitch(
          //       onChanged: (value) {
          //         isYoutubeSearch = value;
          //         setState(() {});
          //       },
          //       isSelected: isYoutubeSearch,
          //     ),
          //   ],
          // ),
          SizedBox(height: 10),
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
              itemBuilder: (context, index) =>
                  VideoTile(isFromYoutube: isYoutubeSearch),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
