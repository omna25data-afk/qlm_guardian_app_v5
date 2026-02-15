import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminInspectionState {
  final List<Map<String, dynamic>> recordBooks;
  final Map<String, dynamic>? selectedRecordBook;
  final List<Map<String, dynamic>> entryNotes;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;

  const AdminInspectionState({
    this.recordBooks = const [],
    this.selectedRecordBook,
    this.entryNotes = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
  });

  AdminInspectionState copyWith({
    List<Map<String, dynamic>>? recordBooks,
    Map<String, dynamic>? selectedRecordBook,
    List<Map<String, dynamic>>? entryNotes,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
  }) {
    return AdminInspectionState(
      recordBooks: recordBooks ?? this.recordBooks,
      selectedRecordBook: selectedRecordBook ?? this.selectedRecordBook,
      entryNotes: entryNotes ?? this.entryNotes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AdminInspectionNotifier extends StateNotifier<AdminInspectionState> {
  final dynamic _repository;

  AdminInspectionNotifier(this._repository)
    : super(const AdminInspectionState());

  Future<void> fetchRecordBooks({bool refresh = false}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminInspectionState(searchQuery: state.searchQuery, isLoading: true)
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final items = await _repository.getInspectionRecordBooks(
        page: state.page,
        search: state.searchQuery,
      );

      state = state.copyWith(
        recordBooks: refresh ? items : [...state.recordBooks, ...items],
        isLoading: false,
        hasMore: items.length >= 15,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchRecordBookDetail(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final detail = await _repository.getInspectionRecordBookDetail(id);
      state = state.copyWith(isLoading: false, selectedRecordBook: detail);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchEntryNotes({int? registryEntryId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notes = await _repository.getEntryInspectionNotes(
        registryEntryId: registryEntryId,
      );
      state = state.copyWith(isLoading: false, entryNotes: notes);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchRecordBooks(refresh: true);
  }
}

final adminInspectionProvider =
    StateNotifierProvider<AdminInspectionNotifier, AdminInspectionState>((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminInspectionNotifier(repository);
    });
