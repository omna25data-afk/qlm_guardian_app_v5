import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/records/data/models/record_book.dart';
import '../../../features/records/presentation/providers/records_provider.dart';
import '../../../features/records/presentation/screens/record_books_screen.dart';
import '../../../features/registry/presentation/screens/entries_list_screen.dart';

/// سجلاتي + قيودي — TabBar يبدل بينهما (كما في v4)
class MyRecordsTab extends ConsumerStatefulWidget {
  const MyRecordsTab({super.key});

  @override
  ConsumerState<MyRecordsTab> createState() => _MyRecordsTabState();
}

class _MyRecordsTabState extends ConsumerState<MyRecordsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Tab Bar
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'سجلاتي'),
              Tab(text: 'قيودي'),
            ],
            indicator: BoxDecoration(
              color: const Color(0xFF006400),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: GoogleFonts.tajawal(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.all(4),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // سجلاتي - record books
              _buildRecordBooksTab(),
              // قيودي - entries
              const EntriesListScreen(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordBooksTab() {
    final recordsState = ref.watch(recordBooksProvider);

    return recordsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل السجلات',
              style: GoogleFonts.tajawal(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  ref.read(recordBooksProvider.notifier).fetchRecordBooks(),
              child: Text('إعادة المحاولة', style: GoogleFonts.tajawal()),
            ),
          ],
        ),
      ),
      data: (books) {
        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text(
                  'لا توجد سجلات',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(recordBooksProvider.notifier).fetchRecordBooks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) => _buildRecordBookCard(books[index]),
          ),
        );
      },
    );
  }

  Widget _buildRecordBookCard(RecordBook book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF006400).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${book.bookNumber}',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006400),
            ),
          ),
        ),
        title: Text(
          'دفتر ${book.contractType}',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${book.entriesCount} قيد • ${book.hijriYear} هـ',
          style: GoogleFonts.tajawal(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textHint,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecordBookNotebooksScreen(
                contractTypeId: book.contractTypeId ?? book.id,
                contractTypeName: book.contractType,
              ),
            ),
          );
        },
      ),
    );
  }
}
