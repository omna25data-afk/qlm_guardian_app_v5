import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/records/data/models/record_book.dart';
import '../../../features/admin/presentation/widgets/admin_entries_list_tab.dart';
import '../../../features/admin/presentation/screens/admin_add_entry_screen.dart';

import '../../../features/admin/presentation/providers/admin_record_books_provider.dart';
import '../../../features/admin/presentation/providers/admin_record_book_actions_provider.dart';
import '../../../../features/admin/presentation/providers/admin_pending_entries_provider.dart';
import '../../../../features/admin/presentation/screens/document_entry_screen.dart';

/// السجلات والقيود — عرض شامل لكل السجلات مع فلترة (Admin)
class RecordsTab extends ConsumerStatefulWidget {
  const RecordsTab({super.key});

  @override
  ConsumerState<RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends ConsumerState<RecordsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initial Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminRecordBooksProvider.notifier).fetchBooks(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminAddEntryScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'إضافة قيد',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Sub-tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textHint,
              indicatorColor: AppColors.primary,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
              tabs: const [
                Tab(text: 'السجلات', icon: Icon(Icons.menu_book, size: 18)),
                Tab(text: 'القيود', icon: Icon(Icons.list_alt, size: 18)),
                Tab(
                  text: 'بانتظار التوثيق',
                  icon: Icon(Icons.pending_actions, size: 18),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecordBooksList(),
                const AdminEntriesListTab(),
                _buildPendingEntriesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordBooksList() {
    final state = ref.watch(adminRecordBooksProvider);
    final notifier = ref.read(adminRecordBooksProvider.notifier);

    if (state.isLoading && state.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل السجلات',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => notifier.fetchBooks(refresh: true),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: AppColors.textHint.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد سجلات',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!state.isLoading &&
            state.hasMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          notifier.fetchBooks();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async => notifier.fetchBooks(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.books.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.books.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _buildRecordBookCard(state.books[index]);
          },
        ),
      ),
    );
  }

  Widget _buildRecordBookCard(RecordBook book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title.isNotEmpty
                            ? book.title
                            : book.contractType.isNotEmpty
                            ? book.contractType
                            : 'سجل #${book.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      if (book.contractType.isNotEmpty)
                        Text(
                          book.contractType,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                    ],
                  ),
                ),
                _buildStatusBadge(
                  book.statusLabel.isNotEmpty ? book.statusLabel : 'غير محدد',
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.tag, 'رقم السجل', '${book.number}'),
                _buildInfoItem(
                  Icons.calendar_today,
                  'السنة',
                  '${book.hijriYear}',
                ),
                _buildInfoItem(Icons.layers, 'القيود', '${book.entriesCount}'),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                if (book.isActive) ...[
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.lock,
                      label: 'إغلاق',
                      color: AppColors.error,
                      onTap: () => _showCloseConfirmation(book),
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else ...[
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.lock_open,
                      label: 'فتح',
                      color: AppColors.success,
                      onTap: () => _showOpenConfirmation(book),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.history,
                    label: 'الإجراءات',
                    color: AppColors.primary,
                    onTap: () => _showProcedures(book),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'نشط':
      case 'active':
        color = AppColors.success;
        break;
      case 'مغلق':
      case 'closed':
        color = AppColors.error;
        break;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.textHint),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textHint,
            fontSize: 10,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOpenConfirmation(RecordBook book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'تأكيد فتح السجل',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل تريد فتح السجل "${book.title.isNotEmpty ? book.title : 'سجل #${book.id}'}"؟',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(recordBookActionProvider.notifier)
                  .openRecordBook(book.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم فتح السجل بنجاح')),
                );
                ref
                    .read(adminRecordBooksProvider.notifier)
                    .fetchBooks(refresh: true);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('فتح', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _showCloseConfirmation(RecordBook book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'تأكيد إغلاق السجل',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل تريد إغلاق السجل "${book.title.isNotEmpty ? book.title : 'سجل #${book.id}'}"؟',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(recordBookActionProvider.notifier)
                  .closeRecordBook(book.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إغلاق السجل بنجاح')),
                );
                ref
                    .read(adminRecordBooksProvider.notifier)
                    .fetchBooks(refresh: true);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _showProcedures(RecordBook book) {
    ref.read(recordBookActionProvider.notifier).fetchProcedures(book.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(recordBookActionProvider);
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'إجراءات السجل',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const Divider(),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.error != null)
                      Center(
                        child: Text(
                          'خطأ: ${state.error}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      )
                    else if (state.procedures.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'لا توجد إجراءات',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: state.procedures.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final proc = state.procedures[index];
                            return ListTile(
                              leading: Icon(
                                _getProcedureIcon(
                                  proc['procedure_type']?.toString() ?? '',
                                ),
                                color: AppColors.primary,
                              ),
                              title: Text(
                                proc['procedure_type_label']?.toString() ??
                                    proc['procedure_type']?.toString() ??
                                    'إجراء',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                proc['created_at']?.toString() ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                proc['user_name']?.toString() ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getProcedureIcon(String type) {
    switch (type.toLowerCase()) {
      case 'issuance':
      case 'إصدار':
        return Icons.add_circle_outline;
      case 'opening':
      case 'فتح':
        return Icons.lock_open;
      case 'closing':
      case 'إغلاق':
        return Icons.lock;
      default:
        return Icons.description;
    }
  }

  Widget _buildPendingEntriesTab() {
    final state = ref.watch(adminPendingEntriesProvider);

    // Initial fetch
    if (state.entries.isEmpty && !state.isLoading && state.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(adminPendingEntriesProvider.notifier)
            .fetchEntries(refresh: true);
      });
    }

    if (state.isLoading && state.entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: const TextStyle(fontFamily: 'Tajawal'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(adminPendingEntriesProvider.notifier)
                  .fetchEntries(refresh: true),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      );
    }

    if (state.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green[300],
            ),
            const SizedBox(height: 12),
            const Text(
              'لا توجد قيود بانتظار التوثيق',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(adminPendingEntriesProvider.notifier)
          .fetchEntries(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.entries.length,
        itemBuilder: (context, index) {
          final entry = state.entries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pending_actions,
                  color: AppColors.warning,
                  size: 22,
                ),
              ),
              title: Text(
                (entry.firstPartyName ?? '').isNotEmpty
                    ? entry.firstPartyName!
                    : 'قيد #${entry.serialNumber ?? ''}',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '${entry.contractType?.name ?? ''} • ${entry.guardianHijriDate ?? ''}',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DocumentEntryScreen(entry: entry),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
