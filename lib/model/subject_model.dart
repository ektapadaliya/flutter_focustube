import 'sub_subject_model.dart';

class Subject {
  final int id;
  final String title;
  final List<SubSubjectModel> subSubjects;

  Subject({required this.id, required this.title, required this.subSubjects});

  bool get isSelected => subSubjects.any((e) => e.isSelected == true);

  void onSelectionChanged(bool value) {
    for (var i = 0; i < subSubjects.length; i++) {
      subSubjects[i].isSelected = value;
    }
  }

  // From JSON
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      title: json['title'],
      subSubjects: (json['sub_subjects'] as List<dynamic>)
          .map((e) => SubSubjectModel.fromJson(e))
          .toList(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sub_subjects': subSubjects.map((e) => e.toJson()).toList(),
    };
  }
}
