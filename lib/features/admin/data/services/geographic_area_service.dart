import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:qlm_guardian_app_v5/core/network/api_client.dart';
import 'package:qlm_guardian_app_v5/core/network/api_endpoints.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_area_model.dart';

final geographicAreaServiceProvider = Provider<GeographicAreaService>((ref) {
  return GeographicAreaService(GetIt.I<ApiClient>());
});

class GeographicAreaService {
  final ApiClient _apiClient;

  GeographicAreaService(this._apiClient);

  Future<List<AdminAreaModel>> getAreas({int? parentId}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.adminAreas,
        queryParameters: {
          if (parentId != null) 'parent_id': parentId else 'level': 1,
          'type':
              'all', // Ensure we get all types if needed, or filter by level logic in backend
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AdminAreaModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      throw Exception('Error fetching areas: $e');
    }
  }
}
