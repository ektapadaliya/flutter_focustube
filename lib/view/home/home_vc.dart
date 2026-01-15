import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/api/youtube_api.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/video_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/view/home_root.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/get.dart';

class HomeVC extends StatefulWidget {
  static const id = "/";
  const HomeVC({super.key});

  @override
  State<HomeVC> createState() => _HomeVCState();
}

class _HomeVCState extends State<HomeVC> with AutomaticKeepAliveClientMixin {
  var bookmarkVideoCtrl = controller<VideoController>(tag: "bookmark-home");
  var popularVideoCtrl = controller<VideoController>(tag: "popular-home");
  var recommendedVideoCtrl = controller<VideoController>(
    tag: "recommended-home",
  );
  var loadingController = controller<LoaderController>(tag: "video-home");
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      loadingController.setLoading(true);
      await callApi();
    });
  }

  Future<void> onRefresh() async {
    bookmarkVideoCtrl.clear();
    popularVideoCtrl.clear();
    recommendedVideoCtrl.clear();
    await callApi();
  }

  Future<void> callApi() async {
    loadingController.setLoading(true);
    await Future.wait([
      ApiFunctions.instance.getBookmarkVideos(
        context,
        controller: bookmarkVideoCtrl,
        perPage: 5,
      ),
      ApiFunctions.instance.getPopularVideos(
        context,
        controller: popularVideoCtrl,
        perPage: 5,
      ),
      ApiFunctions.instance.getRecommenedVideos(
        context,
        controller: recommendedVideoCtrl,
        perPage: 10,
      ),
    ]);
    loadingController.setLoading(false);
  }

  void onBookmark(String id) async {
    recommendedVideoCtrl.changeBookmarkStatus(id);
    popularVideoCtrl.changeBookmarkStatus(id);
    var value = await ApiFunctions.instance.bookmarkVideo(context, videoId: id);

    if (value == 0) {
      bookmarkVideoCtrl.removeVideo(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loadingController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      GetBuilder(
                        tag: "bookmark-home",
                        init: bookmarkVideoCtrl,
                        builder: (bookmarkVideoCtrl) {
                          if (bookmarkVideoCtrl.videos.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTitle(
                                    title: "Bookmarked videos",
                                    onViewMore: () {
                                      videos.go(context, id: "bookmark");
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 230,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          BookmarkVideoTile(
                                            onBookmark: onBookmark,
                                            video:
                                                bookmarkVideoCtrl.videos[index],
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 15),
                                      itemCount:
                                          bookmarkVideoCtrl.videos.length,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      GetBuilder(
                        tag: "popular-home",
                        init: popularVideoCtrl,
                        builder: (popularVideoCtrl) {
                          if (popularVideoCtrl.videos.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTitle(
                                    title: "Popular videos",
                                    onViewMore: () {
                                      videos.go(context, id: "popular");
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 220,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          PopularVideoTile(
                                            onBookmark: onBookmark,
                                            video:
                                                popularVideoCtrl.videos[index],
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 15),
                                      itemCount: popularVideoCtrl.videos.length,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      GetBuilder(
                        tag: "recommended-home",
                        init: recommendedVideoCtrl,
                        builder: (recommendedVideoCtrl) {
                          if (recommendedVideoCtrl.videos.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTitle(
                                    title: "Recommended videos",
                                    onViewMore: () {
                                      videos.go(context, id: "recommended");
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return VideoTile(
                                        onBookmark: onBookmark,
                                        video:
                                            recommendedVideoCtrl.videos[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 15),
                                    itemCount:
                                        recommendedVideoCtrl.videos.length,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
              HomePopupMenu(),
              SizedBox(width: 15),
              InkWell(
                onTap: () {
                  settings.go(context);
                },
                child: SvgPicture.asset(AppImage.settingIcon, height: 24),
              ),
            ],
          ),
        ],
      ),
    );
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

  @override
  bool get wantKeepAlive => true;
}
