import 'package:get/get.dart';

import 'interest_controller.dart';
import 'loader_cotroller.dart';
import 'user_controller.dart';

export 'user_controller.dart';
export 'loader_cotroller.dart';
export 'interest_controller.dart';

T controller<T>({String? tag}) {
  return Get.isRegistered<T>(tag: tag)
      ? Get.find<T>(tag: tag)
      : _putController<T>(tag: tag);
}

_putController<T>({String? tag}) {
  switch (T) {
    case const (UserController):
      return Get.put(UserController(), tag: tag);
    case const (LoaderController):
      return Get.put(LoaderController(), tag: tag);
    case const (InterestController):
      return Get.put(InterestController(), tag: tag);
    default:
      return null;
  }
}
