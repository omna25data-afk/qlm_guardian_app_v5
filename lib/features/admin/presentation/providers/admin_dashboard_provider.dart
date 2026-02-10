import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/admin_dashboard_data.dart';
import '../../data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final apiClient = getIt<ApiClient>();
  return AdminRepository(apiClient);
});

final adminDashboardProvider =
    StateNotifierProvider<
      AdminDashboardNotifier,
      AsyncValue<AdminDashboardData>
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminDashboardNotifier(repository);
    });

class AdminDashboardNotifier
    extends StateNotifier<AsyncValue<AdminDashboardData>> {
  final AdminRepository _repository;

  AdminDashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDashboardData();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
