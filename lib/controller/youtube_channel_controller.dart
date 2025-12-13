import 'package:get/get.dart';

import '../model/youtube_channel_model.dart';

class YoutubeChannelController extends GetxController {
  List<YoutubeChannelModel> channels = <YoutubeChannelModel>[];

  String nextPageToken = '';
  bool isLoading = false;

  void addChannels(List<YoutubeChannelModel> channels) {
    for (var element in channels) {
      int index = this.channels.indexWhere(
        (x) => x.id?.channelId == element.id?.channelId,
      );
      if (index == -1) {
        this.channels.add(element);
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
    channels.clear();
    nextPageToken = '';
    isLoading = false;
    update();
  }
}
