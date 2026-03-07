import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../providers/admin_record_books_provider.dart';
import '../../providers/admin_record_book_actions_provider.dart';
import '../../widgets/premium_record_book_card.dart';
import '../../widgets/record_book_correction_dialog.dart';
import '../../widgets/advanced_record_books_filter_sheet.dart';
import '../record_book_entries_screen.dart';
import 'package:qlm_guardian_app_v5/features/records/data/models/record_book.dart';

class AdminPhysicalBooksScreen extends ConsumerStatefulWidget {
  final int contractTypeId;
  final String contractTypeName;

  const AdminPhysicalBooksScreen({
    super.key,
    required this.contractTypeId,
    required this.contractTypeName,
  });

  @override
  ConsumerState<AdminPhysicalBooksScreen> createState() =>
      _AdminPhysicalBooksScreenState();
}

class _AdminPhysicalBooksScreenState
    extends ConsumerState<AdminPhysicalBooksScreen> {
  // Sort direction: true = newest first (descending), false = oldest first (ascending)
  bool _sortDescending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch books specifically for this contract type
      final notifier = ref.read(adminRecordBooksProvider.notifier);
      notifier.setContractTypeId(widget.contractTypeId);
      // Notifier's setContractTypeId auto fetches if it changes.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.contractTypeName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF006400),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _sortDescending ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            tooltip: 'ترتيب متنازل/تصاعدي',
            onPressed: () {
              setState(() {
                _sortDescending = !_sortDescending;
              });
              ref
                  .read(adminRecordBooksProvider.notifier)
                  .fetchBooks(refresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filters + Search
          _buildSearchBarAndFilterIcon(),
          // Group By & Sort Bar
          _buildActiveFiltersRow(),
          Expanded(child: _buildRecordBooksList()),
        ],
      ),
    );
  }

  Widget _buildSearchBarAndFilterIcon() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث باسم السجل، اسم الأمين، أو رقم السجل...',
                hintStyle: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                ref.read(adminRecordBooksProvider.notifier).setSearchQuery(val);
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: AppColors.primary),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const AdvancedRecordBooksFilterSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    final state = ref.watch(adminRecordBooksProvider);
    final notifier = ref.read(adminRecordBooksProvider.notifier);
    final activeFilters = <Widget>[];

    if (state.categoryFilter != null && state.categoryFilter != 'all') {
      String label = 'سجلات الأمناء';
      if (state.categoryFilter == 'documentation_recording') {
        label = 'تحرير التوثيق';
      }
      if (state.categoryFilter == 'documentation_final') {
        label = 'التوثيق النهائي';
      }
      activeFilters.add(
        _buildActiveFilterChip(label, () => notifier.setCategoryFilter(null)),
      );
    }

    if (state.statusFilter != null) {
      final statuses = {
        'active': 'نشط',
        'closed': 'مغلق',
        'completed': 'مكتمل',
        'pending': 'معلق',
      };
      activeFilters.add(
        _buildActiveFilterChip(
          statuses[state.statusFilter] ?? state.statusFilter!,
          () => notifier.setStatusFilter(null),
        ),
      );
    }

    if (state.guardianFilter != null) {
      activeFilters.add(
        _buildActiveFilterChip(
          'أمين محدد',
          () => notifier.setGuardianFilter(null),
        ),
      );
    }

    if (state.periodType != null) {
      String label = '';
      if (state.periodType == 'yearly') {
        label = 'سنة ${state.periodYear}';
      } else if (state.periodType == 'half_yearly') {
        label =
            'نصف ${state.periodValue == '1' ? 'أول' : 'ثاني'} ${state.periodYear}';
      } else if (state.periodType == 'quarterly') {
        label = 'ربع ${state.periodValue} ${state.periodYear}';
      } else if (state.periodType == 'custom') {
        label = '${state.dateFrom} - ${state.dateTo}';
      }
      activeFilters.add(
        _buildActiveFilterChip(
          label,
          () => notifier.setPeriodFilter(periodType: null),
        ),
      );
    }

    if (state.sortField != null) {
      final sorts = {
        'book_number': 'رقم السجل',
        'created_at': 'تاريخ الإنشاء',
        'usage': 'نسبة الاستخدام',
        'entries_count': 'عدد القيود',
      };
      activeFilters.add(
        _buildActiveFilterChip(
          'ترتيب: ${sorts[state.sortField] ?? state.sortField}',
          () => notifier.setSortField(null),
        ),
      );
    }

    if (state.groupBy != null) {
      final groups = {
        'type': 'نوع العقد',
        'guardian': 'الأمين',
        'year': 'السنة الهجرية',
        'writer_type': 'نوع الكاتب',
      };
      activeFilters.add(
        _buildActiveFilterChip(
          'تجميع: ${groups[state.groupBy] ?? state.groupBy}',
          () => notifier.setGroupBy(null),
        ),
      );
    }

    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8, right: 16, left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text(
              'فلاتر نشطة:',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            ...activeFilters.expand((chip) => [chip, const SizedBox(width: 8)]),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.primary),
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
              'خطأ في تحميل الدفاتر',
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
            const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'لا توجد دفاتر لعرضها',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      );
    }

    // Sort the list based on local _sortDescending var
    final books = [...state.books];
    books.sort((a, b) {
      final numA = a.hijriYear;
      final numB = b.hijriYear;
      return _sortDescending ? numB.compareTo(numA) : numA.compareTo(numB);
    });

    return RefreshIndicator(
      onRefresh: () => notifier.fetchBooks(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80, left: 16, right: 16),
        itemCount: books.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == books.length) {
            notifier.fetchBooks(); // Load more
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final book = books[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PremiumRecordBookCard(
              book: book,
              onOpen: () => _handleRenewRecord(context, book.id),
              onClose: () => _handleCloseRecord(context, book.id),
              onProcedures: () => _handleCorrectRecord(context, book),
              onShowEntries: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordBookEntriesScreen(book: book),
                  ),
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordBookEntriesScreen(book: book),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleCloseRecord(BuildContext context, int bookId) async {
    final actsNotifier = ref.read(recordBookActionProvider.notifier);
    final success = await actsNotifier.closeRecordBook(bookId);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إغلاق السجل بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      ref.read(adminRecordBooksProvider.notifier).fetchBooks(refresh: true);
    }
  }

  Future<void> _handleRenewRecord(BuildContext context, int bookId) async {
    final actsNotifier = ref.read(recordBookActionProvider.notifier);
    final success = await actsNotifier.issueRecordBook(bookId, {});
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم صرف السجل بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleCorrectRecord(
    BuildContext context,
    RecordBook book,
  ) async {
    showDialog(
      context: context,
      builder: (ctx) => RecordBookCorrectionDialog(book: book),
    ).then((val) {
      if (val == true) {
        ref.read(adminRecordBooksProvider.notifier).fetchBooks(refresh: true);
      }
    });
  }
}
