import 'package:uuid/uuid.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/registry_local_datasource.dart';
import '../datasources/registry_remote_datasource.dart';
import '../models/contract_type_model.dart';
import '../models/form_field_model.dart';
import '../models/registry_entry_model.dart';
import 'package:flutter/foundation.dart';

class RegistryRepository {
  final RegistryLocalDataSource _localDataSource;
  final RegistryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RegistryRepository({
    required RegistryLocalDataSource localDataSource,
    required RegistryRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  /// Get all entries (offline-first)
  Future<List<RegistryEntryModel>> getEntries() async {
    // 1. Try to sync if online
    if (await _networkInfo.isConnected) {
      try {
        // TODO: Get lastSyncedAt from preferences
        final remoteEntries = await _remoteDataSource.fetchEntries();
        for (var entry in remoteEntries) {
          await _localDataSource.insertEntry(entry);
        }
      } catch (e) {
        // Ignore sync errors, fallback to local
        debugPrint('Sync failed: $e');
      }
    }

    // 2. Return local data
    return _localDataSource.getAllEntries();
  }

  Future<List<ContractTypeModel>> getContractTypes() async {
    if (await _networkInfo.isConnected) {
      return _remoteDataSource.getContractTypes();
    }
    // Fallback to local cache if implemented later
    return [];
  }

  Future<List<FormFieldModel>> getFormFields(int typeId) async {
    if (await _networkInfo.isConnected) {
      return _remoteDataSource.getFormFields(typeId);
    }
    return [];
  }

  /// Create new entry (offline-first)
  Future<RegistryEntryModel> createEntry(
    RegistryEntryModel entry, {
    String? attachmentPath,
  }) async {
    // 1. Generate UUID if not present
    final uuid = entry.uuid.isEmpty ? const Uuid().v4() : entry.uuid;
    final entryWithUuid = entry.copyWith(uuid: uuid, status: 'draft');

    // 2. Save locally (Basic info only, extras/file might be lost if offline)
    await _localDataSource.insertEntry(entryWithUuid);

    // 3. Try to sync if online
    if (await _networkInfo.isConnected) {
      try {
        final created = await _remoteDataSource.createEntry(
          entryWithUuid,
          attachmentPath: attachmentPath,
        );
        // Update local with remote ID/Extras if returned
        await _localDataSource.updateEntry(created);
        return created;
      } catch (e) {
        // Queue for later (handled by SyncService)
        debugPrint('Online creation failed, queued: $e');
        if (attachmentPath != null) {
          debugPrint(
            'WARNING: Attachment will not be synced by standard sync service!',
          );
        }
      }
    }

    return entryWithUuid;
  }
}
