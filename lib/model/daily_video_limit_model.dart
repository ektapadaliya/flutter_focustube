class DailyVideoLimitModel {
  String? dailyVideoLimit;
  String? dailyVideoTimeLimit;
  String? dailyVideoTimeSeen;
  int? dailyViews;

  DailyVideoLimitModel({
    this.dailyVideoLimit,
    this.dailyVideoTimeLimit,
    this.dailyVideoTimeSeen,
    this.dailyViews,
  });
  int dailyVideoTimeInMin({int? additionalSec}) {
    var sec =
        (int.tryParse(dailyVideoTimeLimit ?? "0") ?? 0) + (additionalSec ?? 0);
    return Duration(seconds: sec).inMinutes;
  }

  DailyVideoLimitModel.fromJson(Map<String, dynamic> json) {
    dailyVideoLimit = json['daily_video_limit'];
    dailyVideoTimeLimit = json['daily_video_time_limit'];
    dailyVideoTimeSeen = json['daily_video_time_seen'];
    dailyViews = json['daily_views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['daily_video_limit'] = dailyVideoLimit;
    data['daily_video_time_limit'] = dailyVideoTimeLimit;
    data['daily_video_time_seen'] = dailyVideoTimeSeen;
    data['daily_views'] = dailyViews;
    return data;
  }
}
