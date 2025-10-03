import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/service/image_services.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/checkbox_tile.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class CreateAccountVC extends StatefulWidget {
  static const id = "/sign-up";
  const CreateAccountVC({super.key});

  @override
  State<CreateAccountVC> createState() => _CreateAccountVCState();
}

class _CreateAccountVCState extends State<CreateAccountVC> {
  bool isTermsAccepted = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  late TextEditingController firstNameController,
      lastNameController,
      emailController,
      passwordController,
      confirmPasswordController;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  dynamic selectedImage;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: FormScreenBoundries(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create your account", style: AppTextStyle.title28()),
              Text(
                "Please enter your details to continue.",
                style: AppTextStyle.body18(color: AppColor.gray),
              ),
              SizedBox(height: 25),
              Center(
                child: InkWell(
                  onTap: () async {
                    var image = await ImageService.pickImage(context);
                    if (image != null) {
                      selectedImage = image;
                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: [
                      DottedBorder(
                        options: CircularDottedBorderOptions(
                          dashPattern: [12, 8],
                          strokeWidth: 3,
                          color: AppColor.textFieldBorder,
                        ),
                        child: NetworkImageClass(
                          width: 140,
                          height: 140,
                          image: selectedImage,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.primary,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            String.fromCharCode(Icons.add_rounded.codePoint),
                            style: TextStyle(
                              package: Icons.add_rounded.fontPackage,
                              fontFamily: Icons.add_rounded.fontFamily,
                              height: 1,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              AppTextFormField(
                label: "First name",
                hintText: "Enter your first name",
                controller: firstNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),
              AppTextFormField(
                label: "Last name",
                hintText: "Enter your last name",
                controller: lastNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),
              AppTextFormField(
                label: "Email",
                hintText: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),
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

              SizedBox(height: 15),
              AppCheckBoxTile(
                isSelected: isTermsAccepted,
                onChanged: (value) =>
                    setState(() => isTermsAccepted = value ?? false),
                title: Text.rich(
                  TextSpan(
                    text: "By continuing your confirm that you agree with our ",
                    style: AppTextStyle.body16(color: AppColor.gray),
                    children: [
                      TextSpan(
                        text: "Terms And Conditions",
                        style: AppTextStyle.body16().copyWith(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            content.go(context, id: 't');
                          },
                      ),
                      TextSpan(text: " and ", style: AppTextStyle.body16()),
                      TextSpan(
                        text: "Privacy Policy",
                        style: AppTextStyle.body16().copyWith(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            content.go(context, id: 'p');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              AppButton(
                label: "Sign up",
                backgroundColor: AppColor.primary,
                onTap: () {
                  emailVerification.go(context);
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
    );
  }
}
