// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_manager.dart';
import 'package:focus_tube_flutter/api/api_utils.dart';
import 'package:focus_tube_flutter/controller/video_controller.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/model/interest_model.dart';
import 'package:focus_tube_flutter/model/user_intrest_model.dart';
import 'package:focus_tube_flutter/model/video_model.dart';
import 'package:focus_tube_flutter/service/uuid_service.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';
import 'package:go_router/go_router.dart';

import '../controller/app_controller.dart';
import '../model/user_model.dart';
import '../model/content_model.dart';
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
      try {
        var response = await ApiManager.instance.post(
          ApiUtils.generateToken,
          body: {"uuid": uuid, "device_model": deviceModel},
        );
        if (response.isSuccess) {
          var authCtrl = controller<UserController>();
          authCtrl.setUUID(uuid);
          authCtrl.setXAPIKey(response.data);
        }
      } catch (e) {
        debugPrint("Error in generateToken: $e");
      }
    }
  }

  //Login
  Future<bool> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.login,
        body: {"email": email, "password": password},
      );
      if (response.isSuccess) {
        var authCtrl = controller<UserController>();
        authCtrl.setToken(response.response?['token']);
        await me(context: context);
        await getUserInterests(context);
      } else {
        await AppTostMessage.snackBarMessage(
          context,
          message: response.responseMessage,
          isError: response.isError,
        );
      }
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in login: $e");
      return false;
    }
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
    try {
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
    } catch (e) {
      debugPrint("Error in signUp: $e");
      return false;
    }
  }

  //Me
  Future<void> me({BuildContext? context}) async {
    try {
      var response = await ApiManager.instance.post<UserModel>(ApiUtils.me);
      if (response.isSuccess) {
        var authCtrl = controller<UserController>();
        authCtrl.setUser(response.data);
      } else {
        if (context != null) {
          await AppTostMessage.snackBarMessage(
            context,
            message: response.responseMessage,
            isError: response.isError,
          );
        }
      }
    } catch (e) {
      debugPrint("Error in me: $e");
    }
  }

  //Signin Verify Code
  Future<bool> signInVerifyCode(
    BuildContext context, {
    required String code,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.signupVerifyCode,
        body: {"code": code},
      );
      await me(context: context);
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in signInVerifyCode: $e");
      return false;
    }
  }

  //Resend Verify Code
  Future<bool> resendVerifyCode(BuildContext context) async {
    try {
      var response = await ApiManager.instance.post(ApiUtils.resendEmail);
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in resendVerifyCode: $e");
      return false;
    }
  }

  //Forgot Password
  Future<bool> forgotPassword(
    BuildContext context, {
    required String email,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.forgotPassword,
        body: {"email": email},
      );
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in forgotPassword: $e");
      return false;
    }
  }

  //Verify Code
  Future<bool> verifyCode(
    BuildContext context, {
    required String code,
    required String email,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.verifyCode,
        body: {"code": code, "email": email},
      );
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in verifyCode: $e");
      return false;
    }
  }

  //Reset Password
  Future<bool> resetPassword(
    BuildContext context, {
    required String code,
    required String password,
    required String confirmPassword,
    required String email,
  }) async {
    try {
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
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in resetPassword: $e");
      return false;
    }
  }

  //Pages
  Future<ContentModel?> pages(
    BuildContext context, {
    required String slug,
  }) async {
    try {
      var response = await ApiManager.instance.post<ContentModel>(
        ApiUtils.pages,
        body: {"slug": slug},
      );
      if (response.isSuccess) {
        return response.data;
      } else {
        await AppTostMessage.snackBarMessage(
          context,
          message: response.responseMessage,
          isError: response.isError,
        );
      }
    } catch (e) {
      debugPrint("Error in pages: $e");
    }
    return null;
  }

  //Update Notification Preference
  Future<bool> updateNotificationPreference(
    BuildContext context, {
    required bool isActive,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.updateNotificationPreference,
        body: {"notification": isActive ? "y" : "n"},
      );
      if (response.isSuccess) {
        await me(context: context);
      }
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in updateNotificationPreference: $e");
      return false;
    }
  }

  //Update Daily Limit
  Future<bool> updateDailyLimit(
    BuildContext context, {
    required int limit,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.updateDailyLimit,
        body: {"daily_video_limit": limit.toString()},
      );
      if (response.isSuccess) {
        await me(context: context);
      }
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in updateDailyLimit: $e");
      return false;
    }
  }

  //Interests
  Future<void> interests(BuildContext context) async {
    try {
      var response = await ApiManager.instance.post<InterestModel>(
        ApiUtils.interests,
      );
      if (response.isSuccess) {
        controller<InterestController>().replaceInterests(response.data);
      } else if (response.code != 3) {
        await AppTostMessage.snackBarMessage(
          context,
          message: response.responseMessage,
          isError: response.isError,
        );
      }
    } catch (e) {
      debugPrint("Error in interests: $e");
    }
  }

  //Update Interests
  Future<bool> updateInterests(
    BuildContext context, {
    required List<String> interestsIds,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.updateInterest,
        body: Map<String, dynamic>.fromEntries(
          interestsIds.asMap().entries.map(
            (e) => MapEntry("interest_ids[${e.key}]", e.value),
          ),
        ),
      );
      if (response.isSuccess) {
        await getUserInterests(context);
      }
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in updateInterests: $e");
      return false;
    }
  }

  //Get User Interests
  Future<void> getUserInterests(BuildContext? context) async {
    try {
      var response = await ApiManager.instance.post<UserInterestModel>(
        ApiUtils.getUserInterests,
      );
      if (response.isSuccess) {
        controller<InterestController>().replaceUserInterests(response.data);
      } else if (response.code != 3 && context != null) {
        await AppTostMessage.snackBarMessage(
          context,
          message: response.responseMessage,
          isError: response.isError,
        );
      }
    } catch (e) {
      debugPrint("Error in getUserInterests: $e");
    }
  }

  //Edit Profile
  Future<bool> editProfile(
    BuildContext context, {
    required String firstName,
    required String lastName,
    File? image,
  }) async {
    try {
      ApiResponse response;
      if (image != null) {
        response = await ApiManager.instance.uploadFile(
          ApiUtils.editProfile,
          image,
          body: {"first_name": firstName, "last_name": lastName},
          fieldName: "image",
        );
      } else {
        response = await ApiManager.instance.post(
          ApiUtils.editProfile,
          body: {"first_name": firstName, "last_name": lastName},
        );
      }
      if (response.isSuccess) {
        await me(context: context);
      }
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in editProfile: $e");
      return false;
    }
  }

  //Change Password
  Future<bool> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.changePassword,
        body: {
          "old_password": oldPassword,
          "password": newPassword,
          "confirm_password": confirmPassword,
        },
      );
      await AppTostMessage.snackBarMessage(
        context,
        message: response.responseMessage,
        isError: response.isError,
      );
      return response.isSuccess;
    } catch (e) {
      debugPrint("Error in changePassword: $e");
      return false;
    }
  }

  //Recommened Videos
  Future<void> getRecommenedVideos(
    BuildContext context, {
    required VideoController controller,
    int page = 1,
    int? perPage,
  }) async {
    try {
      controller.setIsLoading(true);
      var response = await ApiManager.instance.post<VideoModel>(
        ApiUtils.getRecommenedVideos,
        body: {
          if (perPage != null) "per_page": perPage.toString(),
          "page": page.toString(),
        },
      );
      controller.setIsLoading(false);
      if (response.isSuccess) {
        var data = response.data;
        if (data is Iterable) {
          if (data.isEmpty) {
            controller.setHasData(false);
          } else {
            controller.addVideos(response.data);
          }
        } else {
          controller.setHasData(false);
        }
      } else if (response.isError) {
        controller.setHasData(false);
      }
    } catch (e) {
      debugPrint("Error in getRecommenedVideos: $e");
    }
  }

  //Popular Videos
  Future<void> getPopularVideos(
    BuildContext context, {
    required VideoController controller,
    int page = 1,
    int? perPage,
  }) async {
    try {
      controller.setIsLoading(true);
      var response = await ApiManager.instance.post<VideoModel>(
        ApiUtils.getPopularVideos,
        body: {
          if (perPage != null) "per_page": perPage.toString(),
          "page": page.toString(),
        },
      );
      controller.setIsLoading(false);
      if (response.isSuccess) {
        var data = response.data;
        if (data is Iterable) {
          if (data.isEmpty) {
            controller.setHasData(false);
          } else {
            controller.addVideos(response.data);
          }
        } else {
          controller.setHasData(false);
        }
      } else if (response.isError) {
        controller.setHasData(false);
      }
    } catch (e) {
      debugPrint("Error in getPopularVideos: $e");
    }
  }

  //Bookmark Videos
  Future<void> getBookmarkVideos(
    BuildContext context, {
    required VideoController controller,
    int page = 1,
    int? perPage,
  }) async {
    try {
      controller.setIsLoading(true);
      var response = await ApiManager.instance.post<VideoModel>(
        ApiUtils.getBookmarkVideos,
        body: {
          if (perPage != null) "per_page": perPage.toString(),
          "page": page.toString(),
        },
      );
      controller.setIsLoading(false);
      if (response.isSuccess) {
        var data = response.data;
        if (data is Iterable) {
          if (data.isEmpty) {
            controller.setHasData(false);
          } else {
            controller.addVideos(response.data);
          }
        } else {
          controller.setHasData(false);
        }
      } else if (response.isError) {
        controller.setHasData(false);
      }
    } catch (e) {
      debugPrint("Error in getBookmarkVideos: $e");
    }
  }

  //Bookmark Video
  Future<dynamic> bookmarkVideo(
    BuildContext context, {
    required String videoId,
  }) async {
    try {
      var response = await ApiManager.instance.post(
        ApiUtils.bookmarkVideo,
        body: {"video_id": videoId},
      );
      if (response.isSuccess) {
        return response.data;
      }
    } catch (e) {
      debugPrint("Error in bookmarkVideo: $e");
      return false;
    }
  }

  //Logout
  void logout({BuildContext? context}) async {
    ApiManager.instance.post(ApiUtils.logout);
    logoutfn(context: context);
  }

  //delete account
  void deleteAccount({BuildContext? context}) async {
    ApiManager.instance.post(ApiUtils.deleteAccount);
    logoutfn(context: context);
  }

  void logoutfn({BuildContext? context}) {
    controller<UserController>().clear();
    controller<InterestController>().clear();
    context?.go(signIn.path);
  }
}
