import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../models/contract_type_model.dart';
import '../models/form_field_model.dart';

abstract class RegistryRemoteDataSource {
  Future<List<ContractTypeModel>> getContractTypes();
  Future<List<FormFieldModel>> getFormFields(int typeId);
  Future<RegistryEntrySections> createEntry(
    RegistryEntrySections entry, {
    String? attachmentPath,
  });
  Future<List<RegistryEntrySections>> fetchEntries({DateTime? lastSyncedAt});
  Future<void> pushEntries(List<RegistryEntrySections> entries);
}

class RegistryRemoteDataSourceImpl implements RegistryRemoteDataSource {
  final ApiClient _client;

  RegistryRemoteDataSourceImpl(this._client);

  @override
  Future<List<ContractTypeModel>> getContractTypes() async {
    final response = await _client.get(ApiEndpoints.contractTypes);
    final data = response.data['data'] as List;
    return data
        .map(
          (json) => ContractTypeModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<List<FormFieldModel>> getFormFields(int typeId) async {
    final response = await _client.get(ApiEndpoints.formFields(typeId));
    final data = response.data['data'] as List;
    return data
        .map((json) => FormFieldModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<RegistryEntrySections> createEntry(
    RegistryEntrySections entry, {
    String? attachmentPath,
  }) async {
    Map<String, dynamic> data = entry.toJson();

    // Flatten form_data if present, as the API expects flat fields for dynamic attributes
    if (data.containsKey('form_data') && data['form_data'] is Map) {
      final formData = data['form_data'] as Map<String, dynamic>;
      data.remove('form_data');
      data.addAll(formData);
    }

    if (attachmentPath != null) {
      final mapData = Map<String, dynamic>.from(data);
      mapData['document'] = await MultipartFile.fromFile(
        attachmentPath,
        filename: attachmentPath.split('/').last,
      );

      final dioFormData = FormData.fromMap(mapData);

      final response = await _client.post(
        ApiEndpoints.registryEntries,
        data: dioFormData,
      );
      return RegistryEntrySections.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } else {
      final response = await _client.post(
        ApiEndpoints.registryEntries,
        data: data,
      );
      return RegistryEntrySections.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    }
  }

  @override
  Future<List<RegistryEntrySections>> fetchEntries({
    DateTime? lastSyncedAt,
  }) async {
    final response = await _client.get(
      ApiEndpoints.mobileSyncPull,
      queryParameters: lastSyncedAt != null
          ? {'last_synced_at': lastSyncedAt.toIso8601String()}
          : null,
    );

    final data = response.data['registry_entries'] as List;
    return data
        .map(
          (json) =>
              RegistryEntrySections.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<void> pushEntries(List<RegistryEntrySections> entries) async {
    final flattenedEntries = entries.map((e) {
      final json = e.toJson();
      if (json.containsKey('form_data') && json['form_data'] is Map) {
        final formData = json['form_data'] as Map<String, dynamic>;
        json.remove('form_data');
        json.addAll(formData);
      }
      return json;
    }).toList();

    await _client.post(
      ApiEndpoints.mobileSyncPush,
      data: {'registry_entries': flattenedEntries},
    );
  }
}
