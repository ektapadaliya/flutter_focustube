class InterestModel {
  int? id;
  String? title;
  String? imageUrl;
  String? status;
  int? createdAt;

  InterestModel({
    this.id,
    this.title,
    this.imageUrl,
    this.status,
    this.createdAt,
  });

  InterestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image_url'] = imageUrl;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
