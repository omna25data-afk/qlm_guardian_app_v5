import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/cache_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// API Client wrapper around Dio
class ApiClient {
  late final Dio _dio;
  final AuthInterceptor authInterceptor;
  final CacheInterceptor? cacheInterceptor;

  ApiClient({required this.authInterceptor, this.cacheInterceptor}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptors in order
    _dio.interceptors.add(authInterceptor);

    if (cacheInterceptor != null) {
      _dio.interceptors.add(cacheInterceptor!);
    }

    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    if (AppConfig.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  /// Factory constructor with Hive cache
  static Future<ApiClient> create({Box<dynamic>? cacheBox}) async {
    final authInterceptor = AuthInterceptor();
    CacheInterceptor? cacheInterceptor;

    if (cacheBox != null) {
      cacheInterceptor = CacheInterceptor(cacheBox);
    }

    return ApiClient(
      authInterceptor: authInterceptor,
      cacheInterceptor: cacheInterceptor,
    );
  }

  Dio get dio => _dio;

  // Convenience methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
