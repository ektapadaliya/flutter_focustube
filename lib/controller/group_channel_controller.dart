import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/channel_group_model.dart';
import 'package:get/get.dart';

class GroupChannelController extends GetxController {
  GroupChannelController(this.tag);
  String? tag;
  List<ChannelGroupModel> groups = [];

  void addGroup(List<ChannelGroupModel> groups) {
    for (var element in groups) {
      var index = this.groups.indexWhere((e) => e.id == element.id);
      if (index == -1) {
        this.groups.add(element);
      } else {
        this.groups[index] = element;
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

  void removeGroup(String id) {
    groups.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    groups.clear();
    page = 1;
    hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
