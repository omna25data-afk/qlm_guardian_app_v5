import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../features/records/data/models/record_book.dart';
import '../../../../../features/admin/presentation/providers/admin_record_books_provider.dart';
import '../record_book_entries_screen.dart';
import '../../../../../features/admin/presentation/providers/admin_record_book_actions_provider.dart';
import '../../../../admin/presentation/widgets/premium_record_book_card.dart';
import '../../../../../features/admin/presentation/providers/admin_dashboard_provider.dart';
import '../../../../admin/presentation/widgets/record_book_correction_dialog.dart';

class RecordBooksTab extends ConsumerStatefulWidget {
  const RecordBooksTab({super.key});

  @override
  ConsumerState<RecordBooksTab> createState() => _RecordBooksTabState();
}
// ... (lines 14-173) ...

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
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'بحث في السجلات...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
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
                          ref
                              .read(adminRecordBooksProvider.notifier)
                              .setSearchQuery(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Advanced Filter Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: AppColors.primary),
                        onPressed: () {
                          // TODO: Show Advanced Filters Dialog (Type, Guardian)
                          _showAdvancedFilters();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Category Filters (Chips)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('سجلات الأمناء', 'guardian_recording'),
                      const SizedBox(width: 8),
                      _buildFilterChip('سجلات التوثيق', 'documentation_final'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Group By Bar (Optional)
          _buildGroupByBar(),
          Expanded(child: _buildRecordBooksList()),
        ],
      ),
    );
  }

  Widget _buildGroupByBar() {
    final groupBy = ref.watch(adminRecordBooksProvider).groupBy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<String>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sort,
                  color: groupBy != null ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  groupBy == 'type'
                      ? 'تجميع حسب النوع'
                      : groupBy == 'guardian'
                      ? 'تجميع حسب الأمين'
                      : 'بدون تجميع',
                  style: TextStyle(
                    color: groupBy != null ? AppColors.primary : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            onSelected: (val) {
              ref
                  .read(adminRecordBooksProvider.notifier)
                  .setGroupBy(val == 'none' ? null : val);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'none',
                child: Text(
                  'بدون تجميع',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              const PopupMenuItem(
                value: 'type',
                child: Text(
                  'نوع السجل',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              const PopupMenuItem(
                value: 'guardian',
                child: Text('الأمين', style: TextStyle(fontFamily: 'Tajawal')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final currentCategory = ref.watch(adminRecordBooksProvider).categoryFilter;

    // If value is 'all', it is selected if current is null or 'all'
    final isSelected = (value == 'all')
        ? (currentCategory == null || currentCategory == 'all')
        : (currentCategory == value);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontFamily: 'Tajawal',
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        ref.read(adminRecordBooksProvider.notifier).setCategoryFilter(value);
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey[300]!,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait<dynamic>([
              ref.read(adminRepositoryProvider).getAdminRecordBookTypes(),
              ref.read(adminRepositoryProvider).getActiveGuardians(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final types =
                  snapshot.data?[0] as List<Map<String, dynamic>>? ?? [];
              final guardians = snapshot.data?[1] as List<dynamic>? ?? [];

              // Get current filter values
              String selectedType =
                  ref.read(adminRecordBooksProvider).typeFilter ?? 'all';
              String selectedGuardian =
                  ref.read(adminRecordBooksProvider).guardianFilter ?? '';

              return StatefulBuilder(
                builder: (context, setModalState) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
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
                        const SizedBox(height: 24),
                        const Text(
                          'تصفية متقدمة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Type Dropdown
                        const Text(
                          'نوع السجل',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedType,
                              isExpanded: true,
                              items: [
                                const DropdownMenuItem(
                                  value: 'all',
                                  child: Text(
                                    'الكل',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                ...types.map((t) {
                                  return DropdownMenuItem(
                                    value: t['name']?.toString(),
                                    child: Text(
                                      t['name']?.toString() ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedType = val);
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Guardian Dropdown
                        const Text(
                          'الأمين',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedGuardian,
                              isExpanded: true,
                              items: [
                                const DropdownMenuItem(
                                  value: '',
                                  child: Text(
                                    'الكل',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                ...guardians.map(
                                  (g) => DropdownMenuItem(
                                    value: g.id.toString(),
                                    child: Text(
                                      g.name,
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedGuardian = val);
                                }
                              },
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              final notifier = ref.read(
                                adminRecordBooksProvider.notifier,
                              );
                              notifier.setTypeFilter(selectedType);
                              notifier.setGuardianFilter(selectedGuardian);
                              Navigator.pop(ctx);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'تطبيق الفلتر',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Clear Filters
                        Center(
                          child: TextButton(
                            onPressed: () {
                              final notifier = ref.read(
                                adminRecordBooksProvider.notifier,
                              );
                              notifier.setTypeFilter('all');
                              notifier.setGuardianFilter('');
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'مسح الفلاتر',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
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
          // + (state.isLoading ? 1 : 0) handled below or by length check
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
                  // Assuming legitimateGuardianId or writerName distinguishes groups
                  // Since we sort by legitimate_guardian_id, we can check writerName
                  showHeader = prevBook.writerName != book.writerName;
                }
              }

              if (showHeader) {
                String title = '';
                if (groupBy == 'type') {
                  title = book.contractType;
                } else if (groupBy == 'guardian') {
                  title = book.writerName;
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

  void _showEntries(BuildContext context, RecordBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecordBookEntriesScreen(book: book)),
    );
  }
}
