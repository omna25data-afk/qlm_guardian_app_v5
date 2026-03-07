import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/records/data/models/record_book.dart';
import '../../data/repositories/admin_repository.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_dashboard_provider.dart';

// State for the Admin Record Book Containers
class AdminContainersState {
  final bool isLoading;
  final String? error;
  final List<RecordBook> containers;

  AdminContainersState({
    this.isLoading = false,
    this.error,
    this.containers = const [],
  });

  AdminContainersState copyWith({
    bool? isLoading,
    String? error,
    List<RecordBook>? containers,
  }) {
    return AdminContainersState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      containers: containers ?? this.containers,
    );
  }
}

// Notifier for managing containers state
class AdminContainersNotifier extends StateNotifier<AdminContainersState> {
  final AdminRepository _repository;

  AdminContainersNotifier(this._repository) : super(AdminContainersState());

  Future<void> loadContainers({
    String? category,
    int? year,
    String? dateFrom,
    String? dateTo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final containers = await _repository.getRecordBookContainers(
        category: category,
        year: year,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      state = state.copyWith(isLoading: false, containers: containers);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Reload action
  Future<void> refresh({
    String? category,
    int? year,
    String? dateFrom,
    String? dateTo,
  }) {
    return loadContainers(
      category: category,
      year: year,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}

// Provider
final adminContainersProvider =
    StateNotifierProvider<AdminContainersNotifier, AdminContainersState>((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminContainersNotifier(repository);
    });
