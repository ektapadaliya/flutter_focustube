import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:get/state_manager.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';
import '../../widget/app_button.dart';

class IsAuth extends StatefulWidget {
  const IsAuth({
    super.key,
    this.message = "Please login to continue",
    required this.child,
    this.withScreenBackground = true,

    this.dispose,
    this.initState,
    this.afterInitState,
  });
  final String message;
  final Widget child;
  final bool withScreenBackground;
  final void Function()? initState, dispose, afterInitState;
  @override
  State<IsAuth> createState() => _IsAuthState();
}

class _IsAuthState extends State<IsAuth> {
  var userController = controller<UserController>();
  @override
  void initState() {
    if (widget.initState != null && userController.user != null) {
      widget.initState!();
    }
    super.initState();
    if (widget.afterInitState != null && userController.user != null) {
      widget.afterInitState!();
    }
  }

  @override
  void dispose() {
    if (widget.dispose != null && userController.user != null) {
      widget.dispose!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: userController,
      builder: (userController) {
        if (userController.user != null) {
          return widget.child;
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImage.appIconLightTransperent, height: 100),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.title18(color: AppColor.gray),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: AppButton(
                    backgroundColor: AppColor.primary,
                    label: "Login",
                    onTap: () {
                      signIn.go(context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
