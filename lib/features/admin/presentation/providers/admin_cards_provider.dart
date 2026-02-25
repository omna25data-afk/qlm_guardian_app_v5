import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_guardian_model.dart';
import '../../data/models/admin_renewal_model.dart';
import 'admin_dashboard_provider.dart';

class AdminCardsState {
  final List<AdminRenewalModel> renewals;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;

  const AdminCardsState({
    this.renewals = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
  });

  AdminCardsState copyWith({
    List<AdminRenewalModel>? renewals,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
  }) {
    return AdminCardsState(
      renewals: renewals ?? this.renewals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AdminCardsNotifier extends StateNotifier<AdminCardsState> {
  final dynamic _repository;
  Timer? _debounceTimer;

  AdminCardsNotifier(this._repository) : super(const AdminCardsState());

  Future<void> fetchCards({bool refresh = false, String? query}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminCardsState(
            searchQuery: query ?? state.searchQuery,
            isLoading: true,
          )
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final newItems = await _repository.getCards(
        query: state.searchQuery,
        page: state.page,
      );

      state = state.copyWith(
        renewals: refresh ? newItems : [...state.renewals, ...newItems],
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
      fetchCards(refresh: true, query: query);
    });
  }

  Future<bool> renewCard(int guardianId, Map<String, dynamic> data) async {
    try {
      await _repository.submitCardRenewal(guardianId, data);
      // Refresh list after successful renewal
      fetchCards(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<List<AdminRenewalModel>> fetchCardHistory(int guardianId) async {
    return await _repository.getCards(guardianId: guardianId);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final adminCardsProvider =
    StateNotifierProvider.autoDispose<AdminCardsNotifier, AdminCardsState>((
      ref,
    ) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminCardsNotifier(repository);
    });
