// ignore_for_file: unnecessary_type_check

import 'app_model_factory.dart';

/// A generic API response model that handles response parsing and error handling.
class ApiResponse<T> {
  /// The parsed data from the response
  final dynamic data;

  /// HTTP status code (e.g., 200, 400, 500)
  final int? httpCode;

  /// Application-specific response code
  final int? code;

  /// Response message from the server
  final String? responseMessage;

  /// Raw response map
  final Map<String, dynamic>? response;

  ApiResponse({
    this.httpCode,
    this.code,
    this.responseMessage,
    this.response,
    this.data,
  });

  /// Checks if the response is successful (HTTP 200 and valid response code)
  bool get isSuccess => code == 1;

  /// Checks if the response is an error
  bool get isError => !isSuccess;

  /// Gets the data as the specified type T, or null if not available
  T? get typedData => data is T ? data as T : null;

  /// Callback functions for handling special response codes

  /// Factory constructor to handle response parsing and create an ApiResponse instance.
  ///
  ///It will automatically use AppModelFactory if the type is registered.
  factory ApiResponse.handleResponse({required dynamic json}) {
    var code = json['code'];
    var message = json['message'];
    var response = json['response'];
    dynamic data;

    if (response != null) {
      data = response['data'];
    }

    // Handle special cases for response codes (e.g., logout or maintenance events).
    if ([5, 7].contains(code)) {
      if (code == 5) {
        _onLogout();
      } else {
        _onMaintenance();
      }
      // Return an ApiResponse instance with an error HTTP code.
      return ApiResponse<T>.error(message: message);
    }

    // Parse data using the provided fromJson function or AppModelFactory
    dynamic parsedData = data;
    if (data != null) {
      try {
        if (AppModelFactory.instance.isRegistered<T>()) {
          // Use AppModelFactory for registered types
          parsedData = AppModelFactory.fromJson<T>(data);
        }
      } catch (e) {
        // If parsing fails, keep the raw data
        parsedData = data;
      }
    }

    // Return an ApiResponse instance for valid responses.
    return ApiResponse<T>.success(
      message: message,
      data: parsedData,
      response: response,
      code: code,
    );
  }

  /// Factory constructor for error responses
  factory ApiResponse.error({required String message}) {
    return ApiResponse<T>(httpCode: 400, responseMessage: message);
  }

  /// Factory constructor for success responses
  factory ApiResponse.success({
    required T data,
    String? message,
    Map<String, dynamic>? response,
    int? code,
  }) {
    return ApiResponse<T>(
      httpCode: 200,
      code: code,
      response: response,
      responseMessage: message ?? 'Success',
      data: data,
    );
  }

  /// Method to handle a logout event
  static void _onLogout(/* {bool clearXapi = false} */) {}

  /// Method to handle a maintenance event
  static void _onMaintenance() {}

  /// Converts the response to a map
  Map<String, dynamic> toMap() {
    return {
      'httpCode': httpCode,
      'responseMessage': responseMessage,
      'response': response,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(httpCode: $httpCode, message: $responseMessage, data: $data)';
  }
}
