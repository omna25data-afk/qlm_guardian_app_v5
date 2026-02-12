import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/sync/sync_service.dart';

// Access the SyncService from GetIt
final syncServiceProvider = Provider<SyncService>(
  (ref) => getIt<SyncService>(),
);

// Pending operations provider
final pendingOperationsProvider = FutureProvider<List<SyncOperation>>((
  ref,
) async {
  final service = ref.watch(syncServiceProvider);
  return await service.getPendingOperations();
});

// Sync status enum
enum SyncStatus { idle, syncing, success, error }

// Sync state
class SyncState {
  final SyncStatus status;
  final String? message;
  final String? lastSyncedAt;

  const SyncState({
    this.status = SyncStatus.idle,
    this.message,
    this.lastSyncedAt,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? message,
    String? lastSyncedAt,
  }) {
    return SyncState(
      status: status ?? this.status,
      message: message ?? this.message,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

// Sync Controller
class SyncController extends StateNotifier<SyncState> {
  final SyncService _syncService;
  final Ref _ref;

  SyncController(this._syncService, this._ref) : super(const SyncState()) {
    _loadLastSync();
  }

  void _loadLastSync() {
    state = state.copyWith(lastSyncedAt: _syncService.lastSyncedAt);
  }

  Future<void> sync() async {
    state = state.copyWith(status: SyncStatus.syncing, message: null);

    try {
      // 1. Push
      final pushResult = await _syncService.push();
      if (!pushResult.success && !pushResult.isOffline) {
        throw Exception(pushResult.error ?? 'Push failed');
      }

      // 2. Pull
      final pullResult = await _syncService.pull();
      if (!pullResult.success && !pullResult.isOffline) {
        throw Exception(pullResult.error ?? 'Pull failed');
      }

      // 3. Update state
      if (pushResult.isOffline || pullResult.isOffline) {
        state = state.copyWith(
          status: SyncStatus.error,
          message: 'لا يوجد اتصال بالإنترنت',
        );
      } else {
        state = state.copyWith(
          status: SyncStatus.success,
          message: 'تمت المزامنة بنجاح',
          lastSyncedAt: _syncService.lastSyncedAt,
        );
      }

      // 4. Refresh pending operations
      _ref.invalidate(pendingOperationsProvider);
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        message: 'فشل المزامنة: $e',
      );
    } finally {
      // Reset to idle after delay if success
      if (state.status == SyncStatus.success) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) state = state.copyWith(status: SyncStatus.idle);
        });
      }
    }
  }

  Future<void> refreshQueue() async {
    _ref.invalidate(pendingOperationsProvider);
    _loadLastSync();
  }
}

final syncControllerProvider = StateNotifierProvider<SyncController, SyncState>(
  (ref) {
    final service = ref.watch(syncServiceProvider);
    return SyncController(service, ref);
  },
);
