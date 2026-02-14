import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/dashboard_data.dart';

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository(this._apiClient);

  /// Fetch guardian dashboard data
  Future<DashboardData> getDashboard() async {
    final response = await _apiClient.get(ApiEndpoints.dashboard);
    return _parseDashboardResponse(response.data);
  }

  /// Fetch admin dashboard data
  Future<DashboardData> getAdminDashboard() async {
    final response = await _apiClient.get(ApiEndpoints.adminDashboard);
    return _parseDashboardResponse(response.data);
  }

  DashboardData _parseDashboardResponse(dynamic responseData) {
    // Backend wraps responses with ApiResponse trait: {status, code, message, data}
    final data =
        responseData is Map<String, dynamic> &&
            responseData.containsKey('status') &&
            responseData.containsKey('data')
        ? responseData['data'] as Map<String, dynamic>? ?? responseData
        : responseData as Map<String, dynamic>;

    return DashboardData.fromJson(data);
  }
}
