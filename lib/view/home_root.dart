import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/filter_pop_up.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  State<HomeRoot> createState() => HomeRootState();
}

class HomeRootState extends State<HomeRoot> {
  @override
  void didChangeDependencies() {
    precacheImage(AssetImage(AppImage.home), context);
    precacheImage(AssetImage(AppImage.searchSelected), context);
    precacheImage(AssetImage(AppImage.searchSelected), context);
    precacheImage(AssetImage(AppImage.channelsSelected), context);
    precacheImage(AssetImage(AppImage.dailyGoalSelected), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = widget.navigationShell.currentIndex;
    return ScreenBackground(
      appBar: currentIndex == 0
          ? sizeZeroAppBar(context)
          : customAppBar(
              context,
              centerTitle: true,
              title: _itemLable(currentIndex),
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: HomePopupMenu(),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: InkWell(
                    onTap: () {
                      settings.go(context);
                    },
                    child: SvgPicture.asset(AppImage.settingIcon, height: 24),
                  ),
                ),
              ],
            ),
      body: widget.navigationShell,
      bottomNavigationBar: _HomeBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(index);
        },
      ),
    );
  }
}

class _HomeBottomNavigationBar extends StatelessWidget {
  const _HomeBottomNavigationBar({
    required this.onTap,
    required this.currentIndex,
  });
  final int currentIndex;
  final void Function(int index) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x18717282),
            blurRadius: 21.4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          height: kBottomNavigationBarHeight,
          child: Row(
            children: List.generate(
              5,
              (index) => Expanded(
                child: Center(
                  child: _buildBottomNavigationBarItem(index: index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomNavigationBarItem({required int index}) {
    bool isSelected = index == currentIndex;
    return InkWell(
      onTap: () => onTap(index),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isSelected ? _selectedItemImage(index) : _itemImage(index),
            height: 36,
          ),
          Text(
            _itemLable(index),
            style: AppTextStyle.body12(
              color: !isSelected ? AppColor.gray : null,
            ),
          ),
        ],
      ),
    );
  }
}

String _itemLable(int index) {
  return switch (index) {
    0 => "Home",
    1 => "Explore",
    2 => "Subjects",
    3 => "Channels",
    4 => "Daily Goals",
    _ => "",
  };
}

String _itemImage(int index) {
  return switch (index) {
    0 => AppImage.home,
    1 => AppImage.search,
    2 => AppImage.subject,
    3 => AppImage.channels,
    4 => AppImage.dailyGoal,
    _ => "",
  };
}

String _selectedItemImage(int index) {
  return switch (index) {
    0 => AppImage.homeSelected,
    1 => AppImage.searchSelected,
    2 => AppImage.subjectSelected,
    3 => AppImage.channelsSelected,
    4 => AppImage.dailyGoalSelected,
    _ => "",
  };
}

class HomePopupMenu extends StatelessWidget {
  const HomePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPopupOverlay(
      items: ["playlist", /* "my_subjects", */ "bookmarks", "history"],
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
          videos.go(context, extra: popUpLable(item));
        } /* else if (item == "my_subjects") {
          mySubjects.go(context);
        } */ else if (item == "playlist") {
          playlists.go(context);
        } else if (item == "history") {
          videos.go(context, extra: popUpLable(item));
        }
      },
      child: Icon(Icons.more_vert),
    );
  }

  String popUpImages(String value) {
    return switch (value) {
      "playlist" => AppImage.userPlaylistIcon,
      "my_subjects" => AppImage.subjectIcon,
      "bookmarks" => AppImage.bookmarkIcon,
      //"setting" => AppImage.settingIcon,
      "history" => AppImage.historyIcon,
      _ => "",
    };
  }

  String popUpLable(String value) {
    return switch (value) {
      "playlist" => "Playlists",
      "my_subjects" => "My Subjects",
      "bookmarks" => "Bookmarks",
      //"setting" => "Settings",
      "history" => "My History",
      _ => "",
    };
  }
}
