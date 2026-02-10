import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/contract_type_model.dart';
import '../models/form_field_model.dart';
import '../models/registry_entry_model.dart';

abstract class RegistryRemoteDataSource {
  Future<List<ContractTypeModel>> getContractTypes();
  Future<List<FormFieldModel>> getFormFields(int typeId);
  Future<RegistryEntryModel> createEntry(
    RegistryEntryModel entry, {
    String? attachmentPath,
  });
  Future<List<RegistryEntryModel>> fetchEntries({DateTime? lastSyncedAt});
  Future<void> pushEntries(List<RegistryEntryModel> entries);
}

class RegistryRemoteDataSourceImpl implements RegistryRemoteDataSource {
  final ApiClient _client;

  RegistryRemoteDataSourceImpl(this._client);

  @override
  Future<List<ContractTypeModel>> getContractTypes() async {
    final response = await _client.get(ApiEndpoints.contractTypes);
    final data = response.data['data'] as List;
    return data.map((json) => ContractTypeModel.fromJson(json)).toList();
  }

  @override
  Future<List<FormFieldModel>> getFormFields(int typeId) async {
    final response = await _client.get(ApiEndpoints.formFields(typeId));
    final data = response.data['data'] as List;
    return data.map((json) => FormFieldModel.fromJson(json)).toList();
  }

  @override
  Future<RegistryEntryModel> createEntry(
    RegistryEntryModel entry, {
    String? attachmentPath,
  }) async {
    dynamic data = entry.toJson();

    // If we have an attachment, we must use FormData
    if (attachmentPath != null) {
      final mapData = Map<String, dynamic>.from(data);
      if (entry.extraAttributes != null) {
        mapData.addAll(entry.extraAttributes!);
      }

      mapData['document'] = await MultipartFile.fromFile(
        attachmentPath,
        filename: attachmentPath.split('/').last,
      );

      data = FormData.fromMap(mapData);
    } else {
      // Logic for standard JSON with extra attributes
      if (entry.extraAttributes != null) {
        final mapData = Map<String, dynamic>.from(data);
        mapData.addAll(entry.extraAttributes!);
        data = mapData;
      }
    }

    // Use general endpoint for creation
    final response = await _client.post(
      ApiEndpoints.registryEntries,
      data: data,
    );
    return RegistryEntryModel.fromJson(response.data['data']);
  }

  @override
  Future<List<RegistryEntryModel>> fetchEntries({
    DateTime? lastSyncedAt,
  }) async {
    final response = await _client.get(
      ApiEndpoints.mobileSyncPull,
      queryParameters: lastSyncedAt != null
          ? {'last_synced_at': lastSyncedAt.toIso8601String()}
          : null,
    );

    final data = response.data['registry_entries'] as List;
    return data.map((json) => RegistryEntryModel.fromJson(json)).toList();
  }

  @override
  Future<void> pushEntries(List<RegistryEntryModel> entries) async {
    await _client.post(
      ApiEndpoints.mobileSyncPush,
      data: {'registry_entries': entries.map((e) => e.toJson()).toList()},
    );
  }
}
