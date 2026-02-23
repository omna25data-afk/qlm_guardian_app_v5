import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/admin_record_books_provider.dart';
import '../providers/admin_dashboard_provider.dart';

class AdvancedRecordBooksFilterSheet extends ConsumerStatefulWidget {
  const AdvancedRecordBooksFilterSheet({super.key});

  @override
  ConsumerState<AdvancedRecordBooksFilterSheet> createState() =>
      _AdvancedRecordBooksFilterSheetState();
}

class _AdvancedRecordBooksFilterSheetState
    extends ConsumerState<AdvancedRecordBooksFilterSheet> {
  // Temporary state holders before apply
  String? tempCategory;
  String? tempStatus;
  String? tempType;
  String? tempGuardian;
  String? tempPeriodType;
  String? tempPeriodValue;
  int? tempPeriodYear;
  String? tempDateFrom;
  String? tempDateTo;
  String? tempSortField;
  bool tempSortAscending = false;
  String? tempGroupBy;

  @override
  void initState() {
    super.initState();
    // Initialize temporary state from current provider state
    final state = ref.read(adminRecordBooksProvider);
    tempCategory = state.categoryFilter;
    tempStatus = state.statusFilter;
    tempType = state.typeFilter;
    tempGuardian = state.guardianFilter;
    tempPeriodType = state.periodType;
    tempPeriodValue = state.periodValue;
    tempPeriodYear = state.periodYear;
    tempDateFrom = state.dateFrom;
    tempDateTo = state.dateTo;
    tempSortField = state.sortField;
    tempSortAscending = state.sortAscending;
    tempGroupBy = state.groupBy;
  }

  void _applyFilters() {
    final notifier = ref.read(adminRecordBooksProvider.notifier);
    // Apply categories, status, etc
    notifier.setCategoryFilter(tempCategory == 'all' ? null : tempCategory);
    notifier.setStatusFilter(tempStatus);
    notifier.setTypeFilter(tempType == 'all' ? null : tempType);

    final isGuardianCategory =
        tempCategory == 'guardian_recording' || tempCategory == null;
    if (isGuardianCategory) {
      notifier.setGuardianFilter(tempGuardian);
    } else {
      notifier.setGuardianFilter(null);
    }

    notifier.setPeriodFilter(
      periodType: tempPeriodType,
      periodValue: tempPeriodValue,
      periodYear: tempPeriodYear,
      dateFrom: tempDateFrom,
      dateTo: tempDateTo,
    );

    notifier.setSortField(tempSortField, ascending: tempSortAscending);
    notifier.setGroupBy(tempGroupBy == 'none' ? null : tempGroupBy);

    Navigator.pop(context);
  }

  void _clearAll() {
    ref.read(adminRecordBooksProvider.notifier).clearAllFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait<dynamic>([
        ref.read(adminRepositoryProvider).getAdminRecordBookTypes(),
        ref.read(adminRepositoryProvider).getActiveGuardians(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final types = snapshot.data?[0] as List<Map<String, dynamic>>? ?? [];
        final guardians = snapshot.data?[1] as List<dynamic>? ?? [];
        final isGuardianCategory =
            tempCategory == 'guardian_recording' || tempCategory == null;

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle indicator
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'تصفية مخصصة',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  // Scrollable content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildSectionTitle('الفئة (Category)'),
                        _buildCategoryFilter(),
                        const SizedBox(height: 24),

                        _buildSectionTitle('الحالة (Status)'),
                        _buildStatusFilter(),
                        const SizedBox(height: 24),

                        _buildSectionTitle('فرز وتجميع (Sort & Group)'),
                        _buildSortAndGroup(),
                        const SizedBox(height: 24),

                        _buildSectionTitle('الفترة الزمنية (Period)'),
                        _buildPeriodFilter(),
                        const SizedBox(height: 24),

                        _buildSectionTitle('نوع السجل (Book Type)'),
                        _buildTypeFilter(types),
                        const SizedBox(height: 24),

                        if (isGuardianCategory) ...[
                          _buildSectionTitle('الأمين (Guardian)'),
                          _buildGuardianFilter(guardians),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                  // Bottom Actions
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          offset: const Offset(0, -4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _applyFilters,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'تطبيق التغييرات',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _clearAll,
                          child: const Text(
                            'مسح جميع الفلاتر',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final options = {
      'all': 'الكل',
      'guardian_recording': 'سجلات الأمناء',
      'documentation_recording': 'تحرير التوثيق',
      'documentation_final': 'التوثيق النهائي',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.entries.map((e) {
        final isSelected = (tempCategory ?? 'all') == e.key;
        return ChoiceChip(
          label: Text(e.value, style: const TextStyle(fontFamily: 'Tajawal')),
          selected: isSelected,
          selectedColor: AppColors.primary.withValues(alpha: 0.1),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (val) {
            if (val) {
              setState(() => tempCategory = e.key == 'all' ? null : e.key);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildStatusFilter() {
    final options = {
      'all': 'الكل',
      'active': 'نشط',
      'closed': 'مغلق',
      'completed': 'مكتمل',
      'pending': 'معلق',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.entries.map((e) {
        final isSelected = (tempStatus ?? 'all') == e.key;
        return ChoiceChip(
          label: Text(e.value, style: const TextStyle(fontFamily: 'Tajawal')),
          selected: isSelected,
          selectedColor: Colors.blue.withValues(alpha: 0.1),
          labelStyle: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[700],
          ),
          onSelected: (val) {
            if (val) setState(() => tempStatus = e.key == 'all' ? null : e.key);
          },
        );
      }).toList(),
    );
  }

  Widget _buildTypeFilter(List<Map<String, dynamic>> types) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: tempType ?? 'all',
          isExpanded: true,
          items: [
            const DropdownMenuItem(
              value: 'all',
              child: Text('الكل', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            ...types.map(
              (t) => DropdownMenuItem(
                value: t['name']?.toString(),
                child: Text(
                  t['name']?.toString() ?? '',
                  style: const TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() => tempType = val == 'all' ? null : val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildGuardianFilter(List<dynamic> guardians) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: tempGuardian ?? 'all',
          isExpanded: true,
          items: [
            const DropdownMenuItem(
              value: 'all',
              child: Text('الكل', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            ...guardians.map(
              (g) => DropdownMenuItem(
                value: g.id.toString(),
                child: Text(
                  g.name,
                  style: const TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() => tempGuardian = val == 'all' ? null : val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSortAndGroup() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.sort, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            const Text(
              'ترتيب حسب:',
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: tempSortField ?? 'none',
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'none',
                      child: Text(
                        'تصنيف افتراضي',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'book_number',
                      child: Text(
                        'رقم السجل',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'created_at',
                      child: Text(
                        'تاريخ الإنشاء',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'usage',
                      child: Text(
                        'نسبة الاستخدام',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'entries_count',
                      child: Text(
                        'عدد القيود',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(
                    () => tempSortField = val == 'none' ? null : val,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                tempSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () =>
                  setState(() => tempSortAscending = !tempSortAscending),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            const Icon(
              Icons.view_agenda_outlined,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            const Text(
              'تجميع بواسطة:',
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: tempGroupBy ?? 'none',
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(
                      value: 'none',
                      child: Text(
                        'بدون تجميع',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: 'type',
                      child: Text(
                        'نوع العقد',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    if (tempCategory == 'guardian_recording' ||
                        tempCategory == null)
                      const DropdownMenuItem(
                        value: 'guardian',
                        child: Text(
                          'الأمين',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                        ),
                      ),
                    const DropdownMenuItem(
                      value: 'year',
                      child: Text(
                        'السنة الهجرية',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                    ),
                    if (tempCategory == 'documentation_final')
                      const DropdownMenuItem(
                        value: 'writer_type',
                        child: Text(
                          'نوع الكاتب',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                        ),
                      ),
                  ],
                  onChanged: (val) =>
                      setState(() => tempGroupBy = val == 'none' ? null : val),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodFilter() {
    final periods = {
      'none': 'بدون',
      'yearly': 'سنوية',
      'half_yearly': 'نصف سنوية',
      'quarterly': 'ربع سنوية',
      'custom': 'مخصصة',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: periods.entries.map((e) {
            final isSelected = (tempPeriodType ?? 'none') == e.key;
            return ChoiceChip(
              label: Text(
                e.value,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              selected: isSelected,
              selectedColor: Colors.orange.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.orange[800] : Colors.grey[700],
              ),
              onSelected: (val) {
                if (val) {
                  setState(() {
                    tempPeriodType = e.key == 'none' ? null : e.key;
                    if (tempPeriodType != 'custom') {
                      tempDateFrom = null;
                      tempDateTo = null;
                      tempPeriodYear ??= DateTime.now()
                          .year; // Example default Hijri year logic might be needed
                    } else {
                      tempPeriodYear = null;
                      tempPeriodValue = null;
                    }
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (tempPeriodType != null && tempPeriodType != 'custom')
          Row(
            children: [
              const Text(
                'السنة:',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
              ),
              const SizedBox(width: 8),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: tempPeriodYear ?? 1446,
                    isDense: true,
                    items: List.generate(10, (i) {
                      final year = 1447 - i;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          '$year هـ',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                          ),
                        ),
                      );
                    }),
                    onChanged: (val) => setState(() => tempPeriodYear = val),
                  ),
                ),
              ),
              if (tempPeriodType == 'half_yearly' ||
                  tempPeriodType == 'quarterly') ...[
                const SizedBox(width: 12),
                const Text(
                  'الفترة:',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tempPeriodValue,
                      hint: const Text(
                        'اختر',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                      isDense: true,
                      items: tempPeriodType == 'half_yearly'
                          ? const [
                              DropdownMenuItem(
                                value: '1',
                                child: Text(
                                  'النصف الأول',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text(
                                  'النصف الثاني',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ]
                          : const [
                              DropdownMenuItem(
                                value: 'Q1',
                                child: Text(
                                  'الربع الأول',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Q2',
                                child: Text(
                                  'الربع الثاني',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Q3',
                                child: Text(
                                  'الربع الثالث',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Q4',
                                child: Text(
                                  'الربع الرابع',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                      onChanged: (val) => setState(() => tempPeriodValue = val),
                    ),
                  ),
                ),
              ],
            ],
          ),
        if (tempPeriodType == 'custom')
          OutlinedButton.icon(
            onPressed: _pickDateRange,
            icon: const Icon(Icons.date_range, size: 16),
            label: Text(
              tempDateFrom != null
                  ? '$tempDateFrom → ${tempDateTo ?? '...'}'
                  : 'اختر التاريخ من وإلى',
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        tempDateFrom =
            '${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}';
        tempDateTo =
            '${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}';
      });
    }
  }
}
