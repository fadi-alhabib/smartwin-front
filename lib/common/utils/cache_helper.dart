import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future setString({required String key, required String value}) async {
    await sharedPreferences?.setString(key, value);
  }

  static Future setInt({required String key, required int value}) async {
    await sharedPreferences?.setInt(key, value);
  }

  static Future setBool({required String key, required bool value}) async {
    await sharedPreferences?.setBool(key, value);
  }

  static dynamic getCache({required String key}) {
    return sharedPreferences?.get(key);
  }

  static Future<bool?> clearCache() async {
    return await sharedPreferences?.clear();
  }
}
