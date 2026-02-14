import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/dashboard_data.dart';
import '../../data/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final apiClient = getIt<ApiClient>();
  return DashboardRepository(apiClient);
});

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
      final repository = ref.watch(dashboardRepositoryProvider);
      return DashboardNotifier(repository, isAdmin: false);
    });

final adminDashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
      final repository = ref.watch(dashboardRepositoryProvider);
      return DashboardNotifier(repository, isAdmin: true);
    });

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  final DashboardRepository _repository;
  final bool isAdmin;

  DashboardNotifier(this._repository, {this.isAdmin = false})
    : super(const AsyncValue.loading()) {
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = isAdmin
          ? await _repository.getAdminDashboard()
          : await _repository.getDashboard();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
