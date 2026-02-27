class ChannelModel {
  int? id;
  String? youtubeId;
  String? title;
  String? description;
  String? imageUrl;
  String? followers;
  int? totalVideos;
  int? createdAt;

  ChannelModel({
    this.id,
    this.youtubeId,
    this.title,
    this.description,
    this.imageUrl,
    this.followers,
    this.totalVideos,
    this.createdAt,
  });

  ChannelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    youtubeId = json['youtube_id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image_url'];
    followers = json['followers'];
    totalVideos = json['total_videos'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['youtube_id'] = youtubeId;
    data['title'] = title;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['followers'] = followers;
    data['total_videos'] = totalVideos;
    data['created_at'] = createdAt;
    return data;
  }
}
