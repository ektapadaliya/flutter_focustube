import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    this.appBar,
    this.isInSafeArea = true,
    required this.body,
    this.floatingActionButton,
  });
  final Widget body;
  final bool isInSafeArea;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          top: isInSafeArea,
          bottom: isInSafeArea,
          left: isInSafeArea,
          right: isInSafeArea,
          child: body,
        ),
        floatingActionButton: floatingActionButton,
        backgroundColor: Colors.transparent,
        appBar: appBar ?? sizeZeroAppBar(context),
      ),
    );
  }
}
