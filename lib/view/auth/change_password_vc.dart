import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/const/validators.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordVC extends StatefulWidget {
  static const id = "/change-password";
  const ChangePasswordVC({super.key});

  @override
  State<ChangePasswordVC> createState() => _ChangePasswordVCState();
}

class _ChangePasswordVCState extends State<ChangePasswordVC> {
  late TextEditingController oldPasswordController,
      passwordController,
      confirmPasswordController;

  bool showOldPassword = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  LoaderController loaderController = controller<LoaderController>(
    tag: "/change-password",
  );

  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    oldPasswordController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
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
              key: changePasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Change password!", style: AppTextStyle.title28()),
                  Text(
                    "Change your old password!",
                    style: AppTextStyle.body18(color: AppColor.gray),
                  ),
                  SizedBox(height: 25),
                  Expanded(child: Container()),
                  AppTextFormField(
                    label: "Old Password",
                    controller: oldPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your old password",
                    textInputAction: TextInputAction.next,
                    obscureText: !showOldPassword,
                    validator: (value) {
                      if (!(value?.trim().isPassword ?? true)) {
                        return Validators.passwordValidation(
                          field: "Old Password",
                        );
                      }
                      return null;
                    },
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          showOldPassword = !showOldPassword;
                        });
                      },
                      child: Icon(
                        showOldPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 25,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  AppTextFormField(
                    label: "Password",
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your password",
                    textInputAction: TextInputAction.next,
                    obscureText: !showPassword,
                    validator: (value) {
                      if (!(value?.trim().isPassword ?? true)) {
                        return Validators.passwordValidation();
                      }
                      return null;
                    },
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
                        color: AppColor.primary,
                      ),
                    ),
                  ),

                  Expanded(flex: 3, child: Container()),
                  SizedBox(height: 30),
                  AppButton(
                    label: "Change",
                    backgroundColor: AppColor.primary,
                    onTap: () async {
                      if (changePasswordFormKey.currentState!.validate()) {
                        loaderController.setLoading(true);
                        var isResetPasswordSuccess = await ApiFunctions.instance
                            .changePassword(
                              context,
                              oldPassword: oldPasswordController.text.trim(),
                              newPassword: passwordController.text.trim(),
                              confirmPassword: confirmPasswordController.text
                                  .trim(),
                            );
                        loaderController.setLoading(false);
                        if (isResetPasswordSuccess) {
                          context.pop();
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
