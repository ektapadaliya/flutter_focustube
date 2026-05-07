import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/general_dialog.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../model/user_model.dart';
import '../service/shared_preference_service.dart';

class UserController extends GetxController {
  static const _xAPIPreferenceKey = "xapi";
  static const _uuidPreferenceKey = "uuid";
  static const _userPreferenceKey = "user";
  static const _tokenPreferenceKey = "token";

  static const _remberMeKey = "rember_me";
  static const _loginCredKey = "login_cred";

  static String? _xAPIKey;
  String? get xAPIKey => _xAPIKey;

  static String? _uuid;
  String? get uuid => _uuid;

  static String? _token;
  String? get token => _token;

  static UserModel? _user;
  UserModel? get user => _user;

  //Set RemberMe
  void setRemberMe() {
    SharedPreferenceService.instance.setDataToPreference("true", _remberMeKey);
  }

  //Get RemberMe
  Future<bool> getRemberMe() async {
    var data = await SharedPreferenceService.instance.getDataFromPrefrence(
      _remberMeKey,
    );
    return data == "true";
  }

  //Set RemberMe
  void setLoginCred(String email, String password) {
    SharedPreferenceService.instance.setDataToPreference(
      json.encode({'email': email, 'password': password}),
      _loginCredKey,
    );
  }

  //Get RemberMe
  Future<Map<String, String>?> getLoginCred() async {
    var data = await SharedPreferenceService.instance.getDataFromPrefrence(
      _loginCredKey,
    );
    if (data != null) {
      return Map<String, String>.from(json.decode(data));
    }
    return null;
  }

  //Clear RemberMe
  void clearRemberMe() {
    SharedPreferenceService.instance.removeDataFromPrefrence(_remberMeKey);
    SharedPreferenceService.instance.removeDataFromPrefrence(_loginCredKey);
  }

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

  void showLoginDialog(BuildContext context, {required VoidCallback onSucess}) {
    if (user != null) {
      onSucess.call();
    } else {
      generalDialog(
        context,
        title: "Login Required",
        message: "Please log in to continue.",
        submitText: "Log In",
        onSubmit: (dialogContext) {
          dialogContext.pop(true);
        },
      ).then((value) {
        if (value == true) {
          signIn.off(context);
        }
      });
    }
  }
}
