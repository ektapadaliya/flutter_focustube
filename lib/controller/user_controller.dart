import 'dart:convert';

import 'package:get/get.dart';

import '../model/user_model.dart';
import '../service/shared_preference_service.dart';

class UserController extends GetxController {
  static const _xAPIPreferenceKey = "xapi";
  static const _uuidPreferenceKey = "uuid";
  static const _userPreferenceKey = "user";
  static const _tokenPreferenceKey = "token";

  static String? _xAPIKey;
  String? get xAPIKey => _xAPIKey;

  static String? _uuid;
  String? get uuid => _uuid;

  static String? _token;
  String? get token => _token;

  static UserModel? _user;
  UserModel? get user => _user;

  //Set XAPIKey
  void setXAPIKey(String xAPIKey) {
    _xAPIKey = xAPIKey;
    update();
    SharedPreferenceService.instance.setDataToPreference(
      xAPIKey,
      _xAPIPreferenceKey,
    );
  }

  //Get XAPIKey
  Future<void> getXAPIKey() async {
    var data = await SharedPreferenceService.instance.getDataFromPrefrence(
      _xAPIPreferenceKey,
    );
    if (data != null) {
      _xAPIKey = data;
      update();
    }
  }

  //Set UUID
  void setUUID(String uuid) {
    _uuid = uuid;
    update();
    SharedPreferenceService.instance.setDataToPreference(
      uuid,
      _uuidPreferenceKey,
    );
  }

  //Get UUID
  Future<void> getUUID() async {
    var data = await SharedPreferenceService.instance.getDataFromPrefrence(
      _uuidPreferenceKey,
    );
    if (data != null) {
      _uuid = data;
      update();
    }
  }

  //Set Token
  void setToken(String token) {
    _token = token;
    update();
    SharedPreferenceService.instance.setDataToPreference(
      token,
      _tokenPreferenceKey,
    );
  }

  //Get Token
  Future<void> getToken() async {
    var data = await SharedPreferenceService.instance.getDataFromPrefrence(
      _tokenPreferenceKey,
    );
    if (data != null) {
      _token = data;
      update();
    }
  }

  //Set User
  void setUser(UserModel user) {
    _user = user;
    update();
    SharedPreferenceService.instance.setDataToPreference(
      json.encode(user.toJson()),
      _userPreferenceKey,
    );
  }

  //Get User
  Future<void> getUser() async {
    var data = await SharedPreferenceService.instance.getDataFromPrefrence(
      _userPreferenceKey,
    );
    if (data != null) {
      _user = UserModel.fromJson(json.decode(data));
      update();
    }
  }

  //Clear User
  void clear() {
    _user = null;
    _token = null;
    update();
    SharedPreferenceService.instance.removeDataFromPrefrence(
      _userPreferenceKey,
    );
    SharedPreferenceService.instance.removeDataFromPrefrence(
      _tokenPreferenceKey,
    );
  }
}
