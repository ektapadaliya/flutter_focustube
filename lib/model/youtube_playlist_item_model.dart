class YoutubePlaylistModel {
  String? kind;
  String? etag;
  String? id;
  Snippet? snippet;
  ContentDetails? contentDetails;

  YoutubePlaylistModel({
    this.kind,
    this.etag,
    this.id,
    this.snippet,
    this.contentDetails,
  });

  YoutubePlaylistModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
    snippet = json['snippet'] != null
        ? Snippet.fromJson(json['snippet'])
        : null;
    contentDetails = json['contentDetails'] != null
        ? ContentDetails.fromJson(json['contentDetails'])
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
  String? playlistId;
  int? position;
  ResourceId? resourceId;
  String? videoOwnerChannelTitle;
  String? videoOwnerChannelId;

  Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.playlistId,
    this.position,
    this.resourceId,
    this.videoOwnerChannelTitle,
    this.videoOwnerChannelId,
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
    playlistId = json['playlistId'];
    position = json['position'];
    resourceId = json['resourceId'] != null
        ? ResourceId.fromJson(json['resourceId'])
        : null;
    videoOwnerChannelTitle = json['videoOwnerChannelTitle'];
    videoOwnerChannelId = json['videoOwnerChannelId'];
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
    data['playlistId'] = playlistId;
    data['position'] = position;
    if (resourceId != null) {
      data['resourceId'] = resourceId!.toJson();
    }
    data['videoOwnerChannelTitle'] = videoOwnerChannelTitle;
    data['videoOwnerChannelId'] = videoOwnerChannelId;
    return data;
  }
}

class Thumbnails {
  Thumbnail? inital;
  Thumbnail? medium;
  Thumbnail? high;
  Thumbnail? standard;
  Thumbnail? maxres;

  Thumbnails({this.inital, this.medium, this.high, this.standard, this.maxres});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    inital = json['default'] != null
        ? Thumbnail.fromJson(json['default'])
        : null;
    medium = json['medium'] != null ? Thumbnail.fromJson(json['medium']) : null;
    high = json['high'] != null ? Thumbnail.fromJson(json['high']) : null;
    standard = json['standard'] != null
        ? Thumbnail.fromJson(json['standard'])
        : null;
    maxres = json['maxres'] != null ? Thumbnail.fromJson(json['maxres']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inital != null) {
      data['default'] = inital!.toJson();
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

class Thumbnail {
  String? url;
  int? width;
  int? height;

  Thumbnail({this.url, this.width, this.height});

  Thumbnail.fromJson(Map<String, dynamic> json) {
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

class ResourceId {
  String? kind;
  String? videoId;

  ResourceId({this.kind, this.videoId});

  ResourceId.fromJson(Map<String, dynamic> json) {
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

class ContentDetails {
  String? videoId;
  String? videoPublishedAt;

  ContentDetails({this.videoId, this.videoPublishedAt});

  ContentDetails.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    videoPublishedAt = json['videoPublishedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoId'] = videoId;
    data['videoPublishedAt'] = videoPublishedAt;
    return data;
  }
}
