import 'package:hive/hive.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../models/record_book.dart';

class RecordsRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  final Box<dynamic> _cacheBox;

  RecordsRepository(this._apiClient, this._networkInfo, this._cacheBox);

  /// Fetch record books list  (Offline-First)
  Future<List<RecordBook>> getRecordBooks() async {
    const cacheKey = 'record_books_list';

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiClient.get('/guardian/record-books');
        final data = response.data is List
            ? response.data
            : (response.data['data'] ?? []);

        // Cache the raw data
        await _cacheBox.put(cacheKey, data);

        return (data as List)
            .map((e) => RecordBook.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Fallback to cache on error
      }
    }

    // Load from cache
    final cachedData = _cacheBox.get(cacheKey);
    if (cachedData != null && cachedData is List) {
      return cachedData
          .map((e) => RecordBook.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // If no cache and no internet/error, rethrow or return empty
    if (cachedData == null) {
      // If we really want to be robust, we could return empty list or throw specialized exception
      // For now, return empty list to avoid UI blocking, or let the provider handle specific empty state
    }

    return [];
  }

  /// Fetch record book details
  Future<RecordBook> getRecordBookDetails(int id) async {
    final response = await _apiClient.get('/guardian/record-books/$id');
    return RecordBook.fromJson(response.data['data'] ?? response.data);
  }

  /// Fetch notebooks for a contract type
  Future<List<RecordBook>> getNotebooks(int contractTypeId) async {
    final cacheKey = 'notebooks_$contractTypeId';

    if (await _networkInfo.isConnected) {
      try {
        final response = await _apiClient.get(
          '/record-books/$contractTypeId/notebooks',
        );
        final data = response.data is List
            ? response.data
            : (response.data['data'] ?? []);

        await _cacheBox.put(cacheKey, data);

        return (data as List)
            .map((e) => RecordBook.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Fallback
      }
    }

    // Fallback to cache
    final cachedData = _cacheBox.get(cacheKey);
    if (cachedData != null && cachedData is List) {
      return cachedData
          .map((e) => RecordBook.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  /// Fetch record book types
  Future<List<Map<String, dynamic>>> getRecordBookTypes() async {
    final response = await _apiClient.get('/record-book-types');
    final data = response.data is List
        ? response.data
        : (response.data['data'] ?? []);
    return (data as List).map((e) => e as Map<String, dynamic>).toList();
  }
}
