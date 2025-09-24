import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ResetPasswordVC extends StatefulWidget {
  static const id = "/reset-password";
  const ResetPasswordVC({super.key});

  @override
  State<ResetPasswordVC> createState() => _ResetPasswordVCState();
}

class _ResetPasswordVCState extends State<ResetPasswordVC> {
  late TextEditingController passwordController, confirmPasswordController;
  bool showPassword = false;
  bool showConfirmPassword = false;
  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context),
      body: ExpandedSingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reset password!", style: AppTextStyle.title28),
            Text(
              "Create new password!",
              style: AppTextStyle.body18.copyWith(color: AppColor.gray),
            ),
            SizedBox(height: 25),
            Expanded(child: Container()),
            AppTextFormField(
              label: "Password",
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: "Enter your password",
              textInputAction: TextInputAction.next,
              obscureText: !showPassword,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Icon(
                  showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 25,
                  color: AppColor.black,
                ),
              ),
            ),
            SizedBox(height: 15),
            AppTextFormField(
              label: "Confirm Password",
              controller: confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              hintText: "Enter your password",
              obscureText: !showConfirmPassword,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
                child: Icon(
                  showConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 25,
                  color: AppColor.black,
                ),
              ),
            ),

            Expanded(flex: 3, child: Container()),
            SizedBox(height: 30),
            AppButton(
              label: "Continue",
              backgroundColor: AppColor.black,
              onTap: () {},
            ),
            const SizedBox(height: 30),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Part of ${AppConst.appName}? ",
                  style: AppTextStyle.body16.copyWith(color: AppColor.gray),
                  children: [
                    TextSpan(
                      text: "Login",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppNavigationModel.untilFirst(context);
                          signIn.go(context);
                        },
                      style: AppTextStyle.body16.copyWith(
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
