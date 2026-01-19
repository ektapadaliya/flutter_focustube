class VideoModel {
  int? id;
  String? channelId;
  String? channelName;
  String? subjectId;
  String? subSubjectId;
  String? youtubeId;
  String? title;
  int? videoViews;
  bool? isBookmark;
  bool? isFeedback;
  String? status;
  int? createdAt;

  VideoModel({
    this.id,
    this.channelId,
    this.channelName,
    this.subjectId,
    this.subSubjectId,
    this.youtubeId,
    this.title,
    this.videoViews,
    this.isBookmark,
    this.isFeedback,
    this.status,
    this.createdAt,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    channelName = json['channel_name'];
    subjectId = json['subject_id'];
    subSubjectId = json['sub_subject_id'];
    youtubeId = json['youtube_id'];
    title = json['title'];
    videoViews = json['video_views'];
    isBookmark = json['is_bookmark'] == 1;
    isFeedback = json['is_feedback'] == 1;
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_id'] = channelId;
    data['channel_name'] = channelName;
    data['subject_id'] = subjectId;
    data['sub_subject_id'] = subSubjectId;
    data['youtube_id'] = youtubeId;
    data['title'] = title;
    data['video_views'] = videoViews;
    data['is_bookmark'] = (isBookmark ?? false) ? 1 : 0;
    data['is_feedback'] = (isFeedback ?? false) ? 1 : 0;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
