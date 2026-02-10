import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/registry_entry_model.dart';

abstract class RegistryRemoteDataSource {
  Future<List<RegistryEntryModel>> fetchEntries({DateTime? lastSyncedAt});
  Future<RegistryEntryModel> createEntry(RegistryEntryModel entry);
  Future<void> pushEntries(List<RegistryEntryModel> entries);
}

class RegistryRemoteDataSourceImpl implements RegistryRemoteDataSource {
  final ApiClient _client;

  RegistryRemoteDataSourceImpl(this._client);

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
  Future<RegistryEntryModel> createEntry(RegistryEntryModel entry) async {
    // Direct creation if online (optional, usually handled by Sync)
    final response = await _client.post(
      '/api/registry-entries',
      data: entry.toJson(),
    );
    return RegistryEntryModel.fromJson(response.data['data']);
  }

  @override
  Future<void> pushEntries(List<RegistryEntryModel> entries) async {
    await _client.post(
      ApiEndpoints.mobileSyncPush,
      data: {'registry_entries': entries.map((e) => e.toJson()).toList()},
    );
  }
}
