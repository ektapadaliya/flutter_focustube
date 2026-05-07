import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/youtube_channel_detail_model.dart';
import 'package:focus_tube_flutter/model/youtube_channel_model.dart';
import 'package:focus_tube_flutter/model/youtube_playlist_item_model.dart';
import 'package:focus_tube_flutter/model/youtube_video_details_model.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';

import '../model/youtube_video_model.dart';
import 'package:http/http.dart' as http;

/// Defines the type of YouTube search — either a [video] or a [channel].
enum YoutubeSearchType { video, channel }

/// Extension on [YoutubeSearchType] to get the raw string value
/// expected by the YouTube Data API `type` parameter.
extension YoutubeSearchTypeExtension on YoutubeSearchType {
  String get type {
    return switch (this) {
      YoutubeSearchType.video => "video",
      YoutubeSearchType.channel => "channel",
    };
  }
}

/// Provides constants and static helper methods for interacting
/// with the YouTube Data API v3.
class YoutubeApiConst {
  /// YouTube API domain.
  static const domain = "youtube.googleapis.com";

  /// YouTube Data API version.
  static const apiVersion = "v3";

  /// Default maximum number of results per API request.
  static const maxResults = 20;

  /// YouTube Data API key.
  static const key = "AIzaSyCVOpMHoEFha-UotxJcHzeggWesnzUYoAk";

  /// Base URL for all YouTube Data API v3 endpoints.
  static const baseUrl = "https://$domain/youtube/$apiVersion";

  /// Endpoint for YouTube search queries.
  static const searchUrl = "$baseUrl/search";

  /// Endpoint for YouTube channel details.
  static const channelUrl = "$baseUrl/channels";

  /// Endpoint for YouTube video details.
  static const videosUrl = "$baseUrl/videos";

  /// Endpoint for YouTube playlist items.
  static const playlistItems = "$baseUrl/playlistItems";

  /// Builds a URL to search YouTube videos.
  ///
  /// [query] — keyword search term.
  /// [nextPageToken] — pagination token from a previous response.
  /// [channelId] — restricts results to a specific channel.
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

  /// Builds a URL to search YouTube channels.
  ///
  /// [query] — keyword search term.
  /// [nextPageToken] — pagination token from a previous response.
  static String searchChannelUrl({String? query, String? nextPageToken}) {
    return "$searchUrl"
        "?part=snippet"
        "&type=${YoutubeSearchType.channel.type}"
        "&maxResults=$maxResults"
        "${_queryParam('q', query)}"
        "${_queryParam('pageToken', nextPageToken)}"
        "&key=$key";
  }

  /// Builds a URL to fetch items from a YouTube playlist.
  ///
  /// [query] — optional keyword filter.
  /// [nextPageToken] — pagination token from a previous response.
  /// [playlistId] — the target playlist ID.
  static String playlistItemsUrl({
    String? query,
    String? nextPageToken,
    String? playlistId,
  }) {
    return "$playlistItems"
        "?part=snippet"
        "&type=${YoutubeSearchType.channel.type}"
        "&maxResults=$maxResults"
        "${_queryParam('q', query)}"
        "${_queryParam('playlistId', playlistId)}"
        "${_queryParam('pageToken', nextPageToken)}"
        "&key=$key";
  }

  /// Builds a URL to fetch snippet, statistics, and contentDetails
  /// for a YouTube channel by [id].
  static String channelDetailsUrl({required String id}) {
    return "$channelUrl"
        "?part=snippet,statistics,contentDetails"
        "&id=$id"
        "&key=$key";
  }

  /// Builds a URL to fetch snippet, statistics, and contentDetails
  /// for a YouTube video by [id].
  static String videoDetailsUrl({required String id}) {
    return "$videosUrl"
        "?part=snippet,statistics,contentDetails"
        "&id=$id"
        "&key=$key";
  }

  /// Returns an empty string when [value] is null or blank,
  /// otherwise returns `&key=value` to append to a URL.
  static String _queryParam(String key, String? value) {
    if (value == null || value.trim().isEmpty) return "";
    return "&$key=$value";
  }

  /// Fetches a paginated list of YouTube videos matching the given criteria.
  ///
  /// Returns a map with:
  /// - `"videos"` → `List<YoutubeVideoModel>`
  /// - `"nextPageToken"` → `String?` for the next page
  ///
  /// Returns `null` on failure and shows a snack bar error.
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

  /// Fetches a paginated list of items from a YouTube playlist.
  ///
  /// Returns a map with:
  /// - `"videos"` → `List<YoutubePlaylistModel>`
  /// - `"nextPageToken"` → `String?` for the next page
  ///
  /// Returns `null` on failure and shows a snack bar error.
  static Future<Map<String, dynamic>?> fetchPlayListItems(
    BuildContext context, {
    String? query,
    String? nextPageToken,
    String? playlistId,
  }) async {
    final response = await http.get(
      Uri.parse(
        YoutubeApiConst.playlistItemsUrl(
          query: query,
          nextPageToken: nextPageToken,
          playlistId: playlistId,
        ),
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videos = (data['items'] as List)
          .map((e) => YoutubePlaylistModel.fromJson(e))
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

  /// Fetches a paginated list of YouTube channels.
  ///
  /// When [query] is null or empty, the search term is automatically
  /// derived from the user's selected subjects (or all subjects as fallback).
  ///
  /// Returns a map with:
  /// - `"channels"` → `List<YoutubeChannelModel>`
  /// - `"nextPageToken"` → `String?` for the next page
  ///
  /// Returns `null` on failure.
  static Future<Map<String, dynamic>?> fetchYoutubeChannels(
    BuildContext context, {
    String? query,
    String? nextPageToken,
  }) async {
    if (controller<UserController>().user != null) {
      var subCtrl = controller<SubjectController>(tag: 'select-subject-home');
      if (query == null || query.trim().isEmpty) {
        // Load subjects if not already fetched
        if (subCtrl.subjcts.isEmpty) {
          await ApiFunctions.instance.getSubjects(
            context,
            controller: controller<SubjectController>(
              tag: 'select-subject-home',
            ),
          );
        }

        // Prefer user-selected subjects; fall back to all subjects
        var subjects = subCtrl.subjcts.where(
          (element) => element.isUserSubject ?? false,
        );

        if (subjects.isEmpty) {
          query = subCtrl.subjcts.map((e) => e.title).toList().join(", ");
        } else {
          query = subjects.map((e) => e.title).toList().join(", ");
        }
      }
    }

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
    } /* else {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Failed to load channels",
        isError: true,
      );
    } */
    return null;
  }

  /// Fetches detailed information (snippet, statistics, contentDetails)
  /// for a YouTube channel by [id].
  ///
  /// Returns `null` on failure and shows a snack bar error.
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

  /// Fetches detailed information (snippet, statistics, contentDetails)
  /// for a YouTube video by [id].
  ///
  /// Returns `null` on failure and shows a snack bar error.
  static Future<YoutubeVideoDetailModel?> fetchYoutubeVideoDetails(
    BuildContext context, {
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse(YoutubeApiConst.videoDetailsUrl(id: id)),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final video = (data['items'] as List)
          .map((e) => YoutubeVideoDetailModel.fromJson(e))
          .toList()
          .firstOrNull;
      return video;
    } else {
      await AppTostMessage.snackBarMessage(
        context,
        message: "Failed to load channel details",
        isError: true,
      );
    }
    return null;
  }

  /// ------------------------------------------------------------
  /// 🎯 Fetch Shorts (<=60 sec) + Portrait Videos from Playlist
  /// ------------------------------------------------------------
  ///
  /// ✔ Iterative (no recursion → better control)
  /// ✔ Pagination support
  /// ✔ Stops early when required count reached
  /// ✔ Batch fetch (50 videos at once)
  ///
  /// [playlistId] — the YouTube playlist to scan.
  /// [maxShorts] — maximum number of short portrait videos to collect.
  ///
  /// Returns: `List<String>` → collected video IDs
  static Future<Map<String, dynamic>> fetchShortPortraitVideosIterative(
    BuildContext context, {
    required String playlistId,
    int maxShorts = 10,
    String? pageToken,
  }) async {
    final List<YoutubeVideoModel> collectedShorts = [];
    String? nextPageToken = pageToken;

    while (collectedShorts.length < maxShorts) {
      try {
        // --------------------------------------------------
        // 1. Fetch playlist items (only videoId needed)
        // --------------------------------------------------
        final url =
            "$playlistItems"
            "?part=contentDetails"
            "&playlistId=$playlistId"
            "&maxResults=50"
            "${_queryParam('pageToken', nextPageToken)}"
            "&key=$key";

        final response = await http.get(Uri.parse(url));

        if (response.statusCode != 200) break;

        final data = jsonDecode(response.body);

        final items = data['items'] as List?;
        if (items == null || items.isEmpty) break;

        // --------------------------------------------------
        // 2. Extract video IDs from playlist items
        // --------------------------------------------------
        final videoIds = items
            .map((e) => e['contentDetails']?['videoId'])
            .whereType<String>()
            .toList();

        if (videoIds.isEmpty) break;

        // --------------------------------------------------
        // 3. Fetch video details (duration + thumbnails)
        // --------------------------------------------------
        final videoUrl =
            "$videosUrl"
            "?part=contentDetails,snippet"
            "&id=${videoIds.join(",")}"
            "&key=$key";

        final videoResponse = await http.get(Uri.parse(videoUrl));

        if (videoResponse.statusCode != 200) break;

        final videoData = jsonDecode(videoResponse.body);
        final videos = videoData['items'] as List? ?? [];

        // --------------------------------------------------
        // 4. Filter: Shorts (≤60s) + Portrait thumbnails
        // --------------------------------------------------
        for (var video in videos) {
          if (collectedShorts.length >= maxShorts) break;

          final id = video['id'] as String?;
          final duration = video['contentDetails']?['duration'] as String?;

          if (id == null || duration == null) continue;

          // Convert ISO 8601 duration string → total seconds
          final seconds = parseDuration(duration);

          // Collect all videos ≤60 seconds (Shorts).
          // Portrait detection via thumbnail dimensions is intentionally skipped —
          // YouTube returns landscape thumbnails for Shorts via the Data API.
          if (seconds <= 60) {
            // The /videos endpoint returns id as a plain String, but
            // YoutubeVideoModel expects id as {"videoId": "..."} (search format).
            // Normalize it before parsing.
            final normalized = Map<String, dynamic>.from(video as Map);
            normalized['id'] = {'kind': 'youtube#video', 'videoId': id};
            collectedShorts.add(YoutubeVideoModel.fromJson(normalized));
          }
        }

        // --------------------------------------------------
        // 5. Advance to next page or stop if no more pages
        // --------------------------------------------------
        nextPageToken = data['nextPageToken'];
        if (nextPageToken == null) break;
      } catch (e) {
        debugPrint("Shorts Fetch Error: $e");
        break;
      }
    }
    return {"videos": collectedShorts, "nextPageToken": nextPageToken};
  }

  /// Parses an ISO 8601 duration string (e.g. `PT1H2M30S`) into total seconds.
  ///
  /// Returns `0` if the string does not match the expected format.
  static int parseDuration(String duration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    if (match == null) return 0;

    final h = int.tryParse(match.group(1) ?? '0') ?? 0;
    final m = int.tryParse(match.group(2) ?? '0') ?? 0;
    final s = int.tryParse(match.group(3) ?? '0') ?? 0;

    return h * 3600 + m * 60 + s;
  }

  /// Returns the HQ thumbnail URL for a YouTube video by its [id].
  ///
  /// Example: `https://img.youtube.com/vi/<id>/hqdefault.jpg`
  static thubnailFromId(String id) =>
      "https://img.youtube.com/vi/$id/hqdefault.jpg";
}
