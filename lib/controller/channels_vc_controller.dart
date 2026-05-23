import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TabScrollController extends GetxController {
  TabScrollController(this.categoryCount);
  final int categoryCount;

  late final PageController pageController;
  final ItemScrollController categoryScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final RxInt selectedIndex = 0.obs;

  void init() {
    pageController = PageController(initialPage: selectedIndex.value);
    update();
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

TabScrollController channelTabScrollController =
    controller<TabScrollController>(tag: "channel-vc", data: 5);
