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

class LoginVC extends StatefulWidget {
  static const id = "/sign-in";

  const LoginVC({super.key});

  @override
  State<LoginVC> createState() => _LoginVCState();
}

class _LoginVCState extends State<LoginVC> {
  bool showPassword = false;
  late TextEditingController emailController, passwordController;
  LoaderController loaderController = controller<LoaderController>(
    tag: "/sign-in",
  );

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    loaderController.setLoading(false);
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context, automaticallyImplyLeading: false),
        body: ExpandedSingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: FormScreenBoundries(
            child: Form(
              key: signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back to ${AppConst.appName}",
                    style: AppTextStyle.title40(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 15),
                  AppTextFormField(
                    label: "Password",
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your password",
                    textInputAction: TextInputAction.done,
                    obscureText: !showPassword,
                    validator: (value) {
                      if (!value!.isPassword) {
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text(
                        "Forgot password?",
                        style: AppTextStyle.body16(color: AppColor.gray),
                      ),
                      onPressed: () {
                        forgotPassword.go(context);
                      },
                    ),
                  ),
                  Expanded(child: Container()),
                  SizedBox(height: 30),
                  AppButton(
                    label: "Sign in",
                    backgroundColor: AppColor.primary,
                    onTap: () async {
                      if (signInFormKey.currentState!.validate()) {
                        loaderController.setLoading(true);
                        var isLoginSuccess = await ApiFunctions.instance.login(
                          context,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        loaderController.setLoading(false);
                        if (isLoginSuccess) {
                          if (controller<UserController>().user?.emailActive !=
                              "y") {
                            ApiFunctions.instance.resendVerifyCode(context);
                            emailVerification.off(context);
                          } else {
                            home.off(context);
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "New to ${AppConst.appName}? ",
                        style: AppTextStyle.body16(color: AppColor.gray),
                        children: [
                          TextSpan(
                            text: "Sign up",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                signUp.off(context);
                              },
                            style: AppTextStyle.body16(),
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
