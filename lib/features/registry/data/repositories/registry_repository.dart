import 'package:uuid/uuid.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/registry_local_datasource.dart';
import '../datasources/registry_remote_datasource.dart';
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

  /// Create new entry (offline-first)
  Future<RegistryEntryModel> createEntry(RegistryEntryModel entry) async {
    // 1. Generate UUID if not present
    final uuid = entry.uuid.isEmpty ? const Uuid().v4() : entry.uuid;
    final entryWithUuid = entry.copyWith(uuid: uuid, status: 'draft');

    // 2. Save locally
    await _localDataSource.insertEntry(entryWithUuid);

    // 3. Try to sync if online
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.createEntry(entryWithUuid);
        // Update sync status locally if needed
      } catch (e) {
        // Queue for later (handled by SyncService)
        debugPrint('Online creation failed, queued: $e');
      }
    }

    return entryWithUuid;
  }
}
