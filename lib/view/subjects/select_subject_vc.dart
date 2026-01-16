import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/subject_controller.dart';
import 'package:focus_tube_flutter/model/sub_subject_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/checkbox_tile.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:get/get.dart';

class SelectSubjectVC extends StatefulWidget {
  static const id = "/select-subject";
  final bool isFromNav;
  const SelectSubjectVC({super.key, this.isFromNav = false});

  @override
  State<SelectSubjectVC> createState() => _SelectSubjectVCState();
}

class _SelectSubjectVCState extends State<SelectSubjectVC>
    with AutomaticKeepAliveClientMixin {
  late SubjectController subjectController;
  var scrollController = ScrollController();

  @override
  void initState() {
    subjectController = controller<SubjectController>(
      tag: widget.isFromNav ? "select-subject-home" : "select-subject",
    );
    super.initState();
    Future.delayed(Duration.zero, () async {
      await callApi();
    });
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (!subjectController.loaderController.isLoading.value &&
        subjectController.hasData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        await callApi(page: subjectController.page + 1);
        if (subjectController.hasData) {
          subjectController.incPage();
        }
      }
    }
  }

  Future<void> callApi({int page = 1}) async {
    await ApiFunctions.instance.getSubjects(
      context,
      page: page,
      controller: subjectController,
    );
  }

  @override
  void dispose() {
    subjectController.clear();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    subjectController.clear();
    callApi();
  }

  bool isUpdateLoading = false;
  @override
  Widget build(BuildContext context) {
    child(SubjectController subjectController) => Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              itemCount: subjectController.subjcts.length,
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                var subject = subjectController.subjcts[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    children: [
                      Container(
                        decoration: (subject.isUserSubject ?? false)
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColor.borderColor,
                                  ),
                                ),
                              )
                            : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        child: AppCheckBoxTile(
                          title: Text(
                            subject.title ?? "",
                            style: AppTextStyle.title18(),
                          ),
                          isExpaned: true,
                          align: AppCheckBoxTileAlign.right,
                          onChanged: (value) {
                            subjectController.changeSubjectSelectedStatus(
                              subject.id ?? 0,
                              value: value ?? false,
                            );
                            setState(() {});
                          },
                          isSelected: subject.isUserSubject ?? false,
                        ),
                      ),
                      if (subject.isUserSubject ?? false)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 15,
                            bottom: 10,
                            top: 5,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: subject.subSubjects?.length ?? 0,
                            itemBuilder: (context, index) {
                              var subSubject = subject.subSubjects![index];
                              return AppCheckBoxTile(
                                title: Text(
                                  subSubject.title ?? "",
                                  style: AppTextStyle.body16(),
                                ),
                                isExpaned: true,
                                align: AppCheckBoxTileAlign.right,
                                onChanged: (value) {
                                  subjectController
                                      .changeSubSubjectSelectedStatus(
                                        subject.id ?? 0,
                                        subSubject.id ?? 0,
                                        value: value ?? false,
                                      );
                                  setState(() {});
                                },
                                isSelected: subSubject.isUserSubject ?? false,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Obx(() {
          bool showLoader =
              !isUpdateLoading &&
              (subjectController.loaderController.isLoading.value &&
                  subjectController.subjcts.isNotEmpty);
          return Container(
            height: showLoader ? 50 : 10,
            width: MediaQuery.sizeOf(context).width,
            alignment: Alignment.center,
            child: showLoader ? CircularProgressIndicator() : null,
          );
        }),

        AppButton(
          label: "Save",
          backgroundColor: AppColor.primary,
          onTap: () async {
            var data = <SubSubjectModel>[];

            for (var element in subjectController.subjcts) {
              if ((element.isUserSubject ?? false) &&
                  (element.subSubjects?.isNotEmpty ?? false)) {
                data.addAll(
                  (element.subSubjects!).where((e) => e.isUserSubject ?? false),
                );
              }
            }
            setState(() {
              isUpdateLoading = true;
            });
            subjectController.setIsLoading(true);
            await ApiFunctions.instance.updateSubject(
              context,
              subSubject: data,
            );
            subjectController.setIsLoading(false);
            setState(() {
              isUpdateLoading = false;
            });
          },
        ),
      ],
    );
    return GetBuilder(
      tag: widget.isFromNav ? "select-subject-home" : "select-subject",
      init: subjectController,
      builder: (subjectController) {
        return AppLoader(
          overlayColor: Colors.transparent,
          showLoader: isUpdateLoading || subjectController.subjcts.isEmpty,
          loaderController: subjectController.loaderController,
          child: (widget.isFromNav)
              ? child(subjectController)
              : ScreenBackground(
                  appBar: customAppBar(context, title: "Select Subject"),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ).copyWith(bottom: 15),
                    child: child(subjectController),
                  ),
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
