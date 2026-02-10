import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_assignment_model.dart';
import 'admin_dashboard_provider.dart';

class AdminAssignmentsState {
  final List<AdminAssignmentModel> assignments;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? status;
  final String? type;

  const AdminAssignmentsState({
    this.assignments = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.status,
    this.type,
  });

  AdminAssignmentsState copyWith({
    List<AdminAssignmentModel>? assignments,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? status,
    String? type,
  }) {
    return AdminAssignmentsState(
      assignments: assignments ?? this.assignments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

class AdminAssignmentsNotifier extends StateNotifier<AdminAssignmentsState> {
  final Ref _ref;

  AdminAssignmentsNotifier(this._ref) : super(const AdminAssignmentsState());

  Future<void> fetchAssignments({
    bool refresh = false,
    String? status,
    String? type,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = state.copyWith(
        assignments: [],
        isLoading: true,
        page: 1,
        hasMore: true,
        status: status,
        type: type,
      );
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final repository = _ref.read(adminRepositoryProvider);
      final newItems = await repository.getAssignments(
        page: state.page,
        status: state.status,
        type: state.type,
      );

      state = state.copyWith(
        assignments: refresh ? newItems : [...state.assignments, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminAssignmentsProvider =
    StateNotifierProvider<AdminAssignmentsNotifier, AdminAssignmentsState>((
      ref,
    ) {
      return AdminAssignmentsNotifier(ref);
    });
