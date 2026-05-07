import 'package:focus_tube_flutter/model/channel_model.dart';

class GroupModel {
  int? id;
  String? title;
  List<ChannelModel>? channels;
  int? createdAt;

  GroupModel({this.id, this.title, this.channels, this.createdAt});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['channels'] != null) {
      channels = <ChannelModel>[];
      json['channels'].forEach((v) {
        channels!.add(ChannelModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (channels != null) {
      data['channels'] = channels!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}
