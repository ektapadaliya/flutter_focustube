import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/view/subjects/select_subject_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

import '../../const/app_text_style.dart';

class SubjectVC extends StatefulWidget {
  static const id = "/subjects";
  static const mySubjectId = "/my-subjects";
  final bool isMySubjects, isFromNav;
  const SubjectVC({
    super.key,
    this.isMySubjects = false,
    this.isFromNav = false,
  });

  @override
  State<SubjectVC> createState() => _SubjectVCState();
}

class _SubjectVCState extends State<SubjectVC> {
  List<String> subjects = [
    "Math",
    "Economics",
    "Physics",
    "English",
    "Art",
    "Career Development",
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var child = SafeArea(
      minimum: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: widget.isMySubjects ? 15 : 0,
      ),
      child: Column(
        children: [
          if (!widget.isMySubjects)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => buildCategoryTile(index),
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemCount: 3,
              ),
            ),
          if (!widget.isMySubjects && selectedIndex == 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SelectSubjectVC(isFromNav: true),
              ),
            )
          else ...[
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => SizedBox(
                  height: 230,
                  child: Column(
                    children: [
                      AppTitle(
                        title: subjects[index],
                        onViewMore: () {
                          subjectsDetail.go(
                            context,
                            id: subjects[index].toLowerCase().replaceAll(
                              " ",
                              "_",
                            ),
                            extra: subjects[index],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => SubjectVideoTile(),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 15),
                          itemCount: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(height: 30),
                itemCount: subjects.length,
              ),
            ),
          ],
        ],
      ),
    );
    if (widget.isFromNav) {
      return ScreenBackground(
        appBar: customAppBar(
          context,
          title: (widget.isMySubjects || selectedIndex == 1)
              ? "My Subjects"
              : "Subjects",
        ),
        body: child,
      );
    } else {
      return child;
    }
  }

  buildCategoryTile(int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        selectedIndex = index;
        // Scrollable.ensureVisible(
        //   itemKeys[index].currentContext!,
        //   duration: const Duration(milliseconds: 300),
        //   alignment: .5, // 0.0 = left, 1.0 = right, 0.5 = center
        //   curve: Curves.easeInOut,
        // );
        setState(() {});
      },
      child: Container(
        //key: itemKeys[index],
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
          _channelsType(index),
          style: AppTextStyle.title16(
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ),
      ),
    );
  }

  _channelsType(int index) {
    return switch (index) {
      // 0 => "Channels",
      0 => "Select Subject",
      1 => "My Subjects",
      2 => "Subjects",

      //4 => "Select Channels",
      _ => "",
    };
  }
}
