import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/registry/data/models/registry_entry_model.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminPendingEntriesState {
  final List<RegistryEntryModel> entries;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;
  final int? yearFilter;
  final int? contractTypeFilter;

  const AdminPendingEntriesState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
    this.yearFilter,
    this.contractTypeFilter,
  });

  AdminPendingEntriesState copyWith({
    List<RegistryEntryModel>? entries,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
    int? yearFilter,
    int? contractTypeFilter,
  }) {
    return AdminPendingEntriesState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      yearFilter: yearFilter ?? this.yearFilter,
      contractTypeFilter: contractTypeFilter ?? this.contractTypeFilter,
    );
  }
}

class AdminPendingEntriesNotifier
    extends StateNotifier<AdminPendingEntriesState> {
  final dynamic _repository;

  AdminPendingEntriesNotifier(this._repository)
    : super(const AdminPendingEntriesState());

  Future<void> fetchEntries({bool refresh = false}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminPendingEntriesState(
            searchQuery: state.searchQuery,
            yearFilter: state.yearFilter,
            contractTypeFilter: state.contractTypeFilter,
            isLoading: true,
          )
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final newItems = await _repository.getPendingEntries(
        page: state.page,
        search: state.searchQuery,
        year: state.yearFilter,
        contractTypeId: state.contractTypeFilter,
      );

      state = state.copyWith(
        entries: refresh ? newItems : [...state.entries, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchEntries(refresh: true);
  }

  void setYearFilter(int? year) {
    state = state.copyWith(yearFilter: year);
    fetchEntries(refresh: true);
  }

  void setContractTypeFilter(int? contractTypeId) {
    state = state.copyWith(contractTypeFilter: contractTypeId);
    fetchEntries(refresh: true);
  }
}

final adminPendingEntriesProvider =
    StateNotifierProvider<
      AdminPendingEntriesNotifier,
      AdminPendingEntriesState
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminPendingEntriesNotifier(repository);
    });

/// Provider for documenting an entry
final documentEntryProvider =
    StateNotifierProvider<DocumentEntryNotifier, DocumentEntryState>((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return DocumentEntryNotifier(repository);
    });

class DocumentEntryState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final Map<String, dynamic>? calculatedFees;

  const DocumentEntryState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.calculatedFees,
  });

  DocumentEntryState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    Map<String, dynamic>? calculatedFees,
  }) {
    return DocumentEntryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      calculatedFees: calculatedFees ?? this.calculatedFees,
    );
  }
}

class DocumentEntryNotifier extends StateNotifier<DocumentEntryState> {
  final dynamic _repository;

  DocumentEntryNotifier(this._repository) : super(const DocumentEntryState());

  Future<bool> documentEntry(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      await _repository.documentEntry(id, data);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم توثيق القيد بنجاح',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> calculateFees(int id, {double? contractValue}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fees = await _repository.calculateFees(
        id,
        contractValue: contractValue,
      );
      state = state.copyWith(isLoading: false, calculatedFees: fees);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
