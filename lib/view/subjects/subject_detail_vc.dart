import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class SubjectDetailVC extends StatefulWidget {
  final String title;
  static const id = "/subject/:id";
  const SubjectDetailVC({super.key, required this.title});

  @override
  State<SubjectDetailVC> createState() => _SubjectDetailVCState();
}

class _SubjectDetailVCState extends State<SubjectDetailVC> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: widget.title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => buildCategoryTile(index),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: 5,
                ),
              ),
              SizedBox(height: 20),
              AppTitle(title: "Videos"),
              ...List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container() /* VideoTile() */,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCategoryTile(int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        selectedIndex = index;
        setState(() {});
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? AppColor.primary : null,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.gray,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          "Category",
          style: AppTextStyle.title16(
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ),
      ),
    );
  }
}
