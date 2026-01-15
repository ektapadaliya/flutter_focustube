import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/subject_controller.dart';
import 'package:focus_tube_flutter/model/subject_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/checkbox_tile.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class SelectSubjectVC extends StatefulWidget {
  static const id = "/select-subject";
  final bool isFromNav;
  const SelectSubjectVC({super.key, this.isFromNav = false});

  @override
  State<SelectSubjectVC> createState() => _SelectSubjectVCState();
}

class _SelectSubjectVCState extends State<SelectSubjectVC> {
  var subjectController = controller<SubjectController>();
  @override
  Widget build(BuildContext context) {
    var child = Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: [].length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) {
              var subject = <SubjectModel>[][index];
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
                                bottom: BorderSide(color: AppColor.borderColor),
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
        SizedBox(height: 10),
        AppButton(label: "Save", backgroundColor: AppColor.primary),
      ],
    );
    if (widget.isFromNav) {
      return child;
    } else {
      return ScreenBackground(
        appBar: customAppBar(context, title: "Select Subject"),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ).copyWith(bottom: 15),
          child: child,
        ),
      );
    }
  }
}
