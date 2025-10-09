import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    this.appBar,
    this.isInSafeArea = true,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });
  final Widget body;
  final bool isInSafeArea;

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton, bottomNavigationBar;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImage.background),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox.fromSize(size: MediaQuery.sizeOf(context)),
        ),
        Scaffold(
          body: body,
          floatingActionButton: floatingActionButton,
          backgroundColor: Colors.transparent,
          appBar: appBar ?? sizeZeroAppBar(context),
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
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
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: AppConst.isLandscape(context)
            ? BoxConstraints(maxWidth: AppConst.kMaxLandscapeFormWidth)
            : null,
        child: widget.child,
      ),
    );
  }
}
