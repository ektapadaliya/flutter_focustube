import 'package:focus_tube_flutter/model/content_model.dart';
import 'package:focus_tube_flutter/model/interest_model.dart';
import 'package:focus_tube_flutter/model/sub_subject_model.dart';
import 'package:focus_tube_flutter/model/subject_model.dart';
import 'package:focus_tube_flutter/model/subject_video_model.dart';
import 'package:focus_tube_flutter/model/user_intrest_model.dart';
import 'package:focus_tube_flutter/model/user_model.dart';
import 'package:focus_tube_flutter/model/video_model.dart';

/// A factory class for creating and managing app models from JSON data.
///
/// This factory uses a singleton pattern and provides a centralized way to
/// register and convert JSON data to strongly-typed Dart models.
class AppModelFactory {
  // Singleton instance of the AppModelFactory.
  static final AppModelFactory _singleton = AppModelFactory._internal();

  // Factory constructor to return the singleton instance.
  factory AppModelFactory() => _singleton;

  // Private constructor for singleton initialization.
  AppModelFactory._internal();

  // Static getter to access the singleton instance.
  static AppModelFactory get instance => _singleton;

  // A map to store model type and their respective `fromJson` functions.
  // Using a more specific type signature for better type safety.
  static final Map<Type, Function> _modelFromJson = {};

  /// Register a model with its `fromJson` conversion logic.
  ///
  /// Example:
  /// ```dart
  /// factory.register<User>(User.fromJson);
  /// ```
  void register<T>(T Function(Map<String, dynamic>) fromJson) {
    _modelFromJson[T] = fromJson;
  }

  /// Register multiple models at once for convenience.
  ///
  /// Example:
  /// ```dart
  /// factory.registerAll({
  ///   User: User.fromJson,
  ///   Product: Product.fromJson,
  /// });
  /// ```
  void registerAll(Map<Type, Function> models) {
    _modelFromJson.addAll(models);
  }

  /// Check if a model type is registered.
  bool isRegistered<T>() => _modelFromJson.containsKey(T);

  /// Generic method to convert JSON into a model of type T.
  ///
  /// Supports both single objects and lists of objects.
  /// Returns null if json is null.
  /// Returns the original json if the type is not registered.
  static fromJson<T>(dynamic json) {
    // Fast path for null values
    if (json == null) return null;

    // Check if the type is registered
    final converter = _modelFromJson[T];

    if (converter != null) {
      // Handle iterable (list) responses
      if (json is Iterable) {
        return _iterableJsonResponse<T>(json, converter);
      }
      // Handle single object responses
      else if (json is Map<String, dynamic>) {
        try {
          return converter(json) as T;
        } catch (e) {
          // Silent fail in production, log in debug mode
          assert(() {
            // ignore: avoid_print
            print('Error converting JSON to $T: $e');
            return true;
          }());
          return null;
        }
      }
    }

    // Return original json if type not registered or unsupported format
    return json as T?;
  }

  /// Helper method to handle lists of JSON objects and convert them to a list of models.
  /// Optimized to skip null values and handle conversion errors gracefully.
  static List<T> _iterableJsonResponse<T>(
    Iterable jsonList,
    Function converter,
  ) {
    final result = <T>[];

    for (final jsonElement in jsonList) {
      if (jsonElement == null) continue;

      try {
        if (jsonElement is Map<String, dynamic>) {
          final item = converter(jsonElement) as T;
          result.add(item);
        }
      } catch (e) {
        // Silent fail in production, log in debug mode
        assert(() {
          // ignore: avoid_print
          print('Error converting list item to $T: $e');
          return true;
        }());
      }
    }

    return result;
  }

  /// Convert a list of JSON objects to a list of models.
  /// This is a convenience method for explicit list conversion.
  static List<T> fromJsonList<T>(List<dynamic> jsonList) {
    final converter = _modelFromJson[T];
    if (converter == null) return [];

    return _iterableJsonResponse<T>(jsonList, converter);
  }

  /// Clear all registered models (useful for testing).
  void clearRegistry() {
    _modelFromJson.clear();
  }

  /// Get all registered model types.
  List<Type> get registeredTypes => _modelFromJson.keys.toList();

  /// Initialize and register all app models.
  /// Call this method during app initialization.
  ///
  /// Add new models here as needed.
  void init() {
    // Register models for automatic parsing
    // Uncomment and add your models:
    // register<UserModel>(UserModel.fromJson);
    // register<ProductModel>(ProductModel.fromJson);

    // Or use registerAll for bulk registration:
    register<UserModel>(UserModel.fromJson);
    register<VideoModel>(VideoModel.fromJson);
    register<ContentModel>(ContentModel.fromJson);
    register<SubjectModel>(SubjectModel.fromJson);
    register<SubSubjectModel>(SubSubjectModel.fromJson);
    register<SubjectVideoModel>(SubjectVideoModel.fromJson);
    register<InterestModel>(InterestModel.fromJson);
    register<UserInterestModel>(UserInterestModel.fromJson);
  }
}
