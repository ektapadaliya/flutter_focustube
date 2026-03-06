import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/const/validators.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ResetPasswordVC extends StatefulWidget {
  static const id = "/reset-password";
  const ResetPasswordVC({super.key, required this.email, required this.code});

  final String email;
  final String code;

  @override
  State<ResetPasswordVC> createState() => _ResetPasswordVCState();
}

class _ResetPasswordVCState extends State<ResetPasswordVC> {
  late TextEditingController passwordController, confirmPasswordController;
  bool showPassword = false;
  bool showConfirmPassword = false;
  LoaderController loaderController = controller<LoaderController>(
    tag: "/reset-password",
  );

  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
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
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context),
        body: ExpandedSingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: FormScreenBoundries(
            child: Form(
              key: resetPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reset password!", style: AppTextStyle.title28()),
                  Text(
                    "Create new password!",
                    style: AppTextStyle.body18(color: AppColor.gray),
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
                    validator: (value) {
                      if (!(value?.trim().isPassword ?? true)) {
                        return Validators.passwordValidation(field: "Password");
                      }
                      return null;
                    },
                    suffixIcon: AppInkWell(
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
                        color: AppColor.primary,
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
                    validator: (value) {
                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        return "Password does not match";
                      } else if (!(value?.trim().isPassword ?? true)) {
                        return Validators.passwordValidation(
                          field: "Confirm Password",
                        );
                      }
                      return null;
                    },
                    suffixIcon: AppInkWell(
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
                        color: AppColor.primary,
                      ),
                    ),
                  ),

                  Expanded(flex: 3, child: Container()),
                  SizedBox(height: 30),
                  AppButton(
                    label: "Continue",
                    backgroundColor: AppColor.primary,
                    onTap: () async {
                      if (resetPasswordFormKey.currentState!.validate()) {
                        loaderController.setLoading(true);
                        var isResetPasswordSuccess = await ApiFunctions.instance
                            .resetPassword(
                              context,
                              email: widget.email,
                              code: widget.code,
                              password: passwordController.text.trim(),
                              confirmPassword: confirmPasswordController.text
                                  .trim(),
                            );
                        loaderController.setLoading(false);
                        if (isResetPasswordSuccess) {
                          signIn.off(context);
                        }
                      }
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
                                AppNavigationModel.untilFirst(context);
                                signIn.off(context);
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
        ),
      ),
    );
  }
}
