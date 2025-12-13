import 'package:focus_tube_flutter/model/youtube_video_model.dart';
import 'package:get/get.dart';

class YoutubeVideoController extends GetxController {
  List<YoutubeVideoModel> videos = <YoutubeVideoModel>[];

  String nextPageToken = '';
  bool isLoading = false;

  void addVideos(List<YoutubeVideoModel> videos) {
    for (var video in videos) {
      if (!this.videos.any(
        (element) => element.id?.videoId == video.id?.videoId,
      )) {
        this.videos.add(video);
      }
    }
    update();
  }

  void setNextPageToken(String nextPageToken) {
    this.nextPageToken = nextPageToken;
    update();
  }

  void setIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    update();
  }

  void clear() {
    videos.clear();
    nextPageToken = '';
    isLoading = false;
    update();
  }
}
