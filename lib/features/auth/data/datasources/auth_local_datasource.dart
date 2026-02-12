import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Local data source for auth - stores token and user cache
class AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  AuthLocalDataSource({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// Save auth token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get auth token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Clear token
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Save user to cache
  Future<void> cacheUser(UserModel user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  /// Get cached user
  Future<UserModel?> getCachedUser() async {
    final data = await _storage.read(key: _userKey);
    if (data == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  /// Clear all auth data
  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ─── Remember Me ───

  static const String _rememberMeKey = 'remember_me';
  static const String _lastIdentifierKey = 'last_identifier';

  /// Save remember-me preference
  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  /// Get remember-me preference
  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Save last used login identifier
  Future<void> saveLastIdentifier(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastIdentifierKey, identifier);
  }

  /// Get last used login identifier
  Future<String?> getLastIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastIdentifierKey);
  }

  /// Clear remember-me data
  Future<void> clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_lastIdentifierKey);
  }
}
