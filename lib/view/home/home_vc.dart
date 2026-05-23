import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/view/home/channels_vc.dart';
import 'package:focus_tube_flutter/view/home_root.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';
import 'package:get/get.dart';

// class HomeVC extends StatefulWidget {
//   static const id = "/";
//   const HomeVC({super.key});

//   @override
//   State<HomeVC> createState() => _HomeVCState();
// }

// class _HomeVCState extends State<HomeVC> with AutomaticKeepAliveClientMixin {
//   var bookmarkVideoCtrl = controller<VideoController>(tag: "bookmark-home");
//   var popularVideoCtrl = controller<VideoController>(tag: "popular-home");
//   var recommendedVideoCtrl = controller<VideoController>(
//     tag: "recommended-home",
//   );
//   var loadingController = controller<LoaderController>(tag: "video-home");
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       loadingController.setLoading(true);
//       await callApi();
//     });
//   }

//   Future<void> onRefresh() async {
//     bookmarkVideoCtrl.clear();
//     popularVideoCtrl.clear();
//     recommendedVideoCtrl.clear();
//     await callApi();
//   }

//   Future<void> callApi() async {
//     loadingController.setLoading(true);
//     await Future.wait([
//       ApiFunctions.instance.getBookmarkVideos(
//         context,
//         controller: bookmarkVideoCtrl,
//         perPage: 5,
//       ),
//       ApiFunctions.instance.getPopularVideos(
//         context,
//         controller: popularVideoCtrl,
//         perPage: 5,
//       ),
//       ApiFunctions.instance.getRecommenedVideos(
//         context,
//         controller: recommendedVideoCtrl,
//         perPage: 10,
//       ),
//     ]);
//     loadingController.setLoading(false);
//   }

//   void onBookmark(String id) async {
//     recommendedVideoCtrl.changeBookmarkStatus(id);
//     popularVideoCtrl.changeBookmarkStatus(id);
//     var value = await ApiFunctions.instance.bookmarkVideo(context, videoId: id);
//     recommendedVideoCtrl.changeBookmarkStatus(id, value: value);
//     popularVideoCtrl.changeBookmarkStatus(id, value: value);
//     if (!value) {
//       bookmarkVideoCtrl.removeVideo(id);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppLoader(
//       loaderController: loadingController,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),
//         child: Column(
//           children: [
//             _buildHeader(),
//             SizedBox(height: 10),
//             Expanded(
//               child: RefreshIndicator(
//                 onRefresh: onRefresh,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(height: 10),
//                       GetBuilder(
//                         tag: "bookmark-home",
//                         init: bookmarkVideoCtrl,
//                         builder: (bookmarkVideoCtrl) {
//                           if (bookmarkVideoCtrl.videos.isNotEmpty) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 30),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   AppTitle(
//                                     title: "Bookmarked videos",
//                                     onViewMore: () {
//                                       videos.go(context, id: "bookmark");
//                                     },
//                                   ),
//                                   SizedBox(height: 10),
//                                   SizedBox(
//                                     height: 230,
//                                     child: ListView.separated(
//                                       scrollDirection: Axis.horizontal,
//                                       itemBuilder: (context, index) =>
//                                           BookmarkVideoTile(
//                                             onBookmark: onBookmark,
//                                             video:
//                                                 bookmarkVideoCtrl.videos[index],
//                                           ),
//                                       separatorBuilder: (context, index) =>
//                                           SizedBox(width: 15),
//                                       itemCount:
//                                           bookmarkVideoCtrl.videos.length,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return Container();
//                         },
//                       ),
//                       GetBuilder(
//                         tag: "popular-home",
//                         init: popularVideoCtrl,
//                         builder: (popularVideoCtrl) {
//                           if (popularVideoCtrl.videos.isNotEmpty) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 30),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   AppTitle(
//                                     title: "Popular videos",
//                                     onViewMore: () {
//                                       videos.go(context, id: "popular");
//                                     },
//                                   ),
//                                   SizedBox(height: 10),
//                                   SizedBox(
//                                     height: 220,
//                                     child: ListView.separated(
//                                       scrollDirection: Axis.horizontal,
//                                       itemBuilder: (context, index) =>
//                                           PopularVideoTile(
//                                             onBookmark: onBookmark,
//                                             video:
//                                                 popularVideoCtrl.videos[index],
//                                           ),
//                                       separatorBuilder: (context, index) =>
//                                           SizedBox(width: 15),
//                                       itemCount: popularVideoCtrl.videos.length,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return Container();
//                         },
//                       ),
//                       GetBuilder(
//                         tag: "recommended-home",
//                         init: recommendedVideoCtrl,
//                         builder: (recommendedVideoCtrl) {
//                           if (recommendedVideoCtrl.videos.isNotEmpty) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 30),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   AppTitle(
//                                     title: "Recommended videos",
//                                     onViewMore: () {
//                                       videos.go(context, id: "recommended");
//                                     },
//                                   ),
//                                   SizedBox(height: 10),
//                                   ListView.separated(
//                                     shrinkWrap: true,
//                                     physics: NeverScrollableScrollPhysics(),
//                                     itemBuilder: (context, index) {
//                                       return VideoTile(
//                                         onBookmark: onBookmark,
//                                         video:
//                                             recommendedVideoCtrl.videos[index],
//                                       );
//                                     },
//                                     separatorBuilder: (context, index) =>
//                                         SizedBox(height: 15),
//                                     itemCount:
//                                         recommendedVideoCtrl.videos.length,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return Container();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _buildHeader() {
//     return SafeArea(
//       top: true,
//       bottom: false,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             getTimeBasedGreeting(),
//             style: AppTextStyle.body18(color: AppColor.gray),
//           ),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.white,
//                 backgroundImage: AssetImage(AppImage.appIconLight),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: GetBuilder(
//                   init: controller<UserController>(),
//                   builder: (userController) {
//                     return Text(
//                       "${userController.user?.firstName ?? ''} ${userController.user?.lastName ?? ''}",
//                       style: AppTextStyle.title28(),
//                       overflow: TextOverflow.ellipsis,
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(width: 10),
//               HomePopupMenu(),
//               SizedBox(width: 15),
//               AppInkWell(
//                 onTap: () {
//                   settings.go(context);
//                 },
//                 child: SvgPicture.asset(AppImage.settingIcon, height: 24),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String getTimeBasedGreeting() {
//     final hour = DateTime.now().hour;

//     if (hour >= 4 && hour < 12) {
//       return "Good Morning!";
//     } else if (hour >= 12 && hour < 17) {
//       return "Good Afternoon!";
//     } else if (hour >= 17 && hour < 21) {
//       return "Good Evening!";
//     } else {
//       return "Good Night!";
//     }
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

class HomeVC extends StatefulWidget {
  static const id = "/";

  const HomeVC({super.key, this.isGuest = false});
  final bool isGuest;
  @override
  State<HomeVC> createState() => _HomeVCState();
}

class _HomeVCState extends State<HomeVC> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),
      child: Stack(
        alignment: AlignmentGeometry.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text("FocusTube", style: AppTextStyle.title36()),
              Image.asset(AppImage.appIconDarkTransperent, height: 100),
              //SizedBox(height: 8),
              Text(
                "YouTube. Your way. Finally. ",
                style: AppTextStyle.title24(color: AppColor.lightGray),
              ),
              Divider(
                color: AppColor.lightGray.withValues(alpha: .5),
                height: 60,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 5,
                spacing: 4.5,
                children:
                    [
                          "🚫 No rabbit holes.",
                          "🌙 No midnight spirals.",
                          "🤖 No algorithm pulling the strings.",
                          "When a video ends — the app stops.",
                          "No autoplay.",
                          "No \"up next.\" Ever.",
                        ]
                        .map(
                          (e) => Text(
                            e,
                            style: AppTextStyle.body14(color: AppColor.white),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 20),
              Text(
                "✨ Watch more of what matters. Stop when you meant to. Actually feel good about it.",
                style: AppTextStyle.title16(color: AppColor.white),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: AppColor.lightGray.withValues(alpha: .5),
                height: 60,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Navigate",
                    style: AppTextStyle.title18(color: AppColor.white),
                  ),
                  SizedBox(height: 20),
                  OptionGridView(
                    children: [
                      buildNavigator(
                        label: "🔍 Explore",
                        message:
                            "Search your curated world or all of YouTube — you choose the universe.",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(1);
                        },
                        isRestricted: false,
                      ),
                      // SizedBox(height: 15),
                      buildNavigator(
                        label: "🗂️ Subjects",
                        message:
                            "Browse your interests by topic and sub-topic.",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(2);
                        },
                      ),
                      // SizedBox(height: 15),
                      buildNavigator(
                        label: "📡 Channels",
                        message:
                            "Your Channels · FocusTube Picks · KidsTube · ScholarTube",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(3);
                        },
                        isRestricted: false,
                      ),
                      // SizedBox(height: 15),
                      buildNavigator(
                        label: "🎯 Daily Goals",
                        message:
                            "Set how many videos you want — and actually stop when you meant to.",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(4);
                        },
                      ),
                      //  SizedBox(height: 15),
                      buildNavigator(
                        label: "💡 Interests",
                        message:
                            "Tell us what you love. The app will feel built just for you.",
                        onTap: () {
                          editYourInterest.go(context);
                        },
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColor.lightGray.withValues(alpha: .5),
                    height: 60,
                  ),
                  Text(
                    "From the Menu",
                    style: AppTextStyle.title18(color: AppColor.white),
                  ),
                  SizedBox(height: 20),
                  OptionGridView(
                    children: [
                      buildNavigator(
                        label: "▶️ Playlists",
                        message: "Your saved playlists.",
                        onTap: () {
                          playlists.go(context);
                        },
                      ),

                      buildNavigator(
                        label: "🔖 Bookmarks",
                        message: "Videos saved for later.",
                        onTap: () {
                          videos.go(context, id: "bookmarks");
                        },
                      ),

                      buildNavigator(
                        label: "🕓 History",
                        message: "What you've watched.",
                        onTap: () {
                          videos.go(context, id: "history");
                        },
                      ),

                      buildNavigator(
                        label: "🌟 Recommended",
                        message: "Picks from your channels.",
                        onTap: () {
                          videos.go(context, id: "recommended");
                        },
                        isRestricted: false,
                      ),

                      buildNavigator(
                        label: "🔥 Popular",
                        message: "Trending in your world.",
                        onTap: () {
                          videos.go(context, id: "popular");
                        },
                        isRestricted: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Everything above comes from YOUR channels — not YouTube's.",
                    style: AppTextStyle.body14(
                      color: AppColor.white,
                    ).copyWith(fontStyle: FontStyle.italic),
                  ),
                  Divider(
                    color: AppColor.lightGray.withValues(alpha: .5),
                    height: 60,
                  ),
                  OptionGridView(
                    children: [
                      buildNavigator(
                        label: "⚙️ Settings",
                        message:
                            "Profile · Notifications · Security. Your space, your rules.",
                        onTap: () {
                          settings.go(context);
                        },
                      ),
                      Container(),
                    ],
                  ),
                  Divider(
                    color: AppColor.lightGray.withValues(alpha: .5),
                    height: 60,
                  ),
                  Text(
                    "Curated Channels",
                    style: AppTextStyle.title18(color: AppColor.white),
                  ),
                  SizedBox(height: 20),
                  OptionGridView(
                    children: [
                      buildNavigator(
                        label: "🌟 Curated",
                        message:
                            "FocusTube's hand-picked channels — the best of the best.",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(3);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            channelTabScrollController.jumpToPage(2);
                          });
                        },
                        isRestricted: false,
                      ),

                      buildNavigator(
                        label: "🎈 KidsTube",
                        message:
                            "Hand-picked channels for kids. Safe, fun, and screen-time friendly.",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(3);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            channelTabScrollController.jumpToPage(4);
                          });
                        },
                        isRestricted: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  OptionGridView(
                    children: [
                      buildNavigator(
                        label: "🔬 ScholarTube",
                        message:
                            "Curated channels for learners and academics. Deep dives, done right.",
                        onTap: () {
                          homeRootKey.currentState?.jumpToPage(3);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            channelTabScrollController.jumpToPage(3);
                          });
                        },
                        isRestricted: false,
                      ),
                      Container(),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: HomePopupMenu(color: AppColor.white),
                ),

                AppInkWell(
                  onTap: () {
                    settings.go(context);
                  },
                  child: SvgPicture.asset(
                    AppImage.settingIcon,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColor.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavigator({
    dynamic label,
    required String message,
    Color backgroundColor = AppColor.primary,
    void Function()? onTap,
    bool isRestricted = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHomeButton(
          label: label,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          backgroundColor: AppColor.white,
          height: 90,
          //maxWidth: 450,
          onTap: onTap,
          alignment: Alignment.centerLeft,
          fontSize: 17,
          subLabel: message,
          isFilled: false,
          //radius: 10,
        ),
        // SizedBox(height: 3),
        // Text(
        //   message,
        //   style: AppTextStyle.body12(
        //     color: AppColor.gray,
        //   ).copyWith(fontStyle: FontStyle.italic),
        // ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OptionGridView extends StatelessWidget {
  const OptionGridView({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.sizeOf(context).width > 450
            ? MediaQuery.sizeOf(context).width / 2
            : MediaQuery.sizeOf(context).width,
        childAspectRatio: MediaQuery.sizeOf(context).width > 450 ? 1 : 4.5,
        mainAxisExtent: 105,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
