class SubSubjectModel {
  final int id;
  final String title;
  bool isSelected;

  SubSubjectModel({
    required this.id,
    required this.title,
    this.isSelected = false,
  });

  // From JSON
  factory SubSubjectModel.fromJson(Map<String, dynamic> json) {
    return SubSubjectModel(id: json['id'], title: json['title']);
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
