class SubSubjectModel {
  int? id;
  String? subjectId;
  String? title;
  String? status;
  bool? isUserSubject;

  int? createdAt;

  SubSubjectModel({
    this.id,
    this.subjectId,
    this.title,
    this.isUserSubject,

    this.status,
    this.createdAt,
  });

  SubSubjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isUserSubject = json['is_user_subject'] == 1;
    subjectId = json['subject_id'];
    title = json['title'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject_id'] = subjectId;
    data['title'] = title;
    data['is_user_subject'] = (isUserSubject ?? false) ? 1 : 0;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
