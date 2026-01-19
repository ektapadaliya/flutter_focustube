import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/playlist_model.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {
  PlaylistController(this.tag);
  String? tag;
  List<PlaylistModel> playList = [];

  void addPlayList(List<PlaylistModel> playList) {
    for (var element in playList) {
      var index = this.playList.indexWhere((e) => e.id == element.id);
      if (index == -1) {
        this.playList.add(element);
      } else {
        this.playList[index] = element;
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

  void removeVideo(String id) {
    playList.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    playList.clear();
    page = 1;
    hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
