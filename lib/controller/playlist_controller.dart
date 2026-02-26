import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/playlist_model.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {
  PlaylistController(this.tag);
  String? tag;
  List<PlaylistModel> _playList = [];
  List<PlaylistModel> _searchPlayList = [];
  List<PlaylistModel> get playList => (isSearch) ? _searchPlayList : _playList;

  String? searchQuery;

  void setSearchQuery(String? query) {
    searchQuery = query;
    update();
  }

  bool get isSearch => (searchQuery?.trim().isNotEmpty ?? false);

  void addPlayLists(List<PlaylistModel> playList) {
    for (var element in playList) {
      if (isSearch) {
        var index = _searchPlayList.indexWhere((e) => e.id == element.id);
        if (index == -1) {
          _searchPlayList.add(element);
        } else {
          _searchPlayList[index] = element;
        }
      }
      var index = _playList.indexWhere((e) => e.id == element.id);
      if (index == -1 && !isSearch) {
        _playList.add(element);
      } else {
        _playList[index] = element;
      }
    }
    update();
  }

  void addPlayList(PlaylistModel playList) {
    if (isSearch) {
      var index = _searchPlayList.indexWhere((e) => e.id == playList.id);
      if (index == -1) {
        _searchPlayList.add(playList);
      } else {
        _searchPlayList[index] = playList;
      }
    }
    var index = _playList.indexWhere((e) => e.id == playList.id);
    if (index == -1 && !isSearch) {
      _playList.add(playList);
    } else if (index != -1) {
      _playList[index] = playList;
    }

    update();
  }

  LoaderController get loaderController =>
      controller<LoaderController>(tag: tag);
  void setIsLoading(bool isLoading) {
    controller<LoaderController>(tag: tag).setLoading(isLoading);
  }

  bool _hasData = true;
  bool _searchHasData = true;
  bool get hasData => (isSearch) ? _searchHasData : _hasData;

  void setHasData(bool hasData) {
    if (isSearch) {
      _searchHasData = hasData;
    } else {
      _hasData = hasData;
    }
    update();
  }

  int _page = 1;
  int _searchPage = 1;
  int get page => (isSearch) ? _searchPage : _page;

  void incPage() {
    if (isSearch) {
      _searchPage++;
    } else {
      _page++;
    }
    update();
  }

  void removeVideo(String id) {
    playList.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    _playList.clear();
    _page = 1;
    _hasData = true;
    clearSearch();
  }

  void clearSearch() {
    _searchPlayList.clear();
    _searchPage = 1;
    _searchHasData = true;
    loaderController.setLoading(false);
    update();
  }
}
