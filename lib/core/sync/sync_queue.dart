import 'package:hive/hive.dart';
import 'sync_service.dart';

/// Manages pending sync operations queue
/// Works with SyncService to track offline changes
class SyncQueue {
  final Box<dynamic> _syncBox;
  static const String _pendingOpsKey = 'pending_operations';

  SyncQueue({required Box<dynamic> syncBox}) : _syncBox = syncBox;

  /// Add operation to the queue
  Future<void> enqueue(SyncOperation operation) async {
    final pending = await getPending();
    pending.add(operation);
    await _save(pending);
  }

  /// Get all pending operations
  Future<List<SyncOperation>> getPending() async {
    final data = _syncBox.get(_pendingOpsKey) as List<dynamic>?;
    if (data == null) return [];
    return data
        .map((e) => SyncOperation.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Get pending count
  Future<int> get pendingCount async {
    final pending = await getPending();
    return pending.length;
  }

  /// Check if there are pending operations
  Future<bool> get hasPending async {
    return (await pendingCount) > 0;
  }

  /// Mark operations as synced (remove first N)
  Future<void> markSynced(int count) async {
    final pending = await getPending();
    if (pending.length <= count) {
      await _syncBox.delete(_pendingOpsKey);
    } else {
      final remaining = pending.sublist(count);
      await _save(remaining);
    }
  }

  /// Remove a specific operation by UUID
  Future<void> removeByUuid(String uuid) async {
    final pending = await getPending();
    pending.removeWhere((op) => op.uuid == uuid);
    await _save(pending);
  }

  /// Clear all pending operations
  Future<void> clearAll() async {
    await _syncBox.delete(_pendingOpsKey);
  }

  /// Increment retry count for failed operations
  Future<void> incrementRetry(String uuid) async {
    final pending = await getPending();
    final index = pending.indexWhere((op) => op.uuid == uuid);
    if (index != -1) {
      final op = pending[index];
      pending[index] = SyncOperation(
        uuid: op.uuid,
        entityType: op.entityType,
        operationType: op.operationType,
        data: op.data,
        createdAt: op.createdAt,
        retryCount: op.retryCount + 1,
      );
      await _save(pending);
    }
  }

  /// Get operations that have exceeded max retries
  Future<List<SyncOperation>> getFailedOperations({int maxRetries = 3}) async {
    final pending = await getPending();
    return pending.where((op) => op.retryCount >= maxRetries).toList();
  }

  Future<void> _save(List<SyncOperation> operations) async {
    await _syncBox.put(
      _pendingOpsKey,
      operations.map((e) => e.toJson()).toList(),
    );
  }
}
