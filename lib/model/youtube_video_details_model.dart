class YoutubeVideoDetailModel {
  String? kind;
  String? etag;
  String? id;
  Snippet? snippet;
  ContentDetails? contentDetails;
  Statistics? statistics;

  YoutubeVideoDetailModel({
    this.kind,
    this.etag,
    this.id,
    this.snippet,
    this.contentDetails,
    this.statistics,
  });

  YoutubeVideoDetailModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
    snippet = json['snippet'] != null
        ? Snippet.fromJson(json['snippet'])
        : null;
    contentDetails = json['contentDetails'] != null
        ? ContentDetails.fromJson(json['contentDetails'])
        : null;
    statistics = json['statistics'] != null
        ? Statistics.fromJson(json['statistics'])
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

class Snippet {
  String? publishedAt;
  String? channelId;
  String? title;
  String? description;
  Thumbnails? thumbnails;
  String? channelTitle;
  String? categoryId;
  String? liveBroadcastContent;
  String? defaultLanguage;
  Localized? localized;
  String? defaultAudioLanguage;

  Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.categoryId,
    this.liveBroadcastContent,
    this.defaultLanguage,
    this.localized,
    this.defaultAudioLanguage,
  });

  Snippet.fromJson(Map<String, dynamic> json) {
    publishedAt = json['publishedAt'];
    channelId = json['channelId'];
    title = json['title'];
    description = json['description'];
    thumbnails = json['thumbnails'] != null
        ? Thumbnails.fromJson(json['thumbnails'])
        : null;
    channelTitle = json['channelTitle'];
    categoryId = json['categoryId'];
    liveBroadcastContent = json['liveBroadcastContent'];
    defaultLanguage = json['defaultLanguage'];
    localized = json['localized'] != null
        ? Localized.fromJson(json['localized'])
        : null;
    defaultAudioLanguage = json['defaultAudioLanguage'];
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
    data['categoryId'] = categoryId;
    data['liveBroadcastContent'] = liveBroadcastContent;
    data['defaultLanguage'] = defaultLanguage;
    if (localized != null) {
      data['localized'] = localized!.toJson();
    }
    data['defaultAudioLanguage'] = defaultAudioLanguage;
    return data;
  }
}

class ThumbnailData {
  String? url;
  int? width;
  int? height;

  ThumbnailData({this.url, this.width, this.height});

  ThumbnailData.fromJson(Map<String, dynamic> json) {
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

class Localized {
  String? title;
  String? description;

  Localized({this.title, this.description});

  Localized.fromJson(Map<String, dynamic> json) {
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

class ContentDetails {
  String? duration;
  String? dimension;
  String? definition;
  String? caption;
  bool? licensedContent;
  String? projection;

  ContentDetails({
    this.duration,
    this.dimension,
    this.definition,
    this.caption,
    this.licensedContent,
    this.projection,
  });

  ContentDetails.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    dimension = json['dimension'];
    definition = json['definition'];
    caption = json['caption'];
    licensedContent = json['licensedContent'];
    projection = json['projection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['dimension'] = dimension;
    data['definition'] = definition;
    data['caption'] = caption;
    data['licensedContent'] = licensedContent;

    data['projection'] = projection;
    return data;
  }
}

class Statistics {
  String? viewCount;
  String? likeCount;
  String? favoriteCount;
  String? commentCount;

  Statistics({
    this.viewCount,
    this.likeCount,
    this.favoriteCount,
    this.commentCount,
  });

  Statistics.fromJson(Map<String, dynamic> json) {
    viewCount = json['viewCount'];
    likeCount = json['likeCount'];
    favoriteCount = json['favoriteCount'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['viewCount'] = viewCount;
    data['likeCount'] = likeCount;
    data['favoriteCount'] = favoriteCount;
    data['commentCount'] = commentCount;
    return data;
  }
}

class Thumbnails {
  ThumbnailData? thumbnailData;
  ThumbnailData? medium;
  ThumbnailData? high;
  ThumbnailData? standard;
  ThumbnailData? maxres;

  Thumbnails({
    this.thumbnailData,
    this.medium,
    this.high,
    this.standard,
    this.maxres,
  });

  Thumbnails.fromJson(Map<String, dynamic> json) {
    thumbnailData = json['default'] != null
        ? ThumbnailData.fromJson(json['default'])
        : null;
    medium = json['medium'] != null
        ? ThumbnailData.fromJson(json['medium'])
        : null;
    high = json['high'] != null ? ThumbnailData.fromJson(json['high']) : null;
    standard = json['standard'] != null
        ? ThumbnailData.fromJson(json['standard'])
        : null;
    maxres = json['maxres'] != null
        ? ThumbnailData.fromJson(json['maxres'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (thumbnailData != null) {
      data['default'] = thumbnailData!.toJson();
    }
    if (medium != null) {
      data['medium'] = medium!.toJson();
    }
    if (high != null) {
      data['high'] = high!.toJson();
    }
    if (standard != null) {
      data['standard'] = standard!.toJson();
    }
    if (maxres != null) {
      data['maxres'] = maxres!.toJson();
    }
    return data;
  }
}
