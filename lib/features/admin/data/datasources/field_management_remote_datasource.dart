import 'dart:convert';
import '../../../../core/network/api_client.dart';

class FieldManagementRemoteDataSource {
  final ApiClient _apiClient;

  FieldManagementRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> fetchFields({int? contractTypeId}) async {
    final queryParams = contractTypeId != null
        ? '?contract_type_id=$contractTypeId'
        : '';
    final response = await _apiClient.get(
      '/admin/form-field-configs$queryParams',
    );

    if (response.statusCode == 200) {
      if (response.data is String) {
        return json.decode(response.data);
      }
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load fields configurations');
    }
  }

  Future<void> updateField(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.put(
      '/admin/form-field-configs/$id',
      data: data,
    );

    if (response.statusCode != 200) {
      final responseData = response.data;
      throw Exception(
        (responseData is Map ? responseData['message'] : null) ??
            'Failed to update field configuration',
      );
    }
  }
}
