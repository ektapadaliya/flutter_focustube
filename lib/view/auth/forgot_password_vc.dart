import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/const/validators.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/service/encrypt_service.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
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

  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  LoaderController loaderController = controller<LoaderController>(
    tag: "/forgot-password",
  );
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
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context),
        body: ExpandedSingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: FormScreenBoundries(
            child: Form(
              key: forgotPasswordFormKey,
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
                    validator: (value) {
                      if (!(value!.isEmail)) {
                        return Validators.emailValidation;
                      }
                      return null;
                    },
                  ),
                  Expanded(flex: 3, child: Container()),
                  SizedBox(height: 30),
                  AppButton(
                    label: "Continue",
                    backgroundColor: AppColor.primary,
                    onTap: () async {
                      if (forgotPasswordFormKey.currentState!.validate()) {
                        loaderController.setLoading(true);
                        var isForgotPasswordSuccess = await ApiFunctions
                            .instance
                            .forgotPassword(
                              context,
                              email: emailController.text.trim(),
                            );
                        loaderController.setLoading(false);
                        if (isForgotPasswordSuccess) {
                          forgotPasswordVerification.go(
                            context,
                            id: EncryptService.encrypt(emailController.text),
                          );
                        }
                      }
                    },
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
