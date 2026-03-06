class DailyVideoLimitModel {
  String? dailyVideoLimit;
  int? dailyViews;

  DailyVideoLimitModel({this.dailyVideoLimit, this.dailyViews});

  DailyVideoLimitModel.fromJson(Map<String, dynamic> json) {
    dailyVideoLimit = json['daily_video_limit'];
    dailyViews = json['daily_views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['daily_video_limit'] = dailyVideoLimit;
    data['daily_views'] = dailyViews;
    return data;
  }
}
