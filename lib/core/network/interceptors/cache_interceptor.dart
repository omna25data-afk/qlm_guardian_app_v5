import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

/// Cache interceptor - caches GET requests
/// Matches backend caching strategy (24h for contract-types, form-fields)
class CacheInterceptor extends Interceptor {
  final Box<dynamic> _cacheBox;

  /// Cache durations matching backend
  static const Duration defaultCacheDuration = Duration(hours: 24);

  /// Endpoints that should be cached for 24 hours
  static const List<String> _longCacheEndpoints = [
    '/contract-types',
    '/form-fields',
    '/record-book-types',
  ];

  CacheInterceptor(this._cacheBox);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method != 'GET') {
      handler.next(options);
      return;
    }

    final cacheKey = _getCacheKey(options);
    final cachedData = _cacheBox.get(cacheKey);

    if (cachedData != null) {
      final cacheTime = _cacheBox.get('${cacheKey}_time') as int?;
      if (cacheTime != null) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - cacheTime;
        final maxAge = _getCacheDuration(options.path).inMilliseconds;

        if (cacheAge < maxAge) {
          // Return cached response
          handler.resolve(
            Response(
              requestOptions: options,
              data: cachedData,
              statusCode: 200,
              statusMessage: 'OK (cached)',
            ),
          );
          return;
        }
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Only cache successful GET requests
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);
      await _cacheBox.put(cacheKey, response.data);
      await _cacheBox.put(
        '${cacheKey}_time',
        DateTime.now().millisecondsSinceEpoch,
      );
    }
    handler.next(response);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.path}_${options.queryParameters.toString()}';
  }

  Duration _getCacheDuration(String path) {
    for (final endpoint in _longCacheEndpoints) {
      if (path.contains(endpoint)) {
        return const Duration(hours: 24);
      }
    }
    return const Duration(minutes: 5);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  /// Clear cache for specific endpoint
  Future<void> clearCacheFor(String path) async {
    final keys = _cacheBox.keys.where((key) => key.toString().contains(path));
    for (final key in keys) {
      await _cacheBox.delete(key);
    }
  }
}
