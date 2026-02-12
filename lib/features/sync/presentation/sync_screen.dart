import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/sync/sync_service.dart';
import 'providers/sync_provider.dart';

class SyncScreen extends ConsumerWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingOpsAsync = ref.watch(pendingOperationsProvider);
    final syncState = ref.watch(syncControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المزامنة',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(pendingOperationsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status Card
            _buildStatusCard(context, syncState, pendingOpsAsync),
            const SizedBox(height: 24),

            // Section Title
            Text(
              'العمليات المعلقة',
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Pending Operations List
            pendingOpsAsync.when(
              data: (ops) {
                if (ops.isEmpty) {
                  return _buildEmptyState();
                }
                return Column(
                  children: ops.map((op) => _buildOperationCard(op)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'خطأ: $err',
                  style: GoogleFonts.tajawal(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: syncState.status == SyncStatus.syncing
            ? null
            : () => ref.read(syncControllerProvider.notifier).sync(),
        label: Text(
          syncState.status == SyncStatus.syncing
              ? 'جاري المزامنة...'
              : 'مزامنة الآن',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        icon: syncState.status == SyncStatus.syncing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.sync),
        backgroundColor: syncState.status == SyncStatus.syncing
            ? Colors.grey
            : AppColors.primary,
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    SyncState state,
    AsyncValue<List<SyncOperation>> pendingAsync,
  ) {
    final pendingCount = pendingAsync.asData?.value.length ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: state.status == SyncStatus.syncing
                        ? Colors.blue.withValues(alpha: 0.1)
                        : state.status == SyncStatus.error
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    state.status == SyncStatus.syncing
                        ? Icons.sync
                        : state.status == SyncStatus.error
                        ? Icons.error_outline
                        : Icons.cloud_done,
                    color: state.status == SyncStatus.syncing
                        ? Colors.blue
                        : state.status == SyncStatus.error
                        ? Colors.red
                        : Colors.green,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.status == SyncStatus.syncing
                            ? 'جاري المزامنة...'
                            : state.status == SyncStatus.error
                            ? 'فشل المزامنة'
                            : 'المزامنة مكتملة',
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (state.message != null)
                        Text(
                          state.message!,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: state.status == SyncStatus.error
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                        ),
                      if (state.lastSyncedAt != null)
                        Text(
                          'آخر مزامنة: ${intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(state.lastSyncedAt!))}',
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'المعلقة',
                  '$pendingCount',
                  Icons.pending_actions,
                  Colors.orange,
                ),
                _buildStatItem(
                  'حالة الاتصال',
                  'متصل',
                  Icons.wifi,
                  Colors.green,
                ), // Ideal to check connectivity here
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.green.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد عمليات معلقة',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationCard(SyncOperation op) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
          child: Icon(
            _getOpIcon(op.operationType),
            color: Colors.orange,
            size: 20,
          ),
        ),
        title: Text(
          _getOpTitle(op),
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(op.createdAt),
          style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey),
        ),
        trailing: op.retryCount > 0
            ? Chip(
                label: Text(
                  '${op.retryCount}',
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                labelPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )
            : null,
      ),
    );
  }

  IconData _getOpIcon(SyncOperationType type) {
    switch (type) {
      case SyncOperationType.create:
        return Icons.add;
      case SyncOperationType.update:
        return Icons.edit;
      case SyncOperationType.delete:
        return Icons.delete;
    }
  }

  String _getOpTitle(SyncOperation op) {
    final typeMap = {'registry_entry': 'قيد سجل', 'record_book': 'سجل'};
    final entity = typeMap[op.entityType] ?? op.entityType;

    switch (op.operationType) {
      case SyncOperationType.create:
        return 'إضافة $entity جديد';
      case SyncOperationType.update:
        return 'تحديث $entity';
      case SyncOperationType.delete:
        return 'حذف $entity';
    }
  }
}
