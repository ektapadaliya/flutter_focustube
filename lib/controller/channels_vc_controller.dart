import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelsVCController extends GetxController {
  // Static private variables (persist app-wide)
  static int _selectedIndex = 0;
  static final PageController _pageController = PageController(
    initialPage: _selectedIndex,
  );
  static final ScrollController _categoryScrollController = ScrollController();
  static final List<GlobalKey> _categoryKeys = List.generate(
    5,
    (_) => GlobalKey(),
  );

  // Public getters to access variables in the View
  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;
  ScrollController get categoryScrollController => _categoryScrollController;
  List<GlobalKey> get categoryKeys => _categoryKeys;

  /// Called in the View's initState or GetBuilder's initState
  void init() {
    // Ensure the UI and scroll position match the static index on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToItem(_selectedIndex, isAnimated: false);
    });
  }

  /// Central method to change pages and scroll the tab bar
  void jumpToPage(int index) {
    _selectedIndex = index;
    update(); // Notifies GetBuilder to rebuild UI

    if (_pageController.hasClients) {
      _pageController.jumpToPage(index);
    }

    _scrollToItem(index);
  }

  /// Private helper to handle the horizontal scrolling logic
  void _scrollToItem(int index, {bool isAnimated = true}) {
    if (index >= _categoryKeys.length) return;

    final ctx = _categoryKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: isAnimated
            ? const Duration(milliseconds: 300)
            : Duration.zero,
        alignment: 0.5,
        curve: Curves.easeInOut,
      );
    }
  }
}
