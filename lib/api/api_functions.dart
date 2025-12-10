// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_manager.dart';
import 'package:focus_tube_flutter/api/api_utils.dart';
import 'package:focus_tube_flutter/service/uuid_service.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';

import '../controller/app_controller.dart';
import '../controller/user_controller.dart';
import '../model/user_model.dart';
import 'api_response_model.dart';

class ApiFunctions {
  // Singleton instance of the ApiFunctions.
  static final ApiFunctions _singleton = ApiFunctions._internal();

  // Factory constructor to return the singleton instance.
  factory ApiFunctions() => _singleton;

  // Private constructor for singleton initialization.
  ApiFunctions._internal();

  // Static getter to access the singleton instance.
  static ApiFunctions get instance => _singleton;

  //Generate Token
  Future<void> generateToken() async {
    var uuid = await UuidService.getDeviceId();
    var deviceModel = await UuidService.deviceModel();
    if (uuid != null && deviceModel != null) {
      var response = await ApiManager.instance.post(
        ApiUtils.generateToken,
        body: {"uuid": uuid, "device_model": deviceModel},
      );
      if (response.isSuccess) {
        var authCtrl = controller<UserController>();
        authCtrl.setUUID(uuid);
        authCtrl.setXAPIKey(response.data);
      }
    }
  }

  //Login
  Future<bool> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    var response = await ApiManager.instance.post(
      ApiUtils.login,
      body: {"email": email, "password": password},
    );
    if (response.isSuccess) {
      var authCtrl = controller<UserController>();
      authCtrl.setToken(response.response?['token']);
      await me(context: context);
    } else {
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
      );
    }
    return response.isSuccess;
  }

  //SignUp
  Future<bool> signUp(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    File? image,
  }) async {
    var body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
    };
    ApiResponse response;
    if (image != null) {
      response = await ApiManager.instance.uploadFile(
        ApiUtils.signup,
        image,
        fieldName: "image",
        body: body,
      );
    } else {
      response = await ApiManager.instance.post(ApiUtils.signup, body: body);
    }
    if (response.isSuccess) {
      var authCtrl = controller<UserController>();
      authCtrl.setToken(response.response?['token']);
      await me(context: context);
    } else {
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
    }
    return response.isSuccess;
  }

  //Me
  Future<void> me({BuildContext? context}) async {
    var response = await ApiManager.instance.post<UserModel>(ApiUtils.me);
    if (response.isSuccess) {
      var authCtrl = controller<UserController>();
      authCtrl.setUser(response.data);
    } else {
      if (context != null) {
        await AppTostMessage.snackBarMessage(
          context,
          message: response.responseMessage,
        );
      }
    }
  }

  //Signin Verify Code
  Future<bool> signInVerifyCode(
    BuildContext context, {
    required String code,
  }) async {
    var response = await ApiManager.instance.post(
      ApiUtils.signupVerifyCode,
      body: {"code": code},
    );
    await AppTostMessage.snackBarMessage(
      context,
      message: response.responseMessage,
    );
    return response.isSuccess;
  }

  //Resend Verify Code
  Future<bool> resendVerifyCode(
    BuildContext context, {
    required String email,
  }) async {
    var response = await ApiManager.instance.post(
      ApiUtils.resendEmail,
      body: {"email": email},
    );
    await AppTostMessage.snackBarMessage(
      context,
      message: response.responseMessage,
    );
    return response.isSuccess;
  }

  //Forgot Password
  Future<bool> forgotPassword(
    BuildContext context, {
    required String email,
  }) async {
    var response = await ApiManager.instance.post(
      ApiUtils.forgotPassword,
      body: {"email": email},
    );
    await AppTostMessage.snackBarMessage(
      context,
      message: response.responseMessage,
    );
    return response.isSuccess;
  }

  //Verify Code
  Future<bool> verifyCode(
    BuildContext context, {
    required String code,
    required String email,
  }) async {
    var response = await ApiManager.instance.post(
      ApiUtils.verifyCode,
      body: {"code": code, "email": email},
    );
    await AppTostMessage.snackBarMessage(
      context,
      message: response.responseMessage,
    );
    return response.isSuccess;
  }

  //Reset Password
  Future<bool> resetPassword(
    BuildContext context, {
    required String code,
    required String password,
    required String confirmPassword,
    required String email,
  }) async {
    var response = await ApiManager.instance.post(
      ApiUtils.resetPassword,
      body: {
        "code": code,
        "password": password,
        "confirm_password": confirmPassword,
        "email": email,
      },
    );
    await AppTostMessage.snackBarMessage(
      context,
      message: response.responseMessage,
    );
    return response.isSuccess;
  }
}
