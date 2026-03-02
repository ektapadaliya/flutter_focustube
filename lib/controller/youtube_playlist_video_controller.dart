import 'package:focus_tube_flutter/model/youtube_playlist_item_model.dart';
import 'package:get/get.dart';

class YoutubePlaylistVideoController extends GetxController {
  List<YoutubePlaylistModel> playListVideos = <YoutubePlaylistModel>[];

  String nextPageToken = '';
  bool isLoading = false;

  void addVideos(List<YoutubePlaylistModel> playListVideos) {
    for (var playListVideo in playListVideos) {
      if (!this.playListVideos.any(
        (element) => element.id == playListVideo.id,
      )) {
        this.playListVideos.add(playListVideo);
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
    playListVideos.clear();
    nextPageToken = '';
    isLoading = false;
    update();
  }
}
