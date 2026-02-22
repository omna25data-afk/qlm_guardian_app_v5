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
  final String? groupBy; // 'type', 'guardian', 'year', 'writer_type', or null
  final int? contractTypeId;
  final String? periodType; // 'yearly', 'half_yearly', 'quarterly', 'custom'
  final String? periodValue; // '1', '2' or 'Q1', 'Q2', etc.
  final int? periodYear;
  final String? dateFrom;
  final String? dateTo;
  final String?
  sortField; // 'book_number', 'created_at', 'usage', 'entries_count'
  final bool sortAscending;

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
    this.contractTypeId,
    this.periodType,
    this.periodValue,
    this.periodYear,
    this.dateFrom,
    this.dateTo,
    this.sortField,
    this.sortAscending = true,
  });

  AdminRecordBooksState copyWith({
    List<RecordBook>? books,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? hasMore,
    int? page,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? statusFilter,
    bool clearStatusFilter = false,
    String? categoryFilter,
    bool clearCategoryFilter = false,
    String? typeFilter,
    bool clearTypeFilter = false,
    String? guardianFilter,
    bool clearGuardianFilter = false,
    String? groupBy,
    bool clearGroupBy = false,
    int? contractTypeId,
    bool clearContractTypeId = false,
    String? periodType,
    bool clearPeriodType = false,
    String? periodValue,
    bool clearPeriodValue = false,
    int? periodYear,
    bool clearPeriodYear = false,
    String? dateFrom,
    bool clearDateFrom = false,
    String? dateTo,
    bool clearDateTo = false,
    String? sortField,
    bool clearSortField = false,
    bool? sortAscending,
  }) {
    return AdminRecordBooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      categoryFilter: clearCategoryFilter
          ? null
          : (categoryFilter ?? this.categoryFilter),
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      guardianFilter: clearGuardianFilter
          ? null
          : (guardianFilter ?? this.guardianFilter),
      groupBy: clearGroupBy ? null : (groupBy ?? this.groupBy),
      contractTypeId: clearContractTypeId
          ? null
          : (contractTypeId ?? this.contractTypeId),
      periodType: clearPeriodType ? null : (periodType ?? this.periodType),
      periodValue: clearPeriodValue ? null : (periodValue ?? this.periodValue),
      periodYear: clearPeriodYear ? null : (periodYear ?? this.periodYear),
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      sortField: clearSortField ? null : (sortField ?? this.sortField),
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

class AdminRecordBooksNotifier extends StateNotifier<AdminRecordBooksState> {
  final dynamic _repository;

  AdminRecordBooksNotifier(this._repository)
    : super(const AdminRecordBooksState());

  Future<void> fetchBooks({bool refresh = false}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? state.copyWith(
            isLoading: true,
            page: 1,
            hasMore: true,
            clearError: true,
          )
        : state.copyWith(isLoading: true, clearError: true);
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
        contractTypeId: state.contractTypeId,
        sortBy: state.sortField ?? state.groupBy,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        periodType: state.periodType,
        periodValue: state.periodValue,
        periodYear: state.periodYear,
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
    state = state.copyWith(searchQuery: query, clearSearchQuery: query.isEmpty);
    fetchBooks(refresh: true);
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(
      statusFilter: status,
      clearStatusFilter: status == null,
    );
    fetchBooks(refresh: true);
  }

  void setCategoryFilter(String? category) {
    // When changing category, clear guardian filter if not guardian_recording
    if (category != 'guardian_recording') {
      state = state.copyWith(clearGuardianFilter: true);
    }
    state = state.copyWith(
      categoryFilter: category,
      clearCategoryFilter: category == null,
    );
    fetchBooks(refresh: true);
  }

  void setTypeFilter(String? type) {
    state = state.copyWith(typeFilter: type, clearTypeFilter: type == null);
    fetchBooks(refresh: true);
  }

  void setGuardianFilter(String? guardianId) {
    state = state.copyWith(
      guardianFilter: guardianId,
      clearGuardianFilter: guardianId == null,
    );
    fetchBooks(refresh: true);
  }

  void setContractTypeId(int? contractTypeId) {
    if (contractTypeId == null) {
      state = state.copyWith(clearContractTypeId: true);
    } else {
      state = state.copyWith(contractTypeId: contractTypeId);
    }
    fetchBooks(refresh: true);
  }

  void setPeriodFilter({
    String? periodType,
    String? periodValue,
    int? periodYear,
    String? dateFrom,
    String? dateTo,
  }) {
    state = state.copyWith(
      periodType: periodType,
      clearPeriodType: periodType == null,
      periodValue: periodValue,
      clearPeriodValue:
          periodValue == null &&
          periodType != 'half_yearly' &&
          periodType != 'quarterly',
      periodYear: periodYear,
      clearPeriodYear: periodYear == null,
      dateFrom: dateFrom,
      clearDateFrom: dateFrom == null,
      dateTo: dateTo,
      clearDateTo: dateTo == null,
    );
    fetchBooks(refresh: true);
  }

  void setSortField(String? field, {bool ascending = true}) {
    if (field == null) {
      state = state.copyWith(clearSortField: true, sortAscending: ascending);
    } else {
      state = state.copyWith(sortField: field, sortAscending: ascending);
    }
    fetchBooks(refresh: true);
  }

  void setGroupBy(String? groupBy) {
    state = state.copyWith(groupBy: groupBy, clearGroupBy: groupBy == null);
    fetchBooks(refresh: true);
  }

  void clearAllFilters() {
    state = const AdminRecordBooksState();
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
