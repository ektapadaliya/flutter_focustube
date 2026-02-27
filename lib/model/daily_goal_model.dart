class DailyGoalModel {
  int? id;
  String? title;
  String? dailyGoal;
  String? status;
  int? createdAt;

  DailyGoalModel({
    this.id,
    this.title,
    this.dailyGoal,
    this.status,
    this.createdAt,
  });

  DailyGoalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dailyGoal = json['daily_goal'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['daily_goal'] = dailyGoal;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
