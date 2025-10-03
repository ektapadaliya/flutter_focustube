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

class ForgotPasswordVC extends StatefulWidget {
  static const id = "/forgot-password";
  const ForgotPasswordVC({super.key});

  @override
  State<ForgotPasswordVC> createState() => _ForgotPasswordVCState();
}

class _ForgotPasswordVCState extends State<ForgotPasswordVC> {
  late TextEditingController emailController;
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context),
      body: ExpandedSingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: FormScreenBoundries(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Forgot your password!", style: AppTextStyle.title28()),
              Text(
                "Please enter your email to reset your password.",
                style: AppTextStyle.body18(color: AppColor.gray),
              ),
              SizedBox(height: 25),
              Expanded(child: Container()),
              AppTextFormField(
                label: "Email",
                hintText: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              Expanded(flex: 3, child: Container()),
              SizedBox(height: 30),
              AppButton(
                label: "Continue",
                backgroundColor: AppColor.primary,
                onTap: () {
                  forgotPasswordVerification.go(context);
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Part of ${AppConst.appName}? ",
                    style: AppTextStyle.body16(color: AppColor.gray),
                    children: [
                      TextSpan(
                        text: "Login",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            signIn.replace(context);
                          },
                        style: AppTextStyle.body16(color: AppColor.primary),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
