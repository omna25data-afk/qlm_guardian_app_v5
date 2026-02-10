import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Auth interceptor - handles Bearer token for Sanctum
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';

  AuthInterceptor({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid - could trigger logout
      _storage.delete(key: _tokenKey);
    }
    handler.next(err);
  }

  /// Save token after successful login
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Clear token on logout
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Get current token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
}
