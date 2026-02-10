import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/record_book.dart';
import '../../data/repositories/records_repository.dart';

final recordsRepositoryProvider = Provider<RecordsRepository>((ref) {
  final apiClient = getIt<ApiClient>();
  return RecordsRepository(apiClient);
});

final recordBooksProvider =
    StateNotifierProvider<RecordBooksNotifier, AsyncValue<List<RecordBook>>>((
      ref,
    ) {
      final repository = ref.watch(recordsRepositoryProvider);
      return RecordBooksNotifier(repository);
    });

class RecordBooksNotifier extends StateNotifier<AsyncValue<List<RecordBook>>> {
  final RecordsRepository _repository;

  RecordBooksNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchRecordBooks();
  }

  Future<void> fetchRecordBooks() async {
    state = const AsyncValue.loading();
    try {
      final books = await _repository.getRecordBooks();
      state = AsyncValue.data(books);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
