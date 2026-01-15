class VideoModel {
  int? id;
  String? channelId;
  String? subjectId;
  String? subSubjectId;
  String? youtubeId;
  String? title;
  int? videoViews;
  bool? isBookmark;
  String? status;
  int? createdAt;

  VideoModel({
    this.id,
    this.channelId,
    this.subjectId,
    this.subSubjectId,
    this.youtubeId,
    this.title,
    this.videoViews,
    this.isBookmark,
    this.status,
    this.createdAt,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    subjectId = json['subject_id'];
    subSubjectId = json['sub_subject_id'];
    youtubeId = json['youtube_id'];
    title = json['title'];
    videoViews = json['video_views'];
    isBookmark = json['is_bookmark'] == 1;
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_id'] = channelId;
    data['subject_id'] = subjectId;
    data['sub_subject_id'] = subSubjectId;
    data['youtube_id'] = youtubeId;
    data['title'] = title;
    data['video_views'] = videoViews;
    data['is_bookmark'] = (isBookmark ?? false) ? 1 : 0;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
