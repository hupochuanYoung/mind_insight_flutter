import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/profile_model.dart';

/// Local data source for Profile — caches the user profile in SharedPreferences.
class ProfileLocalDatasource {
  static const String _profileKey = 'cached_profile';

  final SharedPreferences _prefs;

  ProfileLocalDatasource({required SharedPreferences prefs}) : _prefs = prefs;

  /// Save profile to local cache.
  Future<void> saveProfile(ProfileModel profile) async {
    final jsonString = json.encode(profile.toJson());
    await _prefs.setString(_profileKey, jsonString);
  }

  /// Read cached profile (returns null if not cached).
  ProfileModel? getProfile() {
    final jsonString = _prefs.getString(_profileKey);
    if (jsonString == null) return null;
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ProfileModel.fromJson(map);
  }

  /// Clear cached profile (e.g. on logout).
  Future<void> clear() async {
    await _prefs.remove(_profileKey);
  }
}
