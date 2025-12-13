import 'package:html_unescape/html_unescape.dart';

class YoutubeChannelDetailModel {
  String? kind;
  String? etag;
  String? id;
  _Snippet? snippet;
  _ContentDetails? contentDetails;
  _Statistics? statistics;

  YoutubeChannelDetailModel({
    this.kind,
    this.etag,
    this.id,
    this.snippet,
    this.contentDetails,
    this.statistics,
  });

  YoutubeChannelDetailModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
    snippet = json['snippet'] != null
        ? _Snippet.fromJson(json['snippet'])
        : null;
    contentDetails = json['contentDetails'] != null
        ? _ContentDetails.fromJson(json['contentDetails'])
        : null;
    statistics = json['statistics'] != null
        ? _Statistics.fromJson(json['statistics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    data['id'] = id;
    if (snippet != null) {
      data['snippet'] = snippet!.toJson();
    }
    if (contentDetails != null) {
      data['contentDetails'] = contentDetails!.toJson();
    }
    if (statistics != null) {
      data['statistics'] = statistics!.toJson();
    }
    return data;
  }
}

class _Snippet {
  String? title;
  String? description;
  String? customUrl;
  String? publishedAt;
  _Thumbnails? thumbnails;
  _Localized? localized;
  String? country;

  _Snippet({
    this.title,
    this.description,
    this.customUrl,
    this.publishedAt,
    this.thumbnails,
    this.localized,
    this.country,
  });

  _Snippet.fromJson(Map<String, dynamic> json) {
    title = HtmlUnescape().convert(json['title']);
    description = HtmlUnescape().convert(json['description']);
    customUrl = json['customUrl'];
    publishedAt = json['publishedAt'];
    thumbnails = json['thumbnails'] != null
        ? _Thumbnails.fromJson(json['thumbnails'])
        : null;
    localized = json['localized'] != null
        ? _Localized.fromJson(json['localized'])
        : null;
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['customUrl'] = customUrl;
    data['publishedAt'] = publishedAt;
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.toJson();
    }
    if (localized != null) {
      data['localized'] = localized!.toJson();
    }
    data['country'] = country;
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

class _Localized {
  String? title;
  String? description;

  _Localized({this.title, this.description});

  _Localized.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class _ContentDetails {
  _RelatedPlaylists? relatedPlaylists;

  _ContentDetails({this.relatedPlaylists});

  _ContentDetails.fromJson(Map<String, dynamic> json) {
    relatedPlaylists = json['relatedPlaylists'] != null
        ? _RelatedPlaylists.fromJson(json['relatedPlaylists'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (relatedPlaylists != null) {
      data['relatedPlaylists'] = relatedPlaylists!.toJson();
    }
    return data;
  }
}

class _RelatedPlaylists {
  String? likes;
  String? uploads;

  _RelatedPlaylists({this.likes, this.uploads});

  _RelatedPlaylists.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
    uploads = json['uploads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes'] = likes;
    data['uploads'] = uploads;
    return data;
  }
}

class _Statistics {
  String? viewCount;
  String? subscriberCount;
  bool? hiddenSubscriberCount;
  String? videoCount;

  _Statistics({
    this.viewCount,
    this.subscriberCount,
    this.hiddenSubscriberCount,
    this.videoCount,
  });

  _Statistics.fromJson(Map<String, dynamic> json) {
    viewCount = json['viewCount'];
    subscriberCount = json['subscriberCount'];
    hiddenSubscriberCount = json['hiddenSubscriberCount'];
    videoCount = json['videoCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['viewCount'] = viewCount;
    data['subscriberCount'] = subscriberCount;
    data['hiddenSubscriberCount'] = hiddenSubscriberCount;
    data['videoCount'] = videoCount;
    return data;
  }

  String get formattedSubscriberCount {
    if (subscriberCount == null) return "0";
    double count = double.tryParse(subscriberCount!) ?? 0;

    if (count >= 1000000000) {
      return "${(count / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B";
    } else if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K";
    } else {
      return count.toStringAsFixed(0);
    }
  }
}
