import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_renewal_model.dart';
import 'admin_dashboard_provider.dart';

class AdminCardsState {
  final List<AdminRenewalModel> renewals;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;

  const AdminCardsState({
    this.renewals = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  AdminCardsState copyWith({
    List<AdminRenewalModel>? renewals,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return AdminCardsState(
      renewals: renewals ?? this.renewals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class AdminCardsNotifier extends StateNotifier<AdminCardsState> {
  final dynamic _repository;

  AdminCardsNotifier(this._repository) : super(const AdminCardsState());

  Future<void> fetchCards({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const AdminCardsState(isLoading: true);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final newItems = await _repository.getCards(page: state.page);

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

  Future<List<AdminRenewalModel>> fetchCardHistory(int guardianId) async {
    return await _repository.getCards(guardianId: guardianId);
  }

  Future<bool> renewCard(int guardianId, Map<String, dynamic> data) async {
    try {
      await _repository.submitCardRenewal(guardianId, data);
      fetchCards(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateRenewal(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateCardRenewal(id, data);
      fetchCards(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteRenewal(int id) async {
    try {
      await _repository.deleteCardRenewal(id);
      fetchCards(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final adminCardsProvider =
    StateNotifierProvider.autoDispose<AdminCardsNotifier, AdminCardsState>((
      ref,
    ) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminCardsNotifier(repository);
    });
