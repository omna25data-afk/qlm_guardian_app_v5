import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_guardian_model.dart';
import 'admin_dashboard_provider.dart';

// State definitions
class AdminGuardiansState {
  final List<AdminGuardianModel> guardians;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;

  const AdminGuardiansState({
    this.guardians = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
  });

  AdminGuardiansState copyWith({
    List<AdminGuardianModel>? guardians,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
  }) {
    return AdminGuardiansState(
      guardians: guardians ?? this.guardians,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AdminGuardiansNotifier extends StateNotifier<AdminGuardiansState> {
  final dynamic _repository;
  Timer? _debounceTimer;

  AdminGuardiansNotifier(this._repository)
    : super(const AdminGuardiansState()) {
    fetchGuardians();
  }

  Future<void> fetchGuardians({bool refresh = false, String? query}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminGuardiansState(
            searchQuery: query ?? state.searchQuery,
            isLoading: true,
          )
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final newItems = await _repository.getGuardians(
        query: state.searchQuery,
        page: state.page,
      );

      state = state.copyWith(
        guardians: refresh ? newItems : [...state.guardians, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 10, // Assuming page size 10
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchGuardians(refresh: true, query: query);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final adminGuardiansProvider =
    StateNotifierProvider.autoDispose<
      AdminGuardiansNotifier,
      AdminGuardiansState
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminGuardiansNotifier(repository);
    });
