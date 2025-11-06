import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/filter_pop_up.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class HomeVC extends StatefulWidget {
  static const id = "/";
  const HomeVC({super.key});

  @override
  State<HomeVC> createState() => _HomeVCState();
}

class _HomeVCState extends State<HomeVC> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  AppTitle(
                    title: "Bookmarked videos",
                    onViewMore: () {
                      videos.go(context, extra: "Bookmarked");
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => BookmarkVideoTile(),
                      separatorBuilder: (context, index) => SizedBox(width: 15),
                      itemCount: 5,
                    ),
                  ),
                  SizedBox(height: 30),
                  AppTitle(
                    title: "Popular videos",
                    onViewMore: () {
                      videos.go(context, extra: "Popular");
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PopularVideoTile(),
                      separatorBuilder: (context, index) => SizedBox(width: 15),
                      itemCount: 5,
                    ),
                  ),
                  SizedBox(height: 30),
                  AppTitle(
                    title: "Recommended videos",
                    onViewMore: () {
                      videos.go(context, extra: "Recommended");
                    },
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => VideoTile(),
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemCount: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTimeBasedGreeting(),
            style: AppTextStyle.body18(color: AppColor.gray),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(AppImage.appIconLight),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Leslie Alexander",
                  style: AppTextStyle.title28(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10),
              AppPopupOverlay(
                items: ["subjects", "bookmarks", "daily_goals", "history"],
                itemBuilder: (String item) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(popUpImages(item), height: 20),
                    SizedBox(width: 5),
                    Text(popUpLable(item), style: AppTextStyle.body16()),
                  ],
                ),
                onItemPressed: (String item) {
                  if (item == "bookmarks") {
                    videos.go(context, extra: "Bookmarks");
                  } else if (item == "subjects") {
                    subjects.go(context);
                  } else if (item == "daily_goals") {
                    //  dailyGoal.go(context);
                  } else if (item == "history") {
                    // videos.go(context, extra: "History");
                  }
                },
                child: Icon(Icons.more_vert),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String popUpImages(String value) {
    return switch (value) {
      "subjects" => AppImage.subjectIcon,
      "bookmarks" => AppImage.bookmarkIcon,
      "daily_goals" => AppImage.targetIcon,
      "history" => AppImage.historyIcon,
      _ => "",
    };
  }

  String popUpLable(String value) {
    return switch (value) {
      "subjects" => "Subjects",
      "bookmarks" => "Bookmarks",
      "daily_goals" => "Daily Goals",
      "history" => "History",
      _ => "",
    };
  }

  String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 12) {
      return "Good Morning!";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon!";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening!";
    } else {
      return "Good Night!";
    }
  }
}
