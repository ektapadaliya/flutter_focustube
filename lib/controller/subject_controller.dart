import 'package:focus_tube_flutter/model/subject_model.dart';
import 'package:get/get.dart';

import 'app_controller.dart';

class SubjectController extends GetxController {
  List<SubjectModel> subjcts = [];

  void addSubject(List<SubjectModel> subjcts) {
    for (var element in subjcts) {
      var index = this.subjcts.indexWhere((e) => e.id == element.id);
      if (index == -1) {
        this.subjcts.add(element);
      } else {
        this.subjcts[index] = element;
      }
    }
    update();
  }

  LoaderController get loaderController =>
      controller<LoaderController>(tag: "subject-selection");
  void setIsLoading(bool isLoading) {
    controller<LoaderController>(
      tag: "subject-selection",
    ).setLoading(isLoading);
  }

  bool hasData = true;

  void setHasData(bool hasData) {
    this.hasData = hasData;
    update();
  }

  void changeSubjectSelectedStatus(int id, {bool? value}) {
    var index = subjcts.indexWhere((e) => e.id == id);
    if (index != -1) {
      subjcts[index].isUserSubject =
          value ?? !(subjcts[index].isUserSubject ?? false);
      update();
    }
  }

  void changeSubSubjectSelectedStatus(
    int subjectId,
    int subSubjectId, {
    bool? value,
  }) {
    final subjectIndex = subjcts.indexWhere((s) => s.id == subjectId);

    if (subjectIndex == -1) return;

    final subject = subjcts[subjectIndex];
    final subSubjects = subject.subSubjects;

    if (subSubjects == null || subSubjects.isEmpty) return;

    final subIndex = subSubjects.indexWhere((ss) => ss.id == subSubjectId);

    if (subIndex == -1) return;

    final current = subSubjects[subIndex].isUserSubject ?? false;
    subSubjects[subIndex].isUserSubject = value ?? !current;
    subject.isUserSubject = subSubjects.any((ss) => ss.isUserSubject == true);

    update();
  }

  int page = 1;

  void incPage() {
    page++;
    update();
  }

  void clear() {
    subjcts.clear();
    page = 1;
    loaderController.setLoading(false);
    update();
  }
}
