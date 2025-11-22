import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/checkbox_tile.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

import '../../model/sub_subject_model.dart';
import '../../model/subject_model.dart';

class SelectSubjectVC extends StatefulWidget {
  static const id = "/select-subject";
  final bool isFromNav;
  const SelectSubjectVC({super.key, this.isFromNav = false});

  @override
  State<SelectSubjectVC> createState() => _SelectSubjectVCState();
}

class _SelectSubjectVCState extends State<SelectSubjectVC> {
  @override
  Widget build(BuildContext context) {
    var child = Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: sampleSubjects.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) {
              var subject = sampleSubjects[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.borderColor),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  children: [
                    Container(
                      decoration: subject.isSelected
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
                          subject.title,
                          style: AppTextStyle.title18(),
                        ),
                        isExpaned: true,
                        align: AppCheckBoxTileAlign.right,
                        onChanged: (value) {
                          subject.onSelectionChanged(value ?? false);
                          setState(() {});
                        },
                        isSelected: subject.isSelected,
                      ),
                    ),
                    if (subject.isSelected)
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
                          itemCount: subject.subSubjects.length,
                          itemBuilder: (context, index) {
                            var subSubject = subject.subSubjects[index];
                            return AppCheckBoxTile(
                              title: Text(
                                subSubject.title,
                                style: AppTextStyle.body16(),
                              ),
                              isExpaned: true,
                              align: AppCheckBoxTileAlign.right,
                              onChanged: (value) {
                                subSubject.isSelected = value ?? false;
                                setState(() {});
                              },
                              isSelected: subSubject.isSelected,
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

final List<Subject> sampleSubjects = [
  Subject(
    id: 1,
    title: "Mathematics",
    subSubjects: [
      SubSubjectModel(id: 101, title: "Algebra"),
      SubSubjectModel(id: 102, title: "Geometry"),
      SubSubjectModel(id: 103, title: "Trigonometry"),
      SubSubjectModel(id: 104, title: "Calculus"),
      SubSubjectModel(id: 105, title: "Statistics & Probability"),
    ],
  ),
  Subject(
    id: 2,
    title: "Science",
    subSubjects: [
      SubSubjectModel(id: 201, title: "Physics"),
      SubSubjectModel(id: 202, title: "Chemistry"),
      SubSubjectModel(id: 203, title: "Biology"),
      SubSubjectModel(id: 204, title: "Environmental Science"),
      SubSubjectModel(id: 205, title: "Astronomy"),
    ],
  ),
  Subject(
    id: 3,
    title: "Computer Science",
    subSubjects: [
      SubSubjectModel(id: 301, title: "Programming Fundamentals"),
      SubSubjectModel(id: 302, title: "Data Structures & Algorithms"),
      SubSubjectModel(id: 303, title: "Databases"),
      SubSubjectModel(id: 304, title: "Operating Systems"),
      SubSubjectModel(id: 305, title: "Computer Networks"),
    ],
  ),
  Subject(
    id: 4,
    title: "English Language",
    subSubjects: [
      SubSubjectModel(id: 401, title: "Grammar"),
      SubSubjectModel(id: 402, title: "Vocabulary"),
      SubSubjectModel(id: 403, title: "Reading Comprehension"),
      SubSubjectModel(id: 404, title: "Writing Skills"),
      SubSubjectModel(id: 405, title: "Spoken English"),
    ],
  ),
  Subject(
    id: 5,
    title: "History",
    subSubjects: [
      SubSubjectModel(id: 501, title: "Ancient History"),
      SubSubjectModel(id: 502, title: "Medieval History"),
      SubSubjectModel(id: 503, title: "Modern History"),
      SubSubjectModel(id: 504, title: "World Wars"),
      SubSubjectModel(id: 505, title: "Indian Freedom Movement"),
    ],
  ),
  Subject(
    id: 6,
    title: "Geography",
    subSubjects: [
      SubSubjectModel(id: 601, title: "Physical Geography"),
      SubSubjectModel(id: 602, title: "Human Geography"),
      SubSubjectModel(id: 603, title: "Climate & Weather"),
      SubSubjectModel(id: 604, title: "World Maps"),
      SubSubjectModel(id: 605, title: "Natural Resources"),
    ],
  ),
  Subject(
    id: 7,
    title: "Economics",
    subSubjects: [
      SubSubjectModel(id: 701, title: "Microeconomics"),
      SubSubjectModel(id: 702, title: "Macroeconomics"),
      SubSubjectModel(id: 703, title: "Business Economics"),
      SubSubjectModel(id: 704, title: "International Trade"),
      SubSubjectModel(id: 705, title: "Economic Policies"),
    ],
  ),
  Subject(
    id: 8,
    title: "Accounting & Finance",
    subSubjects: [
      SubSubjectModel(id: 801, title: "Basic Accounting"),
      SubSubjectModel(id: 802, title: "Cost Accounting"),
      SubSubjectModel(id: 803, title: "Financial Management"),
      SubSubjectModel(id: 804, title: "Taxation"),
      SubSubjectModel(id: 805, title: "Auditing"),
    ],
  ),
  Subject(
    id: 9,
    title: "Information Technology",
    subSubjects: [
      SubSubjectModel(id: 901, title: "Web Development"),
      SubSubjectModel(id: 902, title: "Mobile App Development"),
      SubSubjectModel(id: 903, title: "Cyber Security"),
      SubSubjectModel(id: 904, title: "Cloud Computing"),
      SubSubjectModel(id: 905, title: "AI & Machine Learning"),
    ],
  ),
  Subject(
    id: 10,
    title: "General Knowledge",
    subSubjects: [
      SubSubjectModel(id: 1001, title: "Current Affairs"),
      SubSubjectModel(id: 1002, title: "Sports"),
      SubSubjectModel(id: 1003, title: "Politics"),
      SubSubjectModel(id: 1004, title: "Awards & Recognitions"),
      SubSubjectModel(id: 1005, title: "Science & Technology Updates"),
    ],
  ),
];
