import 'package:focus_tube_flutter/model/video_model.dart';

class DailyGoalVideoListModel {
  int? id;
  String? subjectId;
  String? subjectTitle;
  String? dailyGoal;
  int? totalDailyCompletedGoalBySubject;
  List<VideoModel>? videos;
  int? createdAt;

  DailyGoalVideoListModel({
    this.id,
    this.subjectId,
    this.subjectTitle,
    this.dailyGoal,
    this.totalDailyCompletedGoalBySubject,
    this.videos,
    this.createdAt,
  });

  DailyGoalVideoListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subject_id'];
    subjectTitle = json['subject_title'];
    dailyGoal = json['daily_goal'];
    totalDailyCompletedGoalBySubject =
        json['total_daily_completed_goal_by_subject'];
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
    data['subject_id'] = subjectId;
    data['subject_title'] = subjectTitle;
    data['daily_goal'] = dailyGoal;
    data['total_daily_completed_goal_by_subject'] =
        totalDailyCompletedGoalBySubject;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}
