import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/model/youtube_video_model.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../api/youtube_api.dart';

/// Controls the Shorts feed — a vertically paged list of short videos.
///
/// - Owns the vertical [PageController].
/// - Caches [YoutubePlayerController] per videoId so re-visiting a page
///   never reloads the video.
/// - Only the current video and ±2 neighbours have autoPlay = true.
/// - Supports pagination: loads more when nearing the end.
class ShortsController extends GetxController {
  /// Vertical [PageController] used by the Shorts [PageView].
  final PageController pageController = PageController();

  /// Current visible page index.
  int currentIndex = 0;

  /// All loaded short video items.
  List<YoutubeVideoModel> videos = [];

  /// Cached [YoutubePlayerController] per videoId — prevents reload on revisit.
  final Map<String, YoutubePlayerController> _playerCache = {};

  /// Playlist ID to fetch shorts from.
  String playlistId = '';

  /// Next page token for pagination.
  String nextPageToken = '';

  /// Whether a fetch is in progress.
  bool isLoading = false;

  /// Number of neighbouring pages on each side to keep active (autoPlay).
  static const int _windowSize = 2;

  // --------------------------------------------------
  // Player Cache
  // --------------------------------------------------

  /// Returns a cached [YoutubePlayerController] for [videoId], creating one
  /// if it doesn't exist yet. Auto-plays immediately if within the active window.
  YoutubePlayerController playerFor(String videoId) {
    if (_playerCache.containsKey(videoId)) return _playerCache[videoId]!;

    final index = videos.indexWhere((v) => v.id?.videoId == videoId);
    final active = index != -1 && shouldAutoPlay(index);

    final playerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: active,
        mute: false,
        loop: true,
        hideControls: false,
      ),
    );

    // Play once ready if active — listener removes itself after first play.
    if (active) {
      late VoidCallback listener;
      listener = () {
        if (playerController.value.isReady) {
          playerController.play();
          playerController.removeListener(listener);
        }
      };
      playerController.addListener(listener);
    }

    _playerCache[videoId] = playerController;
    return playerController;
  }

  // --------------------------------------------------
  // Playlist Init
  // --------------------------------------------------

  /// Sets a new [id] as the playlist source, resets state, and loads the first page.
  Future<void> setPlaylistId(BuildContext context, String id) async {
    if (playlistId == id && videos.isNotEmpty) return;
    playlistId = id;
    clear();
    await loadMore(context);
  }

  // --------------------------------------------------
  // Data
  // --------------------------------------------------

  /// Adds [newVideos] to the list, skipping duplicates by videoId.
  void addVideos(List<YoutubeVideoModel> newVideos) {
    for (var video in newVideos) {
      final id = video.id?.videoId;
      if (id != null && !videos.any((v) => v.id?.videoId == id)) {
        videos.add(video);
      }
    }
    update();
  }

  /// Updates the pagination token.
  void setNextPageToken(String? token) {
    nextPageToken = token ?? '';
    update();
  }

  /// Updates the loading state.
  void setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  // --------------------------------------------------
  // Page Logic
  // --------------------------------------------------

  /// Called by [PageView.onPageChanged]. Updates [currentIndex],
  /// plays/pauses players in the active window, and triggers pagination.
  void onPageChanged(BuildContext context, int index) {
    currentIndex = index;

    // Play/pause all already-cached controllers based on the new window
    for (var i = 0; i < videos.length; i++) {
      final id = videos[i].id?.videoId;
      if (id == null) continue;
      final cached = _playerCache[id];
      if (cached == null) continue;
      if (shouldAutoPlay(i)) {
        if (cached.value.isReady) {
          cached.play();
        } else {
          // Not ready yet — listener in playerFor will play once ready
        }
      } else {
        cached.pause();
      }
    }

    if (!isLoading && index >= videos.length - 3) {
      loadMore(context);
    }
    update();
  }

  /// Returns `true` if the player at [index] should auto-play.
  bool shouldAutoPlay(int index) {
    return (index - currentIndex).abs() <= _windowSize;
  }

  // --------------------------------------------------
  // Pagination
  // --------------------------------------------------

  /// Fetches the next page of shorts from [playlistId].
  Future<void> loadMore(BuildContext context) async {
    if (isLoading || playlistId.isEmpty) return;
    try {
      setIsLoading(true);
      final result = await YoutubeApiConst.fetchShortPortraitVideosIterative(
        context,
        playlistId: playlistId,
        pageToken: nextPageToken.isEmpty ? null : nextPageToken,
      );
      final newVideos = (result['videos'] as List<YoutubeVideoModel>?) ?? [];
      addVideos(newVideos);
      setNextPageToken(result['nextPageToken'] as String?);
    } catch (e) {
      debugPrint('ShortsController.loadMore error: $e');
    } finally {
      setIsLoading(false);
    }
  }

  // --------------------------------------------------
  // Lifecycle
  // --------------------------------------------------

  /// Resets all state, disposes cached players, and jumps back to page 0.
  void clear() {
    for (final c in _playerCache.values) {
      c.dispose();
    }
    _playerCache.clear();
    videos.clear();
    nextPageToken = '';
    isLoading = false;
    currentIndex = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    update();
  }

  @override
  void onClose() {
    for (final c in _playerCache.values) {
      c.dispose();
    }
    _playerCache.clear();
    pageController.dispose();
    super.onClose();
  }
}
