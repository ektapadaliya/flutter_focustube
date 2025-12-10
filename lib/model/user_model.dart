class UserModel {
  int? id;
  String? type;
  String? firstName;
  String? lastName;
  String? image;
  String? imageUrl;
  String? email;
  String? status;
  String? emailActive;
  Preference? preference;
  int? createdAt;

  UserModel({
    this.id,
    this.type,
    this.firstName,
    this.lastName,
    this.image,
    this.imageUrl,
    this.email,
    this.status,
    this.emailActive,
    this.preference,
    this.createdAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    imageUrl = json['image_url'];
    email = json['email'];
    status = json['status'];
    emailActive = json['email_active'];
    preference = json['preference'] != null
        ? Preference.fromJson(json['preference'])
        : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    data['image_url'] = imageUrl;
    data['email'] = email;
    data['status'] = status;
    data['email_active'] = emailActive;
    if (preference != null) {
      data['preference'] = preference!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class Preference {
  int? id;
  String? userId;
  String? notification;
  String? dailyVideoLimit;
  int? createdAt;

  Preference({
    this.id,
    this.userId,
    this.notification,
    this.dailyVideoLimit,
    this.createdAt,
  });

  Preference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    notification = json['notification'];
    dailyVideoLimit = json['daily_video_limit'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['notification'] = notification;
    data['daily_video_limit'] = dailyVideoLimit;
    data['created_at'] = createdAt;
    return data;
  }
}
