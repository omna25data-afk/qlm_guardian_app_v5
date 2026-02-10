import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_renewal_model.dart';
import 'admin_dashboard_provider.dart';

class AdminLicensesState {
  final List<AdminRenewalModel> licenses;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;

  const AdminLicensesState({
    this.licenses = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  AdminLicensesState copyWith({
    List<AdminRenewalModel>? licenses,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return AdminLicensesState(
      licenses: licenses ?? this.licenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class AdminLicensesNotifier extends StateNotifier<AdminLicensesState> {
  final Ref _ref;

  AdminLicensesNotifier(this._ref) : super(const AdminLicensesState());

  Future<void> fetchLicenses({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const AdminLicensesState(isLoading: true);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final repository = _ref.read(adminRepositoryProvider);
      final newItems = await repository.getLicenses(page: state.page);

      state = state.copyWith(
        licenses: refresh ? newItems : [...state.licenses, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminLicensesProvider =
    StateNotifierProvider<AdminLicensesNotifier, AdminLicensesState>((ref) {
      return AdminLicensesNotifier(ref);
    });
