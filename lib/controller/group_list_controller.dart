import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/channel_group_model.dart';
import 'package:get/get.dart';

class GroupListController extends GetxController {
  GroupListController(this.tag);
  String? tag;

  final List<GroupModel> _groupList = [];
  final List<GroupModel> _searchGroupList = [];
  List<GroupModel> get groupList => isSearch ? _searchGroupList : _groupList;

  String? searchQuery;

  void setSearchQuery(String? query) {
    searchQuery = query;
    update();
  }

  bool get isSearch => searchQuery?.trim().isNotEmpty ?? false;

  void addGroups(List<GroupModel> groups) {
    for (var element in groups) {
      if (isSearch) {
        var index = _searchGroupList.indexWhere((e) => e.id == element.id);
        if (index == -1) {
          _searchGroupList.add(element);
        } else {
          _searchGroupList[index] = element;
        }
      }
      var index = _groupList.indexWhere((e) => e.id == element.id);
      if (index == -1 && !isSearch) {
        _groupList.add(element);
      } else if (index != -1) {
        _groupList[index] = element;
      }
    }
    update();
  }

  void addGroup(GroupModel group) {
    if (isSearch) {
      var index = _searchGroupList.indexWhere((e) => e.id == group.id);
      if (index == -1) {
        _searchGroupList.add(group);
      } else {
        _searchGroupList[index] = group;
      }
    }
    var index = _groupList.indexWhere((e) => e.id == group.id);
    if (index == -1 && !isSearch) {
      _groupList.add(group);
    } else if (index != -1) {
      _groupList[index] = group;
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
  bool get hasData => isSearch ? _searchHasData : _hasData;

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
  int get page => isSearch ? _searchPage : _page;

  void incPage() {
    if (isSearch) {
      _searchPage++;
    } else {
      _page++;
    }
    update();
  }

  void removeGroup(String id) {
    groupList.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    _groupList.clear();
    _page = 1;
    _hasData = true;
    clearSearch();
  }

  void clearSearch() {
    _searchGroupList.clear();
    _searchPage = 1;
    _searchHasData = true;
    loaderController.setLoading(false);
    update();
  }
}
