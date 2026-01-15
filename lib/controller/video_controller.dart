import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/video_model.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  VideoController(this.tag);
  String? tag;
  List<VideoModel> videos = [];

  void addVideos(List<VideoModel> videos) {
    for (var element in videos) {
      var index = this.videos.indexWhere((e) => e.id == element.id);
      if (index == -1) {
        this.videos.add(element);
      } else {
        this.videos[index] = element;
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

  void changeBookmarkStatus(String id, {bool? value}) {
    var index = videos.indexWhere((e) => e.id.toString() == id);
    if (index != -1) {
      videos[index].isBookmark = value ?? !(videos[index].isBookmark ?? false);
      update();
    }
  }

  void removeVideo(String id) {
    videos.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    videos.clear();
    page = 1;
    loaderController.setLoading(false);
    update();
  }
}
