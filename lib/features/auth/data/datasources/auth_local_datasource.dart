import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
}
