import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/drop_down_field.dart';

import '../videos/youtube_video_vc.dart';

class SearchVC extends StatefulWidget {
  static const id = "/search";
  const SearchVC({super.key});

  @override
  State<SearchVC> createState() => _SearchVCState();
}

class _SearchVCState extends State<SearchVC>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  String? searchValue;
  LoaderController loaderController = controller<LoaderController>(
    tag: "search",
  );
  YoutubeVideoController youtubeVideoController =
      controller<YoutubeVideoController>(tag: "search");
  PageController pageController = PageController(initialPage: 1);
  GlobalKey<YoutubeVideoVCState> youtubeVideoKey =
      GlobalKey<YoutubeVideoVCState>();

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: Padding(
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
                      value: searchPlatfromType,
                      items: ["YouTube", "FocusTube"],
                      onChanged: changeSearchType,
                      optionChild: (value, isSelcted) =>
                          Text(value, style: AppTextStyle.body16()),
                      selectedChild: (value) =>
                          Text(value, style: AppTextStyle.body16()),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            AppTextFormField(
              controller: searchController,
              radius: 6,
              onFieldSubmitted: onSearch,
              hintText: "Search here...",
              hintTextColor: AppColor.gray,
              prefixIcon: Image.asset(AppImage.search, height: 35),
              suffixIcon: searchValue == null
                  ? null
                  : InkWell(
                      onTap: () {
                        searchController.clear();
                        searchValue = null;
                        setState(() {});
                      },
                      child: Icon(Icons.close, size: 22, color: AppColor.gray),
                    ),
            ),
            SizedBox(height: 20),
            Text("Search results", style: AppTextStyle.title20()),
            SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  YoutubeVideoVC(
                    tag: "search",
                    key: youtubeVideoKey,
                    isLoading: (isLoading) {
                      changeYoutubeLoader(isLoading);
                    },
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeYoutubeLoader(bool isLoading) {
    if (youtubeVideoController.videos.isEmpty) {
      loaderController.setLoading(isLoading);
    } else {
      youtubeVideoController.setIsLoading(isLoading);
    }
  }

  void changeSearchType(String? value) {
    pageController.jumpToPage(searchPlatfromIndex(value));
    searchController.clear();
    searchValue = null;
    setState(() {});
    if (isYoutubeSearch) {
      youtubeVideoKey.currentState?.callYoutubeSearch(searchValue: searchValue);
    }
  }

  void onSearch(String? value) {
    if ((value ?? "").trim().isNotEmpty) {
      searchValue = value;
      setState(() {});
      if (isYoutubeSearch) {
        youtubeVideoController.clear();
        youtubeVideoKey.currentState?.callYoutubeSearch(
          searchValue: searchValue,
        );
      }
    }
  }

  String get searchPlatfromType {
    switch (pageController.hasClients ? pageController.page?.toInt() : 1) {
      case 0:
        return "YouTube";
      case 1:
        return "FocusTube";
      default:
        return "FocusTube";
    }
  }

  int searchPlatfromIndex(String? value) {
    switch (value) {
      case "YouTube":
        return 0;
      case "FocusTube":
        return 1;
      default:
        return 1;
    }
  }

  bool get isYoutubeSearch {
    return pageController.hasClients
        ? pageController.page?.toInt() == 0
        : false;
  }

  @override
  bool get wantKeepAlive => true;
}
