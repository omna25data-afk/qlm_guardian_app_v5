import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/sync/sync_service.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../datasources/registry_local_datasource.dart';
import '../datasources/registry_remote_datasource.dart';
import '../models/contract_type_model.dart';
import '../models/form_field_model.dart';
import 'package:flutter/foundation.dart';

class RegistryRepository {
  final RegistryLocalDataSource _localDataSource;
  final RegistryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final Box<dynamic> _cacheBox;
  final SyncService _syncService;

  RegistryRepository({
    required RegistryLocalDataSource localDataSource,
    required RegistryRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
    required Box<dynamic> cacheBox,
    required SyncService syncService,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo,
       _cacheBox = cacheBox,
       _syncService = syncService;

  /// Get all entries (offline-first)
  Future<List<RegistryEntrySections>> getEntries() async {
    // 1. Try to sync if online
    if (await _networkInfo.isConnected) {
      try {
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
      try {
        final types = await _remoteDataSource.getContractTypes();
        // Cache types
        await _cacheBox.put(
          'contract_types',
          types.map((t) => t.toJson()).toList(),
        );
        return types;
      } catch (e) {
        debugPrint('Failed to fetch contract types: $e');
      }
    }

    // Fallback to cache
    final cached = _cacheBox.get('contract_types') as List<dynamic>?;
    if (cached != null) {
      return cached
          .map(
            (json) =>
                ContractTypeModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    }
    return [];
  }

  Future<List<FormFieldModel>> getFormFields(int typeId) async {
    final cacheKey = 'form_fields_$typeId';
    if (await _networkInfo.isConnected) {
      try {
        final fields = await _remoteDataSource.getFormFields(typeId);
        // Cache fields
        await _cacheBox.put(cacheKey, fields.map((f) => f.toJson()).toList());
        return fields;
      } catch (e) {
        debugPrint('Failed to fetch form fields: $e');
      }
    }

    // Fallback to cache
    final cached = _cacheBox.get(cacheKey) as List<dynamic>?;
    if (cached != null) {
      return cached
          .map(
            (json) => FormFieldModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    }
    return [];
  }

  /// Create new entry (offline-first)
  Future<RegistryEntrySections> createEntry(
    RegistryEntrySections entry, {
    String? attachmentPath,
  }) async {
    // 1. Generate UUID if not present
    final uuid = (entry.uuid?.isEmpty ?? true)
        ? const Uuid().v4()
        : entry.uuid!;

    // Create new entry with UUID and Draft status
    // Utilizing copyWith-like logic (RegistryEntrySections is immutable)
    // We need to create a new instance with updated uuid/status

    final entryWithUuid = RegistryEntrySections(
      id: entry.id,
      uuid: uuid,
      remoteId: entry.remoteId,
      basicInfo: entry.basicInfo,
      writerInfo: entry.writerInfo,
      documentInfo: entry.documentInfo,
      financialInfo: entry.financialInfo,
      guardianInfo: entry.guardianInfo,
      statusInfo: RegistryStatusInfo(
        status: 'draft',
        deliveryStatus: entry.statusInfo.deliveryStatus,
        statusColor: entry.statusInfo.statusColor,
        statusLabel: entry.statusInfo.statusLabel,
        deliveryStatusColor: entry.statusInfo.deliveryStatusColor,
        deliveryStatusLabel: entry.statusInfo.deliveryStatusLabel,
        notes: entry.statusInfo.notes,
      ),
      metadata: entry.metadata,
      formData: entry.formData,
    );

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
        debugPrint('Online creation failed, queued: $e');
        if (attachmentPath != null) {
          debugPrint(
            'WARNING: Attachment will not be synced by standard sync service!',
          );
        }
      }
    }

    // 4. Queue for sync if offline or failed
    // Ensure toJson() is compatible with what SyncService expects
    final jsonData = entryWithUuid.toJson();
    if (jsonData.containsKey('form_data') && jsonData['form_data'] is Map) {
      final fd = jsonData['form_data'] as Map<String, dynamic>;
      jsonData.remove('form_data');
      jsonData.addAll(fd);
    }

    await _syncService.enqueue(
      SyncOperation(
        uuid: uuid,
        entityType: 'registry_entry',
        operationType: SyncOperationType.create,
        data: {
          ...jsonData,
          ...?attachmentPath != null
              ? {'_local_attachment_path': attachmentPath}
              : null,
        },
      ),
    );

    return entryWithUuid;
  }
}
