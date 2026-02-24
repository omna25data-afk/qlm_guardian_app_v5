import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_renewal_model.dart';
import 'admin_dashboard_provider.dart';

class AdminCardsState {
  final List<AdminRenewalModel> cards;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;

  const AdminCardsState({
    this.cards = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  AdminCardsState copyWith({
    List<AdminRenewalModel>? cards,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return AdminCardsState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class AdminCardsNotifier extends StateNotifier<AdminCardsState> {
  final Ref _ref;

  AdminCardsNotifier(this._ref) : super(const AdminCardsState());

  Future<void> fetchCards({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const AdminCardsState(isLoading: true);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final repository = _ref.read(adminRepositoryProvider);
      final newItems = await repository.getCards(page: state.page);

      state = state.copyWith(
        cards: refresh ? newItems : [...state.cards, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> renewCard(int guardianId, Map<String, dynamic> data) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.submitCardRenewal(guardianId, data);
      // Refresh list after successful renewal
      fetchCards(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final adminCardsProvider =
    StateNotifierProvider<AdminCardsNotifier, AdminCardsState>((ref) {
      return AdminCardsNotifier(ref);
    });
