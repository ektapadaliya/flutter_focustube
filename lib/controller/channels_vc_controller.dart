import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChannelsVCController extends GetxController {
  static const int categoryCount = 5;

  final PageController pageController = PageController(initialPage: 0);
  final ItemScrollController categoryScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final RxInt selectedIndex = 0.obs;

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(selectedIndex.value);
    });
  }

  void jumpToPage(int index) {
    selectedIndex.value = index;
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
    if (categoryScrollController.isAttached) {
      categoryScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: .2,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
