class AppInfo {
  int? id;
  String? device;
  String? currentVersion;
  String? minVersion;
  String? message;
  String? url;
  int? createdAt;

  AppInfo(
      {this.id,
      this.device,
      this.currentVersion,
      this.minVersion,
      this.message,
      this.url,
      this.createdAt});

  AppInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    device = json['device'];
    currentVersion = json['current_version'];
    minVersion = json['min_version'];
    message = json['message'];
    url = json['url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['device'] = device;
    data['current_version'] = currentVersion;
    data['min_version'] = minVersion;
    data['message'] = message;
    data['url'] = url;
    data['created_at'] = createdAt;
    return data;
  }
}
