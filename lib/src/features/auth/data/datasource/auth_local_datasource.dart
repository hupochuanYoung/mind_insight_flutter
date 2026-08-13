import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for auth — persists token to disk via SharedPreferences.
class AuthLocalDatasource {
  static const String _tokenKey = 'auth_access_token';
  static const String _userIdKey = 'auth_user_id';

  final SharedPreferences _prefs;

  AuthLocalDatasource({required SharedPreferences prefs}) : _prefs = prefs;

  /// Save the access token after a successful login/register.
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Save the user id alongside the token.
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  /// Read the cached token (returns null if not logged in).
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Read the cached user id.
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Clear all auth data (on logout).
  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
  }
}
