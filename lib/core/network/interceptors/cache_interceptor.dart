import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

/// SWR (Stale-While-Revalidate) Cache Interceptor
///
/// Strategy:
/// 1. On GET: If cached data exists → return it immediately (stale)
///    and let the request continue to revalidate in background
/// 2. On success response: Update the cache
/// 3. On error (500/DNS/timeout): Serve cached data if available
/// 4. On POST/PUT/DELETE: Invalidate related cache endpoints
class SwrCacheInterceptor extends Interceptor {
  final Box<dynamic> _cacheBox;

  /// Master/Reference data — rarely changes, long cache
  static const Map<String, Duration> _masterEndpoints = {
    '/admin/guardians': Duration(hours: 6),
    '/admin/licenses': Duration(hours: 6),
    '/admin/cards': Duration(hours: 6),
    '/admin/areas': Duration(hours: 24),
    '/admin/assignments': Duration(hours: 6),
    '/admin/record-books': Duration(hours: 6),
    '/contract-types': Duration(hours: 24),
    '/record-book-types': Duration(hours: 24),
    '/admin/districts': Duration(hours: 24),
    '/admin/villages': Duration(hours: 24),
    '/admin/localities': Duration(hours: 24),
  };

  /// Operational data — changes frequently, short cache
  static const Map<String, Duration> _operationalEndpoints = {
    '/admin/registry-entries': Duration(minutes: 5),
    '/admin/dashboard': Duration(minutes: 5),
    '/notifications': Duration(minutes: 2),
    '/form-fields': Duration(minutes: 5), // تُدار من Filament وتتغير باستمرار
  };

  /// Mutation endpoints → which cache groups to invalidate
  static const Map<String, List<String>> _invalidationMap = {
    '/admin/guardians': ['/admin/guardians', '/admin/dashboard'],
    '/admin/licenses': ['/admin/licenses', '/admin/guardians'],
    '/admin/cards': ['/admin/cards', '/admin/guardians'],
    '/admin/areas': ['/admin/areas'],
    '/admin/assignments': ['/admin/assignments'],
    '/admin/record-books': ['/admin/record-books', '/admin/registry-entries'],
    '/admin/registry-entries': ['/admin/registry-entries', '/admin/dashboard'],
  };

  SwrCacheInterceptor(this._cacheBox);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method != 'GET') {
      // For mutations (POST/PUT/DELETE), invalidate related caches
      if (['POST', 'PUT', 'DELETE', 'PATCH'].contains(options.method)) {
        await _invalidateRelatedCaches(options.path);
      }
      handler.next(options);
      return;
    }

    final cacheKey = _getCacheKey(options);
    final cachedData = _cacheBox.get(cacheKey);
    final cacheTime = _cacheBox.get('${cacheKey}_time') as int?;

    if (cachedData != null && cacheTime != null) {
      final cacheAge = DateTime.now().millisecondsSinceEpoch - cacheTime;
      final maxAge = _getCacheDuration(options.path);

      if (cacheAge < maxAge.inMilliseconds) {
        // Fresh cache — return directly, skip the network request
        debugPrint('📦 SWR Cache HIT (fresh): ${options.path}');
        handler.resolve(
          Response(
            requestOptions: options,
            data: cachedData,
            statusCode: 200,
            statusMessage: 'OK (cached)',
            headers: Headers.fromMap({
              'X-From-Cache': ['true'],
              'X-Cache-Age': ['${cacheAge ~/ 1000}s'],
            }),
          ),
        );
        return;
      } else {
        // Stale cache — return cached data but mark for revalidation
        debugPrint('🔄 SWR Cache STALE: ${options.path} — revalidating...');
        // Mark that we have stale data available for error fallback
        options.extra['_swr_stale_data'] = cachedData;
        options.extra['_swr_cache_key'] = cacheKey;
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Cache successful GET responses
    if (response.requestOptions.method == 'GET' &&
        response.statusCode == 200 &&
        _shouldCache(response.requestOptions.path)) {
      final cacheKey = _getCacheKey(response.requestOptions);
      await _cacheBox.put(cacheKey, response.data);
      await _cacheBox.put(
        '${cacheKey}_time',
        DateTime.now().millisecondsSinceEpoch,
      );
      debugPrint('💾 SWR Cache STORED: ${response.requestOptions.path}');
    }

    // For mutations, invalidate related caches after success
    if ([
      'POST',
      'PUT',
      'DELETE',
      'PATCH',
    ].contains(response.requestOptions.method)) {
      await _invalidateRelatedCaches(response.requestOptions.path);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // On error, try to serve stale cached data instead of showing error
    if (err.requestOptions.method == 'GET') {
      // First check if we have stale data from the request phase
      final staleData = err.requestOptions.extra['_swr_stale_data'];
      if (staleData != null) {
        debugPrint('⚠️ SWR Cache FALLBACK (stale): ${err.requestOptions.path}');
        handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: staleData,
            statusCode: 200,
            statusMessage: 'OK (stale cache - offline fallback)',
            headers: Headers.fromMap({
              'X-From-Cache': ['true'],
              'X-Cache-Fallback': ['true'],
            }),
          ),
        );
        return;
      }

      // Try to find any cached version for this request
      final cacheKey = _getCacheKey(err.requestOptions);
      final cachedData = _cacheBox.get(cacheKey);
      if (cachedData != null) {
        debugPrint('⚠️ SWR Cache FALLBACK (any): ${err.requestOptions.path}');
        handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: cachedData,
            statusCode: 200,
            statusMessage: 'OK (cache fallback)',
            headers: Headers.fromMap({
              'X-From-Cache': ['true'],
              'X-Cache-Fallback': ['true'],
            }),
          ),
        );
        return;
      }
    }

    // No cache available, propagate the error
    handler.next(err);
  }

  /// Generate a unique cache key based on path + query params
  /// Includes userId from auth header for multi-user safety
  String _getCacheKey(RequestOptions options) {
    final path = options.path;
    final queryStr = options.queryParameters.isNotEmpty
        ? json.encode(
            Map.fromEntries(
              options.queryParameters.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key)),
            ),
          )
        : '';

    // Extract user token hash for per-user caching
    final authHeader = options.headers['Authorization'] as String?;
    final userHash = authHeader != null
        ? authHeader.hashCode.toString()
        : 'anon';

    return 'swr_${path}_${queryStr}_$userHash';
  }

  /// Check if the endpoint should be cached
  bool _shouldCache(String path) {
    return _masterEndpoints.keys.any((ep) => path.contains(ep)) ||
        _operationalEndpoints.keys.any((ep) => path.contains(ep));
  }

  /// Get cache duration for a given path
  Duration _getCacheDuration(String path) {
    for (final entry in _masterEndpoints.entries) {
      if (path.contains(entry.key)) return entry.value;
    }
    for (final entry in _operationalEndpoints.entries) {
      if (path.contains(entry.key)) return entry.value;
    }
    return const Duration(minutes: 5); // Default
  }

  /// Invalidate caches for related endpoints after a mutation
  Future<void> _invalidateRelatedCaches(String mutationPath) async {
    // Find which cache groups to invalidate
    for (final entry in _invalidationMap.entries) {
      if (mutationPath.contains(entry.key)) {
        for (final endpoint in entry.value) {
          await clearCacheFor(endpoint);
        }
        debugPrint('🗑️ SWR Cache INVALIDATED for: ${entry.value}');
        return;
      }
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final keys = _cacheBox.keys.where(
      (key) => key.toString().startsWith('swr_'),
    );
    for (final key in keys.toList()) {
      await _cacheBox.delete(key);
    }
    debugPrint('🗑️ SWR Cache CLEARED ALL');
  }

  /// Clear cache for a specific endpoint pattern
  Future<void> clearCacheFor(String pathPattern) async {
    final keys = _cacheBox.keys
        .where(
          (key) =>
              key.toString().startsWith('swr_') &&
              key.toString().contains(pathPattern),
        )
        .toList();
    for (final key in keys) {
      await _cacheBox.delete(key);
      await _cacheBox.delete('${key}_time');
    }
  }
}
