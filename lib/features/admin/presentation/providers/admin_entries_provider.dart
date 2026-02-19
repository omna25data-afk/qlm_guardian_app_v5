import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/admin_dashboard_provider.dart';
import '../../../system/data/models/registry_entry_sections.dart';

class AdminEntriesState {
  final List<RegistryEntrySections> entries;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;
  final String? statusFilter;

  const AdminEntriesState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
    this.statusFilter,
  });

  AdminEntriesState copyWith({
    List<RegistryEntrySections>? entries,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
    String? statusFilter,
  }) {
    return AdminEntriesState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class AdminEntriesNotifier extends StateNotifier<AdminEntriesState> {
  final Ref _ref;

  AdminEntriesNotifier(this._ref) : super(const AdminEntriesState());

  Future<void> fetchEntries({
    bool refresh = false,
    String? search,
    String? status,
  }) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminEntriesState(
            searchQuery: search ?? state.searchQuery,
            statusFilter: status ?? state.statusFilter,
            isLoading: true,
          )
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final repository = _ref.read(adminRepositoryProvider);
      final newItems = await repository.getRegistryEntries(
        page: state.page,
        searchQuery: state.searchQuery,
        status: state.statusFilter,
      );

      state = state.copyWith(
        entries: refresh ? newItems : [...state.entries, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 10, // Pagination limit from controller
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    fetchEntries(refresh: true, search: query);
  }

  void setStatusFilter(String? status) {
    fetchEntries(refresh: true, status: status);
  }
}

final adminEntriesProvider =
    StateNotifierProvider<AdminEntriesNotifier, AdminEntriesState>((ref) {
      return AdminEntriesNotifier(ref);
    });
