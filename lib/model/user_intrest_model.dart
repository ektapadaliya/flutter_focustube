class UserInterestModel {
  int? id;
  String? userId;
  String? interestId;
  int? createdAt;

  UserInterestModel({this.id, this.userId, this.interestId, this.createdAt});

  UserInterestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['interest_id'] = interestId;
    data['created_at'] = createdAt;
    return data;
  }
}
