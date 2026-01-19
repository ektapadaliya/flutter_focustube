import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/subject_video_model.dart';
import 'package:get/get.dart';

class SubjectVideoController extends GetxController {
  SubjectVideoController(this.tag);
  String? tag;
  List<SubjectVideoModel> subjects = [];

  void addVideos(List<SubjectVideoModel> subjects) {
    for (var element in subjects) {
      var index = this.subjects.indexWhere((e) => e.id == element.id);
      if (index == -1) {
        this.subjects.add(element);
      } else {
        this.subjects[index] = element;
      }
    }
    update();
  }

  LoaderController get loaderController =>
      controller<LoaderController>(tag: tag);
  void setIsLoading(bool isLoading) {
    controller<LoaderController>(tag: tag).setLoading(isLoading);
  }

  bool hasData = true;

  void setHasData(bool hasData) {
    this.hasData = hasData;
    update();
  }

  int page = 1;

  void incPage() {
    page++;
    update();
  }

  void changeBookmarkStatus(String subjectId, String videoId, {bool? value}) {
    var index = subjects.indexWhere((e) => e.id.toString() == subjectId);
    if (index != -1) {
      var videoIndex = subjects[index].videos?.indexWhere(
        (e) => e.id.toString() == videoId,
      );
      if (videoIndex != null && videoIndex != -1) {
        subjects[index].videos![videoIndex].isBookmark =
            value ?? !(subjects[index].videos![videoIndex].isBookmark ?? false);
        update();
      }
    }
  }

  void clear() {
    subjects.clear();
    page = 1;
    hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
