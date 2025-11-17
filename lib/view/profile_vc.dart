import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/service/image_services.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          widget.isFromEdit ? "Edit My Profile" : "My Profile",
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
              child: Stack(
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

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.isFromEdit
                          ? editProfileWidgets()
                          : profileWidgets(),
                    ),
                  ),
                  Positioned(
                    top: -65,
                    left: (MediaQuery.of(context).size.width / 2) - 65,
                    child: InkWell(
                      onTap: () async {
                        image = await ImageService.pickImage(context);
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
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> editProfileWidgets() => [
    SizedBox(height: 55),
    AppTextFormField(label: "First Name", hintText: "Enter First Name"),
    SizedBox(height: 20),
    AppTextFormField(label: "Last Name", hintText: "Enter Last Name"),
    Expanded(child: Container()),
    SizedBox(height: 30),
    Center(
      child: AppButton(label: "Save", backgroundColor: AppColor.primary),
    ),
    SizedBox(height: 30),
  ];
  List<Widget> profileWidgets() => [
    SizedBox(height: 55),
    _buildProfileTile("First name", "Leslie"),
    SizedBox(height: 20),
    _buildProfileTile("Last name", "Alexander"),
    SizedBox(height: 20),
    _buildProfileTile("Email", "lesliealexander@gmail.com"),
    SizedBox(height: 20),
    _buildProfileTile("My interests", "Physics"),
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
