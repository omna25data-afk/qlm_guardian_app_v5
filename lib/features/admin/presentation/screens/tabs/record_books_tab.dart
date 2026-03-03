import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../features/records/data/models/record_book.dart';
import '../../../../../features/admin/presentation/providers/admin_record_books_provider.dart';
import '../record_book_entries_screen.dart';
import '../../../../../features/admin/presentation/providers/admin_record_book_actions_provider.dart';
import '../../../../admin/presentation/widgets/premium_record_book_card.dart';
import '../../../../admin/presentation/widgets/record_book_correction_dialog.dart';

import '../../../../admin/presentation/widgets/advanced_record_books_filter_sheet.dart';

class RecordBooksTab extends ConsumerStatefulWidget {
  const RecordBooksTab({super.key});

  @override
  ConsumerState<RecordBooksTab> createState() => _RecordBooksTabState();
}

class _RecordBooksTabState extends ConsumerState<RecordBooksTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminRecordBooksProvider.notifier).fetchBooks(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Category Filters + Search + Status + Period
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

    if (state.typeFilter != null) {
      activeFilters.add(
        _buildActiveFilterChip(
          state.typeFilter!,
          () => notifier.setTypeFilter(null),
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
        color: AppColors.primary,
        backgroundColor: Colors.white,
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

            final book = state.books[index];
            final groupBy = state.groupBy;

            // Check if we need a header
            Widget? header;
            if (groupBy != null) {
              bool showHeader = false;
              if (index == 0) {
                showHeader = true;
              } else {
                final prevBook = state.books[index - 1];
                if (groupBy == 'type') {
                  showHeader = prevBook.contractType != book.contractType;
                } else if (groupBy == 'guardian') {
                  showHeader = prevBook.writerName != book.writerName;
                } else if (groupBy == 'year') {
                  showHeader = prevBook.hijriYear != book.hijriYear;
                } else if (groupBy == 'writer_type') {
                  showHeader = prevBook.writerTypeLabel != book.writerTypeLabel;
                }
              }

              if (showHeader) {
                String title = '';
                if (groupBy == 'type') {
                  title = book.contractType;
                } else if (groupBy == 'guardian') {
                  title = book.writerName;
                } else if (groupBy == 'year') {
                  title = '${book.hijriYear} هـ';
                } else if (groupBy == 'writer_type') {
                  title = book.writerTypeLabel;
                }

                header = Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        right: BorderSide(color: AppColors.primary, width: 4),
                      ),
                    ),
                    child: Text(
                      title.isNotEmpty ? title : 'غير محدد',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
            }

            final card = PremiumRecordBookCard(
              book: book,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => RecordBookCorrectionDialog(book: book),
                );
              },
              onOpen: () => _showOpenConfirmation(book),
              onClose: () => _showCloseConfirmation(book),
              onProcedures: () => _showProcedures(book),
              onShowEntries: () => _showEntries(context, book),
            );

            if (header != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [header, card],
              );
            }
            return card;
          },
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
                                proc['type_label']?.toString() ??
                                    proc['type']?.toString() ??
                                    'إجراء',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${proc['procedure_date_hijri'] ?? ''} (${proc['procedure_date'] ?? ''})',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                proc['performer']?.toString() ?? '',
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
    if (type.isEmpty) return Icons.description;

    switch (type.toLowerCase()) {
      case 'issued':
      case 'issuance':
      case 'صرف':
      case 'إصدار':
        return Icons.add_circle_outline;
      case 'opened':
      case 'opening':
      case 'فتح':
        return Icons.lock_open;
      case 'closed':
      case 'closing':
      case 'إغلاق':
        return Icons.lock;
      case 'archived':
      case 'أرشفة':
        return Icons.archive;
      default:
        return Icons.description;
    }
  }

  void _showEntries(BuildContext context, RecordBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecordBookEntriesScreen(book: book)),
    );
  }
}
