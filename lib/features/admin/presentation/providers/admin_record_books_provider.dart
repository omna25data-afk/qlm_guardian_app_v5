import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/records/data/models/record_book.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminRecordBooksState {
  final List<RecordBook> books;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;
  final String? statusFilter;

  const AdminRecordBooksState({
    this.books = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
    this.statusFilter,
  });

  AdminRecordBooksState copyWith({
    List<RecordBook>? books,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
    String? statusFilter,
  }) {
    return AdminRecordBooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class AdminRecordBooksNotifier extends StateNotifier<AdminRecordBooksState> {
  final dynamic _repository;

  AdminRecordBooksNotifier(this._repository)
    : super(const AdminRecordBooksState());

  Future<void> fetchBooks({
    bool refresh = false,
    String? search,
    String? status,
  }) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminRecordBooksState(
            searchQuery: search ?? state.searchQuery,
            statusFilter: status ?? state.statusFilter,
            isLoading: true,
          )
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final newItems = await _repository.getRecordBooks(
        page: state.page,
        searchQuery: state.searchQuery,
        status: state.statusFilter,
      );

      state = state.copyWith(
        books: refresh ? newItems : [...state.books, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 10,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    fetchBooks(refresh: true, search: query);
  }

  void setStatusFilter(String? status) {
    fetchBooks(refresh: true, status: status);
  }
}

final adminRecordBooksProvider =
    StateNotifierProvider<AdminRecordBooksNotifier, AdminRecordBooksState>((
      ref,
    ) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminRecordBooksNotifier(repository);
    });
