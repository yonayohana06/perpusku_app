import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);
  static const String _themeKey = 'theme_mode';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  // --- Theme Storage ---
  // Mengembalikan String: 'system', 'light', atau 'dark'
  String getThemeMode() {
    return _prefs.getString(_themeKey) ?? 'system'; // Default ikuti system
  }

  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
  }

  // --- Auth Token Storage ---
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
  }
}
