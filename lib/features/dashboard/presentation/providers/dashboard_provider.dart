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
      return DashboardNotifier(repository);
    });

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  final DashboardRepository _repository;

  DashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDashboard();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
