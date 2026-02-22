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
          _buildFiltersSection(),
          // Group By & Sort Bar
          _buildGroupBySortBar(),
          Expanded(child: _buildRecordBooksList()),
        ],
      ),
    );
  }

  /// القسم الأعلى: الفئة + البحث + الحالة + الفترة
  Widget _buildFiltersSection() {
    final state = ref.watch(adminRecordBooksProvider);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. Category SegmentedButton
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.white,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: AppColors.primary,
                  textStyle: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                segments: const [
                  ButtonSegment<String>(value: 'all', label: Text('الكل')),
                  ButtonSegment<String>(
                    value: 'guardian_recording',
                    label: Text('سجلات الأمناء'),
                  ),
                  ButtonSegment<String>(
                    value: 'documentation_recording',
                    label: Text('تحرير التوثيق'),
                  ),
                  ButtonSegment<String>(
                    value: 'documentation_final',
                    label: Text('التوثيق النهائي'),
                  ),
                ],
                selected: {state.categoryFilter ?? 'all'},
                onSelectionChanged: (Set<String> newSelection) {
                  if (newSelection.isEmpty) return;
                  final val = newSelection.first;
                  ref
                      .read(adminRecordBooksProvider.notifier)
                      .setCategoryFilter(val == 'all' ? null : val);
                },
                showSelectedIcon: false,
                emptySelectionAllowed: false,
              ),
            ),
          ),

          // 2. Status Chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('الكل', null, state.statusFilter),
                  const SizedBox(width: 8),
                  _buildStatusChip('نشط', 'active', state.statusFilter),
                  const SizedBox(width: 8),
                  _buildStatusChip('مغلق', 'closed', state.statusFilter),
                  const SizedBox(width: 8),
                  _buildStatusChip('مكتمل', 'completed', state.statusFilter),
                  const SizedBox(width: 8),
                  _buildStatusChip('معلق', 'pending', state.statusFilter),
                ],
              ),
            ),
          ),

          // 3. Search Bar + Advanced Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
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
                      ref
                          .read(adminRecordBooksProvider.notifier)
                          .setSearchQuery(val);
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
                    onPressed: _showAdvancedFilters,
                  ),
                ),
              ],
            ),
          ),

          // 4. Period Filter
          _buildPeriodFilter(),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// شريحة حالة السجل
  Widget _buildStatusChip(String label, String? value, String? currentFilter) {
    final isActive =
        (value == null && currentFilter == null) ||
        (value != null && currentFilter == value);
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
          color: isActive ? Colors.white : Colors.grey.shade700,
        ),
      ),
      selected: isActive,
      onSelected: (_) {
        ref.read(adminRecordBooksProvider.notifier).setStatusFilter(value);
      },
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? AppColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }

  /// فلتر الفترة الزمنية
  Widget _buildPeriodFilter() {
    final state = ref.watch(adminRecordBooksProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Period Type
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPeriodChip('بدون', null, state.periodType),
                  const SizedBox(width: 6),
                  _buildPeriodChip('سنوية', 'yearly', state.periodType),
                  const SizedBox(width: 6),
                  _buildPeriodChip(
                    'نصف سنوية',
                    'half_yearly',
                    state.periodType,
                  ),
                  const SizedBox(width: 6),
                  _buildPeriodChip('ربع سنوية', 'quarterly', state.periodType),
                  const SizedBox(width: 6),
                  _buildPeriodChip('مخصصة', 'custom', state.periodType),
                ],
              ),
            ),
          ),

          // Year selector (shown for non-custom periods)
          if (state.periodType != null && state.periodType != 'custom') ...[
            const SizedBox(width: 8),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: state.periodYear ?? DateTime.now().year,
                  isDense: true,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  items: List.generate(10, (i) {
                    final year = 1447 - i; // Hijri years
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year هـ'),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(adminRecordBooksProvider.notifier)
                          .setPeriodFilter(
                            periodType: state.periodType,
                            periodYear: val,
                          );
                    }
                  },
                ),
              ),
            ),
          ],

          // Custom date range button
          if (state.periodType == 'custom') ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _showDateRangePicker(),
              icon: const Icon(Icons.date_range, size: 16),
              label: Text(
                state.dateFrom != null
                    ? '${state.dateFrom} → ${state.dateTo ?? '...'}'
                    : 'اختر الفترة',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, String? value, String? currentPeriod) {
    final isActive =
        (value == null && currentPeriod == null) ||
        (value != null && currentPeriod == value);
    return GestureDetector(
      onTap: () {
        ref
            .read(adminRecordBooksProvider.notifier)
            .setPeriodFilter(periodType: value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      ref
          .read(adminRecordBooksProvider.notifier)
          .setPeriodFilter(
            periodType: 'custom',
            dateFrom:
                '${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}',
            dateTo:
                '${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}',
          );
    }
  }

  /// شريط التجميع والفرز
  Widget _buildGroupBySortBar() {
    final state = ref.watch(adminRecordBooksProvider);
    final groupBy = state.groupBy;
    final categoryFilter = state.categoryFilter;

    // Dynamic group options based on category
    final groupOptions = <MapEntry<String, String>>[
      const MapEntry('none', 'بدون تجميع'),
      const MapEntry('type', 'نوع العقد'),
      if (categoryFilter == 'guardian_recording' || categoryFilter == null)
        const MapEntry('guardian', 'الأمين'),
      const MapEntry('year', 'السنة الهجرية'),
      if (categoryFilter == 'documentation_final')
        const MapEntry('writer_type', 'نوع الكاتب'),
    ];

    // Sort options
    String sortLabel;
    switch (state.sortField) {
      case 'book_number':
        sortLabel = 'رقم السجل';
        break;
      case 'created_at':
        sortLabel = 'تاريخ الإنشاء';
        break;
      case 'usage':
        sortLabel = 'نسبة الاستخدام';
        break;
      case 'entries_count':
        sortLabel = 'عدد القيود';
        break;
      default:
        sortLabel = 'الافتراضي';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          // Group By
          Expanded(
            child: PopupMenuButton<String>(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_agenda_outlined,
                    size: 18,
                    color: groupBy != null ? AppColors.primary : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    groupBy != null
                        ? groupOptions
                              .firstWhere(
                                (e) => e.key == groupBy,
                                orElse: () => const MapEntry('none', 'تجميع'),
                              )
                              .value
                        : 'تجميع',
                    style: TextStyle(
                      color: groupBy != null ? AppColors.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              onSelected: (val) {
                ref
                    .read(adminRecordBooksProvider.notifier)
                    .setGroupBy(val == 'none' ? null : val);
              },
              itemBuilder: (context) => groupOptions
                  .map(
                    (e) => PopupMenuItem(
                      value: e.key,
                      child: Text(
                        e.value,
                        style: const TextStyle(fontFamily: 'Tajawal'),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(height: 20, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 8),
          // Sort By
          Expanded(
            child: PopupMenuButton<String>(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort,
                    size: 18,
                    color: state.sortField != null
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sortLabel,
                    style: TextStyle(
                      color: state.sortField != null
                          ? AppColors.primary
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                    ),
                  ),
                  Icon(
                    state.sortAscending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 14,
                    color: state.sortField != null
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ],
              ),
              onSelected: (val) {
                if (val == 'toggle_direction') {
                  ref
                      .read(adminRecordBooksProvider.notifier)
                      .setSortField(
                        state.sortField,
                        ascending: !state.sortAscending,
                      );
                } else if (val == 'none') {
                  ref
                      .read(adminRecordBooksProvider.notifier)
                      .setSortField(null);
                } else {
                  ref.read(adminRecordBooksProvider.notifier).setSortField(val);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'none',
                  child: Text(
                    'الافتراضي',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'book_number',
                  child: Text(
                    'رقم السجل',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'created_at',
                  child: Text(
                    'تاريخ الإنشاء',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'usage',
                  child: Text(
                    'نسبة الاستخدام',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'entries_count',
                  child: Text(
                    'عدد القيود',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'toggle_direction',
                  child: Row(
                    children: [
                      Icon(
                        state.sortAscending
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.sortAscending ? 'تنازلي' : 'تصاعدي',
                        style: const TextStyle(fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              final currentState = ref.read(adminRecordBooksProvider);
              String selectedType = currentState.typeFilter ?? 'all';
              String selectedGuardian = currentState.guardianFilter ?? '';
              final isGuardianCategory =
                  currentState.categoryFilter == 'guardian_recording' ||
                  currentState.categoryFilter == null;

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

                        // Guardian Dropdown - Only shown for guardian_recording category
                        if (isGuardianCategory) ...[
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
                          const SizedBox(height: 16),
                        ],

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
                              if (isGuardianCategory) {
                                notifier.setGuardianFilter(selectedGuardian);
                              }
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
                              ref
                                  .read(adminRecordBooksProvider.notifier)
                                  .clearAllFilters();
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'مسح جميع الفلاتر',
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
