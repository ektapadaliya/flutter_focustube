import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/model/youtube_channel_detail_model.dart';
import 'package:focus_tube_flutter/model/youtube_channel_model.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';

import '../model/youtube_video_model.dart';
import 'package:http/http.dart' as http;

enum YoutubeSearchType { video, channel }

extension YoutubeSearchTypeExtension on YoutubeSearchType {
  String get type {
    return switch (this) {
      YoutubeSearchType.video => "video",
      YoutubeSearchType.channel => "channel",
    };
  }
}

class YoutubeApiConst {
  static const domain = "youtube.googleapis.com";
  static const apiVersion = "v3";
  static const maxResults = 20;
  static const key = "AIzaSyCVOpMHoEFha-UotxJcHzeggWesnzUYoAk";

  static const baseUrl = "https://$domain/youtube/$apiVersion";
  static const searchUrl = "$baseUrl/search";
  static const channelUrl = "$baseUrl/channels";

  static String searchVideoUrl({
    String? query,
    String? nextPageToken,
    String? channelId,
  }) {
    return "$searchUrl"
        "?part=snippet"
        "&type=${YoutubeSearchType.video.type}"
        "&maxResults=$maxResults"
        "${_queryParam('q', query)}"
        "${_queryParam('channelId', channelId)}"
        "${_queryParam('pageToken', nextPageToken)}"
        "&key=$key";
  }

  static String searchChannelUrl({String? query, String? nextPageToken}) {
    return "$searchUrl"
        "?part=snippet"
        "&type=${YoutubeSearchType.channel.type}"
        "&maxResults=$maxResults"
        "${_queryParam('q', query)}"
        "${_queryParam('pageToken', nextPageToken)}"
        "&key=$key";
  }

  static String channelDetailsUrl({required String id}) {
    return "$channelUrl"
        "?part=snippet,statistics,contentDetails"
        "&id=$id"
        "&key=$key";
  }

  /// Builds query param only when value is valid
  static String _queryParam(String key, String? value) {
    if (value == null || value.trim().isEmpty) return "";
    return "&$key=$value";
  }

  /// Fetches youtube videos
  static Future<Map<String, dynamic>?> fetchYoutubeVideos(
    BuildContext context, {
    String? query,
    String? nextPageToken,
    String? channelId,
  }) async {
    final response = await http.get(
      Uri.parse(
        YoutubeApiConst.searchVideoUrl(
          query: query,
          nextPageToken: nextPageToken,
          channelId: channelId,
        ),
      ),
    );
    debugPrint("Youtube api Url :${response.request?.url.toString()}");
    debugPrint("Youtube api Status Code :${response.statusCode}");
    debugPrint("Youtube api Body :${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videos = (data['items'] as List)
          .map((e) => YoutubeVideoModel.fromJson(e))
          .toList();
      return {"videos": videos, "nextPageToken": data['nextPageToken']};
    } else {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Failed to load videos",
        isError: true,
      );
    }
    return null;
  }

  static Future<Map<String, dynamic>?> fetchYoutubeChannels(
    BuildContext context, {
    String? query,
    String? nextPageToken,
  }) async {
    final response = await http.get(
      Uri.parse(
        YoutubeApiConst.searchChannelUrl(
          query: query,
          nextPageToken: nextPageToken,
        ),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final channels = (data['items'] as List)
          .map((e) => YoutubeChannelModel.fromJson(e))
          .toList();
      return {"channels": channels, "nextPageToken": data['nextPageToken']};
    } else {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Failed to load channels",
        isError: true,
      );
    }
    return null;
  }

  static Future<YoutubeChannelDetailModel?> fetchYoutubeChannelDetails(
    BuildContext context, {
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse(YoutubeApiConst.channelDetailsUrl(id: id)),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final channel = (data['items'] as List)
          .map((e) => YoutubeChannelDetailModel.fromJson(e))
          .toList()
          .firstOrNull;
      return channel;
    } else {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Failed to load channel details",
        isError: true,
      );
    }
    return null;
  }

  static thubnailFromId(String id) =>
      "https://img.youtube.com/vi/$id/hqdefault.jpg";
}
