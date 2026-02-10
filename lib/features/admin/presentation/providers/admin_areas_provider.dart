import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_area_model.dart';
import 'admin_dashboard_provider.dart';

/// Admin areas state
class AdminAreasState {
  final List<AdminAreaModel> areas;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;

  const AdminAreasState({
    this.areas = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
  });

  AdminAreasState copyWith({
    List<AdminAreaModel>? areas,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
  }) {
    return AdminAreasState(
      areas: areas ?? this.areas,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Admin areas notifier with pagination
class AdminAreasNotifier extends StateNotifier<AdminAreasState> {
  final Ref _ref;

  AdminAreasNotifier(this._ref) : super(const AdminAreasState());

  Future<void> fetchAreas({bool refresh = false, String? search}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminAreasState(searchQuery: search, isLoading: true)
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final repository = _ref.read(adminRepositoryProvider);
      final newItems = await repository.getAreas(
        page: state.page,
        searchQuery: state.searchQuery,
      );

      state = state.copyWith(
        areas: refresh ? newItems : [...state.areas, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminAreasProvider =
    StateNotifierProvider<AdminAreasNotifier, AdminAreasState>((ref) {
      return AdminAreasNotifier(ref);
    });
