import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/sync_provider.dart';
import 'sync_screen.dart';

class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncControllerProvider);
    final pendingOps = ref.watch(pendingOperationsProvider);
    final pendingCount = pendingOps.asData?.value.length ?? 0;

    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SyncScreen()),
        );
      },
      icon: Stack(
        children: [
          _buildIcon(syncState.status),
          if (pendingCount > 0 && syncState.status != SyncStatus.syncing)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      tooltip: 'حالة المزامنة',
    );
  }

  Widget _buildIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case SyncStatus.error:
        return const Icon(Icons.sync_problem, color: Colors.redAccent);
      case SyncStatus.success:
        return const Icon(Icons.cloud_done, color: Colors.greenAccent);
      case SyncStatus.idle:
        return const Icon(Icons.sync, color: Colors.white70);
    }
  }
}
