class PlaylistModel {
  int? id;
  String? userId;
  String? title;
  int? totalVideos;
  int? createdAt;

  PlaylistModel({
    this.id,
    this.userId,
    this.title,
    this.totalVideos,
    this.createdAt,
  });

  PlaylistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    totalVideos = json['total_videos'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['total_videos'] = totalVideos;
    data['created_at'] = createdAt;
    return data;
  }
}
