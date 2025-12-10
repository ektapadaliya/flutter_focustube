import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_utils.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/user_controller.dart';

import 'api_response_model.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// A singleton class that manages API requests.
///
/// This class provides methods for performing HTTP requests (GET, POST, PUT, PATCH, DELETE)
/// and handling responses and exceptions in a unified way.
class ApiManager {
  // Singleton instance of the ApiManager.
  static final ApiManager _singleton = ApiManager._internal();

  // Factory constructor to return the singleton instance.
  factory ApiManager() => _singleton;

  // Private constructor for singleton initialization.
  ApiManager._internal();

  // Static getter to access the singleton instance.
  static ApiManager get instance => _singleton;

  // Persistent client for connection reuse
  final http.Client _client = http.Client();

  /// Helper method to execute a specific API call.
  ///
  /// It executes the provided [method], parses the response, and returns an [ApiResponse].
  /// If an exception occurs, it returns an error [ApiResponse] with a user-friendly message.
  Future<ApiResponse<T>> _callApi<T>(
    Future<http.Response> Function() method,
  ) async {
    http.Response? response;
    try {
      response = await method();
      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      return ApiResponse.handleResponse(json: jsonDecode(response.body));
    } catch (e) {
      return ApiResponse<T>.error(message: handleException(e));
    }
  }

  /// Handles various types of exceptions and returns a user-friendly error message.
  String handleException(Object exception) {
    if (exception is TimeoutException) {
      return 'Connection timed out. Please try again later.';
    } else if (exception is SocketException) {
      return 'No internet connection. Please check your network settings.';
    } else if (exception is FormatException) {
      return 'Bad response format. Please contact support.';
    } else if (exception is PlatformException) {
      return 'Platform error: ${exception.message}';
    } else {
      return 'An unexpected error occurred: $exception';
    }
  }

  /// Returns the default headers for API requests.
  ///
  /// Includes 'User-Agent', 'authorize' token, and 'Content-Language'.
  Future<Map<String, String>> get headers async {
    var authCtrl = controller<UserController>();

    return <String, String>{
      'User-Agent': Platform.operatingSystem,
      'authorize': ApiUtils.authorizationToken,
      if (authCtrl.xAPIKey != null) "x-api-key": authCtrl.xAPIKey!,
      if (authCtrl.uuid != null) "x-device-uuid": authCtrl.uuid!,
      if (authCtrl.token != null) "token": authCtrl.token!,
    };
  }

  /// Performs a HTTP POST request to the specified [url].
  ///
  /// [body] contains the data to be sent.
  /// Optional [headers] can be provided.
  Future<ApiResponse<T>> post<T>(String url, {Object? body}) {
    debugPrint("URL: $url");
    debugPrint("Body: $body");
    return _callApi<T>(
      () async =>
          _client.post(Uri.parse(url), headers: await headers, body: body),
    );
  }

  /// Uploads a single [file] to the specified [url] using multipart/form-data.
  ///
  /// [fieldName] specifies the form field name for the file (default is 'file').
  /// [method] specifies the HTTP method (default is 'POST').
  Future<ApiResponse<T>> uploadFile<T>(
    String url,
    File file, {
    Map<String, String>? body,

    String fieldName = 'file',
    String method = 'POST',
  }) {
    debugPrint("URL: $url");
    return _callApi<T>(() async {
      final request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(await headers);
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );
      if (body != null) {
        request.fields.addAll(body);
      }
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    });
  }

  /// Uploads a list of [files] to the specified [url] using multipart/form-data.
  ///
  /// [fieldName] specifies the form field name for the files (default is 'files').
  /// [method] specifies the HTTP method (default is 'POST').
  Future<ApiResponse<T>> uploadMultipleFiles<T>(
    String url,
    List<File> files, {
    Map<String, String>? body,
    String fieldName = 'files',
    String method = 'POST',
  }) {
    debugPrint("URL: $url");
    return _callApi<T>(() async {
      final request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(await headers);

      for (var file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(fieldName, file.path),
        );
      }
      if (body != null) {
        request.fields.addAll(body);
      }
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    });
  }
}
