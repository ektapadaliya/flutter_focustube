import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/channel_model.dart';
import 'package:get/get.dart';

class ChannelController extends GetxController {
  ChannelController(this.tag);
  String? tag;
  List<ChannelModel> channels = [];

  void addChannel(List<ChannelModel> channels) {
    for (var element in channels) {
      var index = this.channels.indexWhere((e) => e.id == element.id);
      if (index == -1) {
        this.channels.add(element);
      } else {
        this.channels[index] = element;
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

  void removeChannel(String id) {
    channels.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    channels.clear();
    page = 1;
    hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
