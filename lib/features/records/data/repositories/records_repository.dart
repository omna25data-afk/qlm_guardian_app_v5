import '../../../../core/network/api_client.dart';
import '../models/record_book.dart';

class RecordsRepository {
  final ApiClient _apiClient;

  RecordsRepository(this._apiClient);

  /// Fetch record books list
  Future<List<RecordBook>> getRecordBooks() async {
    final response = await _apiClient.get('/guardian/record-books');
    final data = response.data is List
        ? response.data
        : (response.data['data'] ?? []);
    return (data as List)
        .map((e) => RecordBook.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch record book details
  Future<RecordBook> getRecordBookDetails(int id) async {
    final response = await _apiClient.get('/guardian/record-books/$id');
    return RecordBook.fromJson(response.data['data'] ?? response.data);
  }

  /// Fetch notebooks for a contract type
  Future<List<RecordBook>> getNotebooks(int contractTypeId) async {
    final response = await _apiClient.get(
      '/record-books/$contractTypeId/notebooks',
    );
    final data = response.data is List
        ? response.data
        : (response.data['data'] ?? []);
    return (data as List)
        .map((e) => RecordBook.fromJson(e as Map<String, dynamic>))
        .toList();
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
