import 'package:hive/hive.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/network_info.dart';

/// Sync operation types
enum SyncOperationType { create, update, delete }

/// Sync operation to be queued for offline changes
class SyncOperation {
  final String uuid;
  final String entityType;
  final SyncOperationType operationType;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;

  SyncOperation({
    required this.uuid,
    required this.entityType,
    required this.operationType,
    required this.data,
    DateTime? createdAt,
    this.retryCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'entity_type': entityType,
    'operation_type': operationType.name,
    'data': data,
    'created_at': createdAt.toIso8601String(),
    'retry_count': retryCount,
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    uuid: json['uuid'],
    entityType: json['entity_type'],
    operationType: SyncOperationType.values.byName(json['operation_type']),
    data: json['data'],
    createdAt: DateTime.parse(json['created_at']),
    retryCount: json['retry_count'] ?? 0,
  );
}

/// Sync Service - compatible with Laravel SyncController.php
/// Uses /v1/mobile/sync endpoints for pull/push
class SyncService {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;
  final Box<dynamic> syncBox;

  static const String _lastSyncKey = 'last_synced_at';
  static const String _pendingOpsKey = 'pending_operations';

  SyncService({
    required this.apiClient,
    required this.networkInfo,
    required this.syncBox,
  });

  /// Pull changes from server since last sync
  /// Matches SyncController::pull()
  Future<SyncPullResult> pull() async {
    if (!await networkInfo.isConnected) {
      return SyncPullResult.offline();
    }

    try {
      final lastSyncedAt = syncBox.get(_lastSyncKey) as String?;

      final response = await apiClient.get(
        ApiEndpoints.mobileSyncPull,
        queryParameters: lastSyncedAt != null
            ? {'last_synced_at': lastSyncedAt}
            : null,
      );

      final data = response.data;

      // Save new timestamp
      if (data['timestamp'] != null) {
        await syncBox.put(_lastSyncKey, data['timestamp']);
      }

      return SyncPullResult(
        success: true,
        registryEntries: List<Map<String, dynamic>>.from(
          data['registry_entries'] ?? [],
        ),
        recordBooks: List<Map<String, dynamic>>.from(
          data['record_books'] ?? [],
        ),
        timestamp: data['timestamp'],
      );
    } catch (e) {
      return SyncPullResult.error(e.toString());
    }
  }

  /// Push offline changes to server
  /// Matches SyncController::push()
  Future<SyncPushResult> push() async {
    if (!await networkInfo.isConnected) {
      return SyncPushResult.offline();
    }

    final pending = await getPendingOperations();
    if (pending.isEmpty) {
      return SyncPushResult.noPending();
    }

    // Filter only registry entries (what backend expects)
    final registryEntries = pending
        .where((op) => op.entityType == 'registry_entry')
        .map((op) => op.data)
        .toList();

    if (registryEntries.isEmpty) {
      return SyncPushResult.noPending();
    }

    try {
      final response = await apiClient.post(
        ApiEndpoints.mobileSyncPush,
        data: {
          'registry_entries': pending
              .map(
                (e) => e.data,
              ) // Assuming 'data' is the payload, as 'payload' doesn't exist in SyncOperation
              .toList(),
        },
      );
      final syncedCount = response.data['synced_count'] as int? ?? 0;

      // Clear synced operations
      if (syncedCount > 0) {
        await _clearSyncedOperations(syncedCount);
      }

      return SyncPushResult(success: true, syncedCount: syncedCount);
    } catch (e) {
      return SyncPushResult.error(e.toString());
    }
  }

  /// Full sync: push then pull
  Future<void> fullSync() async {
    await push();
    await pull();
  }

  /// Queue an operation for sync
  Future<void> enqueue(SyncOperation operation) async {
    final pending = await getPendingOperations();
    pending.add(operation);
    await syncBox.put(_pendingOpsKey, pending.map((e) => e.toJson()).toList());
  }

  /// Get all pending operations
  Future<List<SyncOperation>> getPendingOperations() async {
    final data = syncBox.get(_pendingOpsKey) as List<dynamic>?;
    if (data == null) return [];
    return data
        .map((e) => SyncOperation.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Get pending count
  Future<int> getPendingCount() async {
    final pending = await getPendingOperations();
    return pending.length;
  }

  /// Clear synced operations
  Future<void> _clearSyncedOperations(int count) async {
    final pending = await getPendingOperations();
    if (pending.length <= count) {
      await syncBox.delete(_pendingOpsKey);
    } else {
      final remaining = pending.sublist(count);
      await syncBox.put(
        _pendingOpsKey,
        remaining.map((e) => e.toJson()).toList(),
      );
    }
  }

  /// Get last sync timestamp
  String? get lastSyncedAt => syncBox.get(_lastSyncKey) as String?;
}

/// Pull result
class SyncPullResult {
  final bool success;
  final bool isOffline;
  final String? error;
  final List<Map<String, dynamic>> registryEntries;
  final List<Map<String, dynamic>> recordBooks;
  final String? timestamp;

  SyncPullResult({
    required this.success,
    this.isOffline = false,
    this.error,
    this.registryEntries = const [],
    this.recordBooks = const [],
    this.timestamp,
  });

  factory SyncPullResult.offline() =>
      SyncPullResult(success: false, isOffline: true);
  factory SyncPullResult.error(String error) =>
      SyncPullResult(success: false, error: error);
}

/// Push result
class SyncPushResult {
  final bool success;
  final bool isOffline;
  final String? error;
  final int syncedCount;

  SyncPushResult({
    required this.success,
    this.isOffline = false,
    this.error,
    this.syncedCount = 0,
  });

  factory SyncPushResult.offline() =>
      SyncPushResult(success: false, isOffline: true);
  factory SyncPushResult.noPending() =>
      SyncPushResult(success: true, syncedCount: 0);
  factory SyncPushResult.error(String error) =>
      SyncPushResult(success: false, error: error);
}
