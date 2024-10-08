import 'package:shared_preferences/shared_preferences.dart';

class LocationController {
  static const String _storageKey = 'location';
  static final _prefs = SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: {_storageKey},
    ),
  );

  static Future<String?> loadLocation() async {
    final prefs = await _prefs;
    return prefs.getString(_storageKey);
  }

  static Future<void> saveLocation({required String newLocation}) async {
    final prefs = await _prefs;
    prefs.setString(_storageKey, newLocation);
  }
}
