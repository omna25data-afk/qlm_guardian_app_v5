import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_renewal_model.dart';
import 'admin_dashboard_provider.dart';

class AdminLicensesState {
  final List<AdminRenewalModel> renewals;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;

  const AdminLicensesState({
    this.renewals = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  AdminLicensesState copyWith({
    List<AdminRenewalModel>? renewals,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return AdminLicensesState(
      renewals: renewals ?? this.renewals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class AdminLicensesNotifier extends StateNotifier<AdminLicensesState> {
  final dynamic _repository;

  AdminLicensesNotifier(this._repository) : super(const AdminLicensesState());

  Future<void> fetchLicenses({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const AdminLicensesState(isLoading: true);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final newItems = await _repository.getLicenses(page: state.page);

      state = state.copyWith(
        renewals: refresh ? newItems : [...state.renewals, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<List<AdminRenewalModel>> fetchLicenseHistory(int guardianId) async {
    return await _repository.getLicenses(guardianId: guardianId);
  }

  Future<bool> renewLicense(int guardianId, Map<String, dynamic> data) async {
    try {
      await _repository.submitLicenseRenewal(guardianId, data);
      fetchLicenses(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateRenewal(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateLicenseRenewal(id, data);
      fetchLicenses(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteRenewal(int id) async {
    try {
      await _repository.deleteLicenseRenewal(id);
      fetchLicenses(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
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
