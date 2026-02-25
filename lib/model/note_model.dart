class NoteModel {
  int? id;
  String? videoId;
  String? title;
  String? description;
  int? createdAt;

  NoteModel({
    this.id,
    this.videoId,
    this.title,
    this.description,
    this.createdAt,
  });

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoId = json['video_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['video_id'] = videoId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }
}
