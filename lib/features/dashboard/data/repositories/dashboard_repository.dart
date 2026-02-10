import '../../../../core/network/api_client.dart';
import '../models/dashboard_data.dart';

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository(this._apiClient);

  /// Fetch guardian dashboard data
  Future<DashboardData> getDashboard() async {
    final response = await _apiClient.get('/dashboard');
    return DashboardData.fromJson(response.data);
  }
}
