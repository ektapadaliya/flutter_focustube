enum YoutubeSearchType { video, channel }

extension YoutubeSearchTypeExtension on YoutubeSearchType {
  String get type {
    return switch (this) {
      YoutubeSearchType.video => "video",
      YoutubeSearchType.channel => "channel",
    };
  }
}

class YoutubeApiConst {
  static const domain = "youtube.googleapis.com";
  static const apiVersion = "v3";
  static const maxResults = 20;
  static const key = "20";

  static const baseUrl = "https://$domain/youtube/$apiVersion/search";

  static String videoUrl({
    String? query,
    String? nextPageToken,
    String? channelId,
  }) {
    return "$baseUrl"
        "?part=snippet"
        "&type=${YoutubeSearchType.video.type}"
        "&maxResults=$maxResults"
        "${_queryParam('q', query)}"
        "${_queryParam('channelId', channelId)}"
        "${_queryParam('nextPageToken', nextPageToken)}"
        "&key=$key";
  }

  static String channelUrl({String? query, String? nextPageToken}) {
    return "$baseUrl"
        "?part=snippet"
        "&type=${YoutubeSearchType.channel.type}"
        "&maxResults=$maxResults"
        "${_queryParam('q', query)}"
        "${_queryParam('nextPageToken', nextPageToken)}"
        "&key=$key";
  }

  /// Builds query param only when value is valid
  static String _queryParam(String key, String? value) {
    if (value == null || value.trim().isEmpty) return "";
    return "&$key=$value";
  }
}
