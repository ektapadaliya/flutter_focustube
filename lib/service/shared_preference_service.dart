import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  // Singleton instance of the SharedPreferenceService.
  static final SharedPreferenceService _singleton =
      SharedPreferenceService._internal();

  // Factory constructor to return the singleton instance.
  factory SharedPreferenceService() => _singleton;

  // Private constructor for singleton initialization.
  SharedPreferenceService._internal();

  // Static getter to access the singleton instance.
  static SharedPreferenceService get instance => _singleton;

  // Set data to preference
  Future<bool> setDataToPreference(String data, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, data);
  }

  // Get data from preference
  Future<String?> getDataFromPrefrence(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Remove data from preference
  Future<bool> removeDataInPrefrence(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  // Remove all data from preference
  Future<bool> removeAllInPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
