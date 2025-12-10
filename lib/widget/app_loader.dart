import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/controller/loader_cotroller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.overlayColor,
    required this.child,
    this.loaderContainerColor,
    required this.loaderController,
  });
  final Widget child;
  final LoaderCotroller loaderController;
  final Color? overlayColor;
  final Color? loaderContainerColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Obx(() {
            if (loaderController.isLoading.value) {
              return InkWell(
                onTap: () {},
                child: Container(
                  color:
                      overlayColor ??
                      AppColor.profileBackground.opacityToAlpha(.2),
                  alignment: Alignment.center,
                  child: Container(),
                ),
              );
            } else {
              return Container();
            }
          }),
          Obx(() {
            if (loaderController.isLoading.value) {
              return Center(
                child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: loaderContainerColor ?? AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColor.primary,
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}
