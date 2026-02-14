import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/records/data/models/record_book.dart';
import '../../../features/admin/presentation/widgets/admin_entries_list_tab.dart';
import '../../../features/registry/presentation/screens/add_registry_entry_screen.dart';

import '../../../features/admin/presentation/providers/admin_record_books_provider.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildRecordBooksList(), const AdminEntriesListTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddRegistryEntryScreen()),
        ),
        backgroundColor: AppColors.primary,
        tooltip: 'إضافة قيد جديد',
        child: const Icon(Icons.add, color: Colors.white),
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
}
