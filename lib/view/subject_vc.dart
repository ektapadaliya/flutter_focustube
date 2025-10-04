import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class SubjectVC extends StatefulWidget {
  static const id = "/subjects";
  const SubjectVC({super.key});

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
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Subjects"),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                      id: subjects[index].toLowerCase().replaceAll(" ", "_"),
                      extra: subjects[index],
                    );
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => SubjectVideoTile(),
                    separatorBuilder: (context, index) => SizedBox(width: 15),
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
    );
  }
}
