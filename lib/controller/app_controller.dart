import 'package:focus_tube_flutter/controller/playlist_controller.dart';
import 'package:focus_tube_flutter/controller/subject_controller.dart';
import 'package:focus_tube_flutter/controller/subject_video_controller.dart';
import 'package:get/get.dart';

import 'interest_controller.dart';
import 'loader_cotroller.dart';
import 'user_controller.dart';
import 'youtube_video_controller.dart';
import 'youtube_channel_controller.dart';
import 'video_controller.dart';

export 'user_controller.dart';
export 'loader_cotroller.dart';
export 'interest_controller.dart';
export 'youtube_video_controller.dart';
export 'youtube_channel_controller.dart';
export 'video_controller.dart';

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
    case const (YoutubeVideoController):
      return Get.put(YoutubeVideoController(), tag: tag);
    case const (YoutubeChannelController):
      return Get.put(YoutubeChannelController(), tag: tag);
    case const (VideoController):
      return Get.put(VideoController(tag), tag: tag);
    case const (SubjectController):
      return Get.put(SubjectController(tag), tag: tag);
    case const (SubjectVideoController):
      return Get.put(SubjectVideoController(tag), tag: tag);
    case const (PlaylistController):
      return Get.put(PlaylistController(tag), tag: tag);
    default:
      return null;
  }
}
