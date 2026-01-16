import 'package:focus_tube_flutter/model/video_model.dart';

class SubjectVideoModel {
  int? id;
  String? title;
  List<VideoModel>? videos;
  int? createdAt;

  SubjectVideoModel({this.id, this.title, this.videos, this.createdAt});

  SubjectVideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['videos'] != null) {
      videos = <VideoModel>[];
      json['videos'].forEach((v) {
        videos!.add(VideoModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}
