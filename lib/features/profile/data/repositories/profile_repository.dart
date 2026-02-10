import '../../../../core/network/api_client.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  /// Fetch user profile data
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get('/profile');
    return response.data;
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/profile', data: data);
    return response.data;
  }
}
