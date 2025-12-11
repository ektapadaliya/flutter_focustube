import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/model/interest_model.dart';
import 'package:focus_tube_flutter/model/user_intrest_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/image_classes.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChooseYourInterestVC extends StatefulWidget {
  static const id = "/choose-your-interest";
  static const editId = "/edit-your-interest";
  const ChooseYourInterestVC({super.key, this.isFromEdit = false});
  final bool isFromEdit;
  @override
  State<ChooseYourInterestVC> createState() => _ChooseYourInterestVCState();
}

class _ChooseYourInterestVCState extends State<ChooseYourInterestVC> {
  LoaderController loaderController = controller<LoaderController>(
    tag: "/interests",
  );
  var interestController = controller<InterestController>();
  List<UserInterestModel> selectedInterests = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      loaderController.setLoading(true);
      if (interestController.interests.isEmpty) {
        await ApiFunctions.instance.interests(context);
      }
      await ApiFunctions.instance.getUserInterests(context);
      selectedInterests = interestController.userInterests;
      setState(() {});
      loaderController.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: widget.isFromEdit
            ? customAppBar(context, title: "Choose My Interests")
            : null,
        body: ExpandedSingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              if (!widget.isFromEdit) ...[
                Text("Choose your Interests", style: AppTextStyle.title28()),
                Text(
                  "Get personalized recommendations",
                  style: AppTextStyle.body18(color: AppColor.gray),
                ),
                SizedBox(height: 20),
              ],

              GetBuilder(
                init: interestController,
                builder: (interestController) {
                  return Wrap(
                    runSpacing: 20,
                    spacing: 15,
                    children: List.generate(
                      interestController.interests.length,
                      (index) {
                        var interest = interestController.interests[index];
                        return InterestTile(
                          interest: interest,
                          isSelected: selectedInterests
                              .where(
                                (e) => e.interestId == interest.id.toString(),
                              )
                              .isNotEmpty,
                          onTap: () {
                            if (selectedInterests
                                .where(
                                  (e) => e.interestId == interest.id.toString(),
                                )
                                .isNotEmpty) {
                              selectedInterests.removeWhere(
                                (e) => e.interestId == interest.id.toString(),
                              );
                            } else {
                              selectedInterests.add(
                                UserInterestModel(
                                  interestId: interest.id.toString(),
                                ),
                              );
                            }
                            setState(() {});
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              Expanded(child: Container()),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: AppButton(
                  label: widget.isFromEdit ? "Save" : "Continue",
                  backgroundColor: AppColor.primary,
                  onTap: () async {
                    if (selectedInterests.isNotEmpty) {
                      loaderController.setLoading(true);
                      bool isUpdated = await ApiFunctions.instance
                          .updateInterests(
                            context,
                            interestsIds: selectedInterests
                                .map((e) => e.interestId ?? "")
                                .toList(),
                          );
                      loaderController.setLoading(false);
                      if (isUpdated) {
                        if (widget.isFromEdit) {
                          context.pop();
                        } else {
                          dailyLimit.off(context);
                        }
                      }
                    } else {
                      AppTostMessage.snackBarMessage(
                        context,
                        message: "Please select at least one interest",
                        isError: true,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InterestTile extends StatelessWidget {
  const InterestTile({
    super.key,
    required this.interest,
    required this.onTap,
    required this.isSelected,
  });
  final InterestModel interest;
  final void Function() onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.lightGray,
          ),
          borderRadius: BorderRadius.circular(33),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NetworkImageClass(
              image: interest.imageUrl ?? "",
              height: 23,
              width: 23,
              color: isSelected ? AppColor.white : AppColor.primary,
            ),
            SizedBox(width: 10),
            Text(
              interest.title ?? "",
              style: AppTextStyle.body16(
                color: isSelected ? AppColor.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
