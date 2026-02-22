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
    bool? hasMore,
    int? page,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
    String? typeFilter,
    String? guardianFilter,
    String? groupBy,
    int? contractTypeId,
    bool clearContractTypeId = false,
    String? periodType,
    bool clearPeriodType = false,
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
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      guardianFilter: guardianFilter ?? this.guardianFilter,
      groupBy: groupBy ?? this.groupBy,
      contractTypeId: clearContractTypeId
          ? null
          : (contractTypeId ?? this.contractTypeId),
      periodType: clearPeriodType ? null : (periodType ?? this.periodType),
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
            groupBy: state.groupBy,
            contractTypeId: state.contractTypeId,
            periodType: state.periodType,
            periodYear: state.periodYear,
            dateFrom: state.dateFrom,
            dateTo: state.dateTo,
            sortField: state.sortField,
            sortAscending: state.sortAscending,
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
        contractTypeId: state.contractTypeId,
        sortBy: state.sortField ?? state.groupBy,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
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
    // When changing category, clear guardian filter if not guardian_recording
    if (category != 'guardian_recording') {
      state = state.copyWith(guardianFilter: null);
    }
    fetchBooks(refresh: true, category: category);
  }

  void setTypeFilter(String? type) {
    fetchBooks(refresh: true, type: type);
  }

  void setGuardianFilter(String? guardianId) {
    fetchBooks(refresh: true, guardian: guardianId);
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
    int? periodYear,
    String? dateFrom,
    String? dateTo,
  }) {
    state = state.copyWith(
      periodType: periodType,
      clearPeriodType: periodType == null,
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
    state = state.copyWith(groupBy: groupBy);
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
