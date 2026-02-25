import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_guardian_model.dart';
import '../../data/models/admin_renewal_model.dart';
import 'admin_dashboard_provider.dart';

class AdminLicensesState {
  final List<AdminGuardianModel> guardians;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;

  const AdminLicensesState({
    this.guardians = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
  });

  AdminLicensesState copyWith({
    List<AdminGuardianModel>? guardians,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
  }) {
    return AdminLicensesState(
      guardians: guardians ?? this.guardians,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AdminLicensesNotifier extends StateNotifier<AdminLicensesState> {
  final dynamic _repository;
  Timer? _debounceTimer;

  AdminLicensesNotifier(this._repository) : super(const AdminLicensesState());

  Future<void> fetchLicenses({bool refresh = false, String? query}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminLicensesState(
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
        hasMore: newItems.length >= 10,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchLicenses(refresh: true, query: query);
    });
  }

  Future<bool> renewLicense(int guardianId, Map<String, dynamic> data) async {
    try {
      await _repository.submitLicenseRenewal(guardianId, data);
      // Refresh list after successful renewal
      fetchLicenses(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<List<AdminRenewalModel>> fetchLicenseHistory(int guardianId) async {
    return await _repository.getLicenses(guardianId: guardianId);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final adminLicensesProvider =
    StateNotifierProvider.autoDispose<
      AdminLicensesNotifier,
      AdminLicensesState
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminLicensesNotifier(repository);
    });
