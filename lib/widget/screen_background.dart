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

class FormScreenBoundries extends StatefulWidget {
  const FormScreenBoundries({super.key, required this.child});
  final Widget child;
  @override
  State<FormScreenBoundries> createState() => _FormScreenBoundriesState();
}

class _FormScreenBoundriesState extends State<FormScreenBoundries> {
  @override
  Widget build(BuildContext context) {
    bool isLandScap =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: isLandScap ? BoxConstraints(maxWidth: 700) : null,
        child: widget.child,
      ),
    );
  }
}
