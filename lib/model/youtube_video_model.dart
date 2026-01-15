import 'package:html_unescape/html_unescape.dart';

class YoutubeVideoModel {
  String? kind;
  String? etag;
  _Id? id;
  _Snippet? snippet;

  YoutubeVideoModel({this.kind, this.etag, this.id, this.snippet});

  YoutubeVideoModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'] != null ? _Id.fromJson(json['id']) : null;
    snippet = json['snippet'] != null
        ? _Snippet.fromJson(json['snippet'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    if (id != null) {
      data['id'] = id!.toJson();
    }
    if (snippet != null) {
      data['snippet'] = snippet!.toJson();
    }
    return data;
  }
}

class _Id {
  String? kind;
  String? videoId;

  _Id({this.kind, this.videoId});

  _Id.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    videoId = json['videoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['videoId'] = videoId;
    return data;
  }
}

class _Snippet {
  String? publishedAt;
  String? channelId;
  String? title;
  String? description;
  _Thumbnails? thumbnails;
  String? channelTitle;
  String? liveBroadcastContent;
  String? publishTime;

  _Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.liveBroadcastContent,
    this.publishTime,
  });

  _Snippet.fromJson(Map<String, dynamic> json) {
    publishedAt = json['publishedAt'];
    channelId = json['channelId'];
    title = HtmlUnescape().convert(json['title']);
    description = HtmlUnescape().convert(json['description']);
    thumbnails = json['thumbnails'] != null
        ? _Thumbnails.fromJson(json['thumbnails'])
        : null;
    channelTitle = HtmlUnescape().convert(json['channelTitle']);
    liveBroadcastContent = json['liveBroadcastContent'];
    publishTime = json['publishTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['publishedAt'] = publishedAt;
    data['channelId'] = channelId;
    data['title'] = title;
    data['description'] = description;
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.toJson();
    }
    data['channelTitle'] = channelTitle;
    data['liveBroadcastContent'] = liveBroadcastContent;
    data['publishTime'] = publishTime;
    return data;
  }
}

class _Thumbnails {
  _Thumbnail? small;
  _Thumbnail? medium;
  _Thumbnail? high;

  _Thumbnails({this.small, this.medium, this.high});

  _Thumbnails.fromJson(Map<String, dynamic> json) {
    small = json['default'] != null
        ? _Thumbnail.fromJson(json['default'])
        : null;
    medium = json['medium'] != null
        ? _Thumbnail.fromJson(json['medium'])
        : null;
    high = json['high'] != null ? _Thumbnail.fromJson(json['high']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (small != null) {
      data['default'] = small!.toJson();
    }
    if (medium != null) {
      data['medium'] = medium!.toJson();
    }
    if (high != null) {
      data['high'] = high!.toJson();
    }
    return data;
  }
}

class _Thumbnail {
  String? url;
  int? width;
  int? height;

  _Thumbnail({this.url, this.width, this.height});

  _Thumbnail.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
