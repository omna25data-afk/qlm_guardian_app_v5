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
  final String? categoryFilter;
  final String? typeFilter;
  final String? guardianFilter;
  final String? groupBy; // 'type', 'guardian', or null

  const AdminRecordBooksState({
    this.books = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
    this.statusFilter,
    this.categoryFilter,
    this.typeFilter,
    this.guardianFilter,
    this.groupBy,
  });

  AdminRecordBooksState copyWith({
    List<RecordBook>? books,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
    String? typeFilter,
    String? guardianFilter,
    String? groupBy,
  }) {
    return AdminRecordBooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      guardianFilter: guardianFilter ?? this.guardianFilter,
      groupBy: groupBy ?? this.groupBy,
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
    String? category,
    String? type,
    String? guardian,
  }) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminRecordBooksState(
            searchQuery: search ?? state.searchQuery,
            statusFilter: status ?? state.statusFilter,
            categoryFilter: category ?? state.categoryFilter,
            typeFilter: type ?? state.typeFilter,
            guardianFilter: guardian ?? state.guardianFilter,
            groupBy: state
                .groupBy, // Persist groupBy on refresh unless explicitly changed via separate method
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
        category: state.categoryFilter,
        type: state.typeFilter,
        guardianId: state.guardianFilter,
        sortBy: state.groupBy, // Pass groupBy as sortBy
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

  void setCategoryFilter(String? category) {
    fetchBooks(refresh: true, category: category);
  }

  void setTypeFilter(String? type) {
    fetchBooks(refresh: true, type: type);
  }

  void setGuardianFilter(String? guardianId) {
    fetchBooks(refresh: true, guardian: guardianId);
  }

  void setGroupBy(String? groupBy) {
    // When grouping changes, we must refresh to get sorted data
    state = state.copyWith(groupBy: groupBy);
    fetchBooks(refresh: true);
  }
}

final adminRecordBooksProvider =
    StateNotifierProvider<AdminRecordBooksNotifier, AdminRecordBooksState>((
      ref,
    ) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminRecordBooksNotifier(repository);
    });
