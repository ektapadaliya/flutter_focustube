import 'package:focus_tube_flutter/model/sub_subject_model.dart';

class SubjectModel {
  int? id;
  String? title;
  String? status;
  bool? isUserSubject;
  List<SubSubjectModel>? subSubjects;
  int? createdAt;

  SubjectModel({
    this.id,
    this.title,
    this.status,
    this.isUserSubject,
    this.subSubjects,
    this.createdAt,
  });

  SubjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isUserSubject = json['is_user_subject'] == 1;
    if (json['sub_subjects'] != null) {
      subSubjects = <SubSubjectModel>[];
      json['sub_subjects'].forEach((v) {
        subSubjects!.add(SubSubjectModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['is_user_subject'] = (isUserSubject ?? false) ? 1 : 0;
    if (subSubjects != null) {
      data['sub_subjects'] = subSubjects!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}
