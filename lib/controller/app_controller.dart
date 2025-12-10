import 'package:get/get.dart';

import 'loader_cotroller.dart';
import 'user_controller.dart';

T controller<T>({String? tag}) {
  return Get.isRegistered<T>(tag: tag)
      ? Get.find<T>(tag: tag)
      : _putController<T>(tag: tag);
}

_putController<T>({String? tag}) {
  switch (T) {
    case const (UserController):
      return Get.put(UserController(), tag: tag);
    case const (LoaderCotroller):
      return Get.put(LoaderCotroller(), tag: tag);
    default:
      return null;
  }
}
