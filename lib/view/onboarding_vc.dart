import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingVC extends StatefulWidget {
  static const id = "/onboarding";
  const OnboardingVC({super.key});

  @override
  State<OnboardingVC> createState() => _OnboardingVCState();
}

class _OnboardingVCState extends State<OnboardingVC> {
  late PageController pageController;
  List<OnboardingPage> pages = [
    OnboardingPage(
      title: "Distraction-Free Learning & Viewing",
      description: "No ads, no comments, just focused study time.",
      imagePath: AppImage.onboarding1,
    ),
    OnboardingPage(
      title: "Curated Videos",
      description: "Explore Handpicked Content by educators and learners.",
      imagePath: AppImage.onboarding2,
    ),
    OnboardingPage(
      title: "Build Good Habits",
      description: "Daily queue and dashboard keep you on track.",
      imagePath: AppImage.onboarding3,
    ),
  ];
  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
    pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    pageController.removeListener(() {});
    pageController.dispose();
    super.dispose();
  }

  int get currentPage =>
      pageController.hasClients ? (pageController.page?.round() ?? 0) : 0;

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(
        context,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                signUp.go(context);
              },
              child: Text(
                "Skip",
                style: AppTextStyle.body20(color: AppColor.gray),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        itemCount: pages.length,

        itemBuilder: (context, index) {
          return ExpandedSingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(pages[index].imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pages[index].title,
                        style: AppTextStyle.title36(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        pages[index].description,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.body22(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(child: Container()),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(pages.length, (index) {
                    bool isSelected = index == currentPage;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.primary : AppColor.gray,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: currentPage == 0
                            ? null
                            : () {
                                if (currentPage > 0) {
                                  pageController.previousPage(
                                    duration: Durations.medium4,
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                        child: Text(
                          "Back",
                          style: AppTextStyle.title20(
                            color: currentPage == 0
                                ? AppColor.gray
                                : AppColor.primary,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      AppButton(
                        label: Icons.arrow_forward,
                        fontSize: 35,
                        backgroundColor: AppColor.primary,
                        onTap: () {
                          if (currentPage < 2) {
                            pageController.nextPage(
                              duration: Durations.medium4,
                              curve: Curves.easeIn,
                            );
                          } else {
                            signUp.go(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
