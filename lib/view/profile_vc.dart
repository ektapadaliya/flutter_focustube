import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/const/validators.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/service/image_services.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';

class ProfileVC extends StatefulWidget {
  static const id = "/profile";
  static const editid = "$id/edit";
  const ProfileVC({super.key, this.isFromEdit = false});
  final bool isFromEdit;
  @override
  State<ProfileVC> createState() => _ProfileVCState();
}

class _ProfileVCState extends State<ProfileVC> {
  File? image;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  var authController = controller<UserController>();
  var intrestController = controller<InterestController>();
  var loaderController = controller<LoaderController>(tag: "/profile");
  @override
  void initState() {
    firstNameController.text = authController.user?.firstName ?? "";
    lastNameController.text = authController.user?.lastName ?? "";
    super.initState();
    Future.delayed(Duration.zero, () async {
      loaderController.setLoading(true);
      if (intrestController.interests.isEmpty) {
        await ApiFunctions.instance.interests(context);
      }
      if (intrestController.userInterests.isEmpty) {
        await ApiFunctions.instance.getUserInterests(context);
      }
      loaderController.setLoading(false);
    });
  }

  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: Scaffold(
        backgroundColor: AppColor.profileBackground,
        appBar: sizeZeroAppBar(
          context,
          color: AppColor.profileBackground,
          brightness: Platform.isAndroid ? Brightness.light : Brightness.dark,
        ),
        body: ExpandedSingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImage.profileBackground),
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4.5,
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Row(
                    children: [
                      BackButton(color: AppColor.white),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 60),
                          child: Text(
                            widget.isFromEdit
                                ? "Edit My Profile"
                                : "My Profile",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.title20(color: AppColor.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GetBuilder(
                  init: authController,
                  builder: (authController) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              image: AssetImage(AppImage.background),
                              fit: BoxFit.fill,
                            ),
                          ),

                          child: Form(
                            key: profileFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.isFromEdit
                                  ? editProfileWidgets(authController)
                                  : profileWidgets(authController),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -65,
                          left: (MediaQuery.of(context).size.width / 2) - 65,
                          child: InkWell(
                            onTap: () async {
                              image = await ImageService.pickImage(context);
                              setState(() {});
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.lightGray,
                                    border: Border.all(
                                      color: AppColor.white,
                                      width: 5,
                                    ),
                                  ),
                                  child: NetworkImageClass(
                                    shape: BoxShape.circle,
                                    image:
                                        image ?? authController.user?.imageUrl,
                                  ),
                                ),
                                if (widget.isFromEdit)
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.primary,
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        AppImage.editIcon,
                                        colorFilter: ColorFilter.mode(
                                          AppColor.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> editProfileWidgets(UserController authController) => [
    SizedBox(height: 60),
    AppTextFormField(
      label: "First name",
      hintText: "Enter your first name",
      controller: firstNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      validator: (value) {
        if (!(value?.trim().nameValidator ?? true)) {
          return "Please enter your first name";
        }
        return null;
      },
    ),
    SizedBox(height: 15),
    AppTextFormField(
      label: "Last name",
      hintText: "Enter your last name",
      controller: lastNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      validator: (value) {
        if (!(value?.trim().nameValidator ?? true)) {
          return "Please enter your last name";
        }
        return null;
      },
    ),
    Expanded(child: Container()),
    SizedBox(height: 30),
    Center(
      child: AppButton(
        label: "Save",
        backgroundColor: AppColor.primary,
        onTap: () async {
          if (profileFormKey.currentState!.validate() && widget.isFromEdit) {
            loaderController.setLoading(true);
            bool isSuccess = await ApiFunctions.instance.editProfile(
              context,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              image: image,
            );

            loaderController.setLoading(false);
            if (isSuccess) {
              context.pop();
            }
          }
        },
      ),
    ),
    SizedBox(height: 30),
  ];
  List<Widget> profileWidgets(UserController authController) => [
    SizedBox(height: 60),
    _buildProfileTile("First name", authController.user?.firstName ?? ""),
    SizedBox(height: 20),
    _buildProfileTile("Last name", authController.user?.lastName ?? ""),
    SizedBox(height: 20),
    _buildProfileTile("Email", authController.user?.email ?? ""),
    SizedBox(height: 20),
    _buildProfileTile(
      "My interests",
      intrestController.selectedInterests.map((e) => e.title).join(", "),
    ),
    Expanded(child: Container()),
    Center(
      child: AppButton(
        label: "Edit profile",
        backgroundColor: AppColor.primary,
        onTap: () {
          editProfile.go(context);
        },
      ),
    ),
    SizedBox(height: 30),
  ];
  Widget _buildProfileTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyle.body14(color: AppColor.gray)),
        Text(value, style: AppTextStyle.body20()),
      ],
    );
  }
}
