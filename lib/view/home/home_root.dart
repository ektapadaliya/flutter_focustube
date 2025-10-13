import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/view/dialog/add_channel_vc.dart';
import 'package:focus_tube_flutter/view/dialog/add_edit_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
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
    precacheImage(AssetImage(AppImage.playlistSelected), context);
    precacheImage(AssetImage(AppImage.channlesSelected), context);
    precacheImage(AssetImage(AppImage.searchSelected), context);
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
              // title: _itemLable(currentIndex),
              automaticallyImplyLeading: false,
              actions: [
                // if ([2, 3].contains(currentIndex))
                //   Padding(
                //     padding: const EdgeInsets.only(right: 30),
                //     child: InkWell(
                //       onTap: () {
                //         if (currentIndex == 2) {
                //           showDialog(
                //             context: context,
                //             builder: (context) => AddEditPlaylistVC(),
                //           );
                //         } else if (currentIndex == 3) {
                //           showDialog(
                //             context: context,
                //             builder: (context) => AddChannelVC(),
                //           );
                //         }
                //       },
                //       child: Icon(Icons.add, size: 25, color: AppColor.primary),
                //     ),
                //   ),
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
    2 => "Playlist",
    3 => "Channels",
    4 => "Settings",
    _ => "",
  };
}

String _itemImage(int index) {
  return switch (index) {
    0 => AppImage.home,
    1 => AppImage.search,
    2 => AppImage.playlist,
    3 => AppImage.channles,
    4 => AppImage.settings,
    _ => "",
  };
}

String _selectedItemImage(int index) {
  return switch (index) {
    0 => AppImage.homeSelected,
    1 => AppImage.searchSelected,
    2 => AppImage.playlistSelected,
    3 => AppImage.channlesSelected,
    4 => AppImage.settingsSelected,
    _ => "",
  };
}
