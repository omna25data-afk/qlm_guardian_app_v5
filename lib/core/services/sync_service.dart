import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

/// Sync service - handles offline-first data submission
/// Uses the existing SyncQueue table in Drift to queue operations
/// and syncs them when connectivity is restored.
class SyncService {
  final AppDatabase _db;
  final ApiClient _apiClient;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;
  final _uuid = const Uuid();

  /// Callbacks
  final void Function(int pending)? onPendingCountChanged;
  final void Function(String message)? onSyncComplete;
  final void Function(String error)? onSyncError;

  SyncService({
    required AppDatabase db,
    required ApiClient apiClient,
    this.onPendingCountChanged,
    this.onSyncComplete,
    this.onSyncError,
  }) : _db = db,
       _apiClient = apiClient {
    _startListening();
  }

  /// Start listening for connectivity changes
  void _startListening() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        syncPendingEntries();
      }
    });
  }

  /// Save entry locally and queue for sync
  Future<String> saveEntryLocally(Map<String, dynamic> data) async {
    final entryUuid = _uuid.v4();
    final now = DateTime.now();

    // Save to local database
    await _db.insertEntry(
      RegistryEntriesCompanion(
        uuid: Value(entryUuid),
        contractTypeId: Value(data['contract_type_id'] as int?),
        guardianId: Value(data['guardian_id'] as int?),
        status: const Value('draft'),
        hijriDate: Value(data['document_hijri_date'] as String?),
        subject: Value(data['first_party_name'] as String? ?? ''),
        content: Value(json.encode(data)),
        totalAmount: Value((data['total_amount'] as num?)?.toDouble() ?? 0),
        isSynced: const Value(false),
        lastUpdated: Value(now),
      ),
    );

    // Add to sync queue
    await _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion(
            operation: const Value('INSERT'),
            targetTable: const Value('registry_entries'),
            recordId: Value(entryUuid),
            payload: Value(json.encode(data)),
            status: const Value('PENDING'),
          ),
        );

    // Notify about pending count
    _notifyPendingCount();

    return entryUuid;
  }

  /// Try to sync all pending entries
  Future<void> syncPendingEntries() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pendingItems =
          await (_db.select(_db.syncQueue)
                ..where((tbl) => tbl.status.equals('PENDING'))
                ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
              .get();

      if (pendingItems.isEmpty) {
        _isSyncing = false;
        return;
      }

      int synced = 0;
      int failed = 0;

      for (final item in pendingItems) {
        try {
          if (item.operation == 'INSERT' &&
              item.targetTable == 'registry_entries') {
            final payload = json.decode(item.payload ?? '{}');

            await _apiClient.post(
              ApiEndpoints.adminRegistryEntries,
              data: payload,
            );

            // Mark as synced in queue
            await (_db.update(_db.syncQueue)
                  ..where((tbl) => tbl.id.equals(item.id)))
                .write(const SyncQueueCompanion(status: Value('SYNCED')));

            // Mark entry as synced
            await (_db.update(
              _db.registryEntries,
            )..where((tbl) => tbl.uuid.equals(item.recordId))).write(
              const RegistryEntriesCompanion(
                isSynced: Value(true),
                status: Value('registered'),
              ),
            );

            synced++;
          }
        } catch (e) {
          // Increment attempts
          await (_db.update(
            _db.syncQueue,
          )..where((tbl) => tbl.id.equals(item.id))).write(
            SyncQueueCompanion(
              attempts: Value(item.attempts + 1),
              lastAttemptAt: Value(DateTime.now()),
            ),
          );
          failed++;
          debugPrint('Sync failed for ${item.recordId}: $e');
        }
      }

      if (synced > 0) {
        onSyncComplete?.call('تمت مزامنة $synced قيد بنجاح');
      }
      if (failed > 0) {
        onSyncError?.call('فشلت المزامنة لـ $failed قيد');
      }
    } finally {
      _isSyncing = false;
      _notifyPendingCount();
    }
  }

  /// Get count of pending sync items
  Future<int> getPendingCount() async {
    final items = await (_db.select(
      _db.syncQueue,
    )..where((tbl) => tbl.status.equals('PENDING'))).get();
    return items.length;
  }

  Future<void> _notifyPendingCount() async {
    final count = await getPendingCount();
    onPendingCountChanged?.call(count);
  }

  /// Clean up completed sync items older than 7 days
  Future<void> cleanupCompletedItems() async {
    final threshold = DateTime.now().subtract(const Duration(days: 7));
    await (_db.delete(_db.syncQueue)..where(
          (tbl) =>
              tbl.status.equals('SYNCED') &
              tbl.createdAt.isSmallerThanValue(threshold),
        ))
        .go();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
