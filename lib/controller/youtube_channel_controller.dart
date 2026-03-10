import 'package:get/get.dart';

import '../model/youtube_channel_model.dart';

class YoutubeChannelController extends GetxController {
  static final List<YoutubeChannelModel> _channels = <YoutubeChannelModel>[];
  List<YoutubeChannelModel> get channels => _channels;

  static String _nextPageToken = '';
  String get nextPageToken => _nextPageToken;

  static bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addChannels(List<YoutubeChannelModel> channels) {
    for (var element in channels) {
      int index = _channels.indexWhere(
        (x) => x.id?.channelId == element.id?.channelId,
      );
      if (index == -1) {
        _channels.add(element);
      }
    }
    update();
  }

  void setNextPageToken(String nextPageToken) {
    _nextPageToken = nextPageToken;
    update();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    update();
  }

  void clear() {
    channels.clear();
    _nextPageToken = '';
    _isLoading = false;
    update();
  }
}
