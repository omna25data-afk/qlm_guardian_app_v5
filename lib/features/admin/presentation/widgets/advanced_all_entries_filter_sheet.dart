import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../screens/tabs/all_entries_tab.dart';
import '../providers/admin_dashboard_provider.dart';

class AdvancedAllEntriesFilterSheet extends ConsumerStatefulWidget {
  const AdvancedAllEntriesFilterSheet({super.key});

  @override
  ConsumerState<AdvancedAllEntriesFilterSheet> createState() =>
      _AdvancedAllEntriesFilterSheetState();
}

class _AdvancedAllEntriesFilterSheetState
    extends ConsumerState<AdvancedAllEntriesFilterSheet> {
  // --- Section 1: Dates ---
  String tempDateFilterType = 'transaction';
  String tempPeriodScope = 'all';
  int? tempHijriYear;
  String? tempPeriodValue;
  String? tempDateFrom; // Gregorian backups for custom
  String? tempDateTo;

  // --- Section 2: Record Properties ---
  String? tempRecordBookCategory;
  int? tempRecordBookTypeId;
  int? tempContractTypeId;
  String? tempStatus;

  // --- Section 3: Writer Details ---
  String? tempWriterType;
  int? tempFilteredWriterId;

  // --- State ---
  List<Map<String, dynamic>> _writersList = [];
  bool _isLoadingWriters = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(allEntriesProvider);
    tempDateFilterType = state.dateFilterType ?? 'transaction';
    tempRecordBookCategory = state.recordBookCategory;
    tempRecordBookTypeId = state.recordBookTypeId;
    tempContractTypeId = state.contractTypeId;
    tempStatus = state.status;
    tempWriterType = state.writerType;
    tempFilteredWriterId = state.filteredWriterId;
    tempDateFrom = state.dateFrom;
    tempDateTo = state.dateTo;

    // Attempt to reverse-engineer period scope from dates if needed
    if (state.hijriDateFrom != null && state.hijriDateTo != null) {
      if (state.hijriDateFrom!.endsWith('-01-01') &&
          state.hijriDateTo!.endsWith('-12-30')) {
        tempPeriodScope = 'annual';
        tempHijriYear = int.tryParse(state.hijriDateFrom!.substring(0, 4));
      } else {
        tempPeriodScope = 'custom'; // Custom hijri
      }
    } else if (state.dateFrom != null) {
      tempPeriodScope = 'custom';
    }

    if (tempWriterType != null) {
      _fetchWritersForType(tempWriterType!);
    }
  }

  Future<void> _fetchWritersForType(String type) async {
    setState(() {
      _isLoadingWriters = true;
      _writersList = [];
      // Keep ID if it matches the current state, otherwise clear it to prevent mismatch
      if (tempWriterType != ref.read(allEntriesProvider).writerType) {
        tempFilteredWriterId = null;
      }
    });

    try {
      final repo = ref.read(adminRepositoryProvider);
      if (type == 'guardian') {
        final guardians = await repo.getActiveGuardians();
        setState(() {
          _writersList = guardians
              .map((g) => {'id': g.id, 'name': g.name})
              .toList();
        });
      } else if (type == 'documentation') {
        final writers = await repo.getWriters();
        setState(() {
          _writersList = writers
              .map((w) => {'id': w['id'], 'name': w['name']})
              .toList();
        });
      } else if (type == 'external') {
        final others = await repo.getOtherWriters();
        setState(() {
          _writersList = others
              .map((w) => {'id': w['id'], 'name': w['name']})
              .toList();
        });
      }
    } catch (e) {
      // Ignore errors for now, dropdown will just be empty
    } finally {
      setState(() {
        _isLoadingWriters = false;
      });
    }
  }

  void _applyFilters() {
    String? finalHijriFrom;
    String? finalHijriTo;

    if (tempPeriodScope != 'all' &&
        tempPeriodScope != 'custom' &&
        tempHijriYear != null) {
      if (tempPeriodScope == 'annual') {
        finalHijriFrom = '$tempHijriYear-01-01';
        finalHijriTo = '$tempHijriYear-12-30';
      } else if (tempPeriodScope == 'semi_annual') {
        if (tempPeriodValue == 'h1') {
          finalHijriFrom = '$tempHijriYear-01-01';
          finalHijriTo = '$tempHijriYear-06-30';
        } else if (tempPeriodValue == 'h2') {
          finalHijriFrom = '$tempHijriYear-07-01';
          finalHijriTo = '$tempHijriYear-12-30';
        }
      } else if (tempPeriodScope == 'quarterly') {
        if (tempPeriodValue == 'q1') {
          finalHijriFrom = '$tempHijriYear-01-01';
          finalHijriTo = '$tempHijriYear-03-30';
        } else if (tempPeriodValue == 'q2') {
          finalHijriFrom = '$tempHijriYear-04-01';
          finalHijriTo = '$tempHijriYear-06-30';
        } else if (tempPeriodValue == 'q3') {
          finalHijriFrom = '$tempHijriYear-07-01';
          finalHijriTo = '$tempHijriYear-09-30';
        } else if (tempPeriodValue == 'q4') {
          finalHijriFrom = '$tempHijriYear-10-01';
          finalHijriTo = '$tempHijriYear-12-30';
        }
      }
    }

    final notifier = ref.read(allEntriesProvider.notifier);
    notifier.updateFilters(
      dateFilterType: tempDateFilterType,
      clearDateFilterType: false,
      dateFrom: tempPeriodScope == 'custom' ? tempDateFrom : null,
      dateTo: tempPeriodScope == 'custom' ? tempDateTo : null,
      hijriDateFrom: finalHijriFrom,
      hijriDateTo: finalHijriTo,
      clearDates: tempPeriodScope == 'all',
      recordBookCategory: tempRecordBookCategory,
      clearRecordBookCategory: tempRecordBookCategory == null,
      recordBookTypeId: tempRecordBookTypeId,
      clearRecordBookTypeId: tempRecordBookTypeId == null,
      contractTypeId: tempContractTypeId,
      clearContractTypeId: tempContractTypeId == null,
      status: tempStatus,
      clearStatus: tempStatus == null,
      writerType: tempWriterType,
      clearWriterType: tempWriterType == null,
      filteredWriterId: tempFilteredWriterId,
      clearFilteredWriterId: tempFilteredWriterId == null,
    );
    Navigator.pop(context);
  }

  void _clearAll() {
    ref.read(allEntriesProvider.notifier).clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait<dynamic>([
        ref.read(adminRepositoryProvider).getAdminRecordBookTypes(),
        ref
            .read(adminRepositoryProvider)
            .getContractTypes(), // changed from getAdminContractTypes since we need standard contract types
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookTypes =
            snapshot.data?[0] as List<Map<String, dynamic>>? ?? [];
        final contractTypes =
            snapshot.data?[1] as List<Map<String, dynamic>>? ?? [];

        // Filter book types by category if selected
        final filteredBookTypes = tempRecordBookCategory != null
            ? bookTypes
                  .where((t) => t['category'] == tempRecordBookCategory)
                  .toList()
            : bookTypes;

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
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
                        'تصفية بحث متقدمة',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 16),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // --- 1. Date Filters ---
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: const Text(
                            '1. التصفية حسب التاريخ',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.all(12),
                          children: [
                            // Date Filter Type (Radio)
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text(
                                      'تاريخ التحرير',
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: 13,
                                      ),
                                    ),
                                    value: 'transaction',
                                    groupValue: tempDateFilterType,
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (val) => setState(
                                      () => tempDateFilterType = val!,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text(
                                      'تاريخ التوثيق',
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: 13,
                                      ),
                                    ),
                                    value: 'documentation',
                                    groupValue: tempDateFilterType,
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (val) => setState(
                                      () => tempDateFilterType = val!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Period Scope
                            _buildDropdown<String>(
                              label: 'النطاق הזمَني',
                              value: tempPeriodScope,
                              items: const [
                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text(
                                    'جميع الأوقات',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'annual',
                                  child: Text(
                                    'سنوي',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'semi_annual',
                                  child: Text(
                                    'نصف سنوي',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'quarterly',
                                  child: Text(
                                    'ربع سنوي',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'custom',
                                  child: Text(
                                    'مخصص (ميلادي)',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  tempPeriodScope = val ?? 'all';
                                  tempPeriodValue = null;
                                  if (tempPeriodScope != 'all' &&
                                      tempPeriodScope != 'custom' &&
                                      tempHijriYear == null) {
                                    tempHijriYear = 1446; // Default to current
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            // Conditional Period Value / Year / Custom
                            if (tempPeriodScope != 'all' &&
                                tempPeriodScope != 'custom') ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDropdown<int>(
                                      label: 'السنة الهجرية',
                                      value: tempHijriYear,
                                      hint: 'السنة',
                                      items: List.generate(15, (index) {
                                        final year = 1446 - index;
                                        return DropdownMenuItem(
                                          value: year,
                                          child: Text(
                                            '$year هـ',
                                            style: const TextStyle(
                                              fontFamily: 'Tajawal',
                                            ),
                                          ),
                                        );
                                      }),
                                      onChanged: (val) =>
                                          setState(() => tempHijriYear = val),
                                    ),
                                  ),
                                  if (tempPeriodScope == 'semi_annual' ||
                                      tempPeriodScope == 'quarterly')
                                    const SizedBox(width: 12),
                                  if (tempPeriodScope == 'semi_annual')
                                    Expanded(
                                      child: _buildDropdown<String>(
                                        label: 'النصف',
                                        value: tempPeriodValue,
                                        hint: 'اختر النصف',
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'h1',
                                            child: Text(
                                              'الأول',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'h2',
                                            child: Text(
                                              'الثاني',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (val) => setState(
                                          () => tempPeriodValue = val,
                                        ),
                                      ),
                                    ),
                                  if (tempPeriodScope == 'quarterly')
                                    Expanded(
                                      child: _buildDropdown<String>(
                                        label: 'الربع',
                                        value: tempPeriodValue,
                                        hint: 'اختر الربع',
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'q1',
                                            child: Text(
                                              'الأول',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'q2',
                                            child: Text(
                                              'الثاني',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'q3',
                                            child: Text(
                                              'الثالث',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'q4',
                                            child: Text(
                                              'الرابع',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (val) => setState(
                                          () => tempPeriodValue = val,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ] else if (tempPeriodScope == 'custom') ...[
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final picked = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
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
                                },
                                icon: const Icon(Icons.date_range, size: 18),
                                label: Text(
                                  tempDateFrom != null
                                      ? '$tempDateFrom → ${tempDateTo ?? '...'}'
                                      : 'اختر فترة التحرير (ميلادي)',
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 13,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        // --- 2. Record Properties ---
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: const Text(
                            '2. خصائص السجل والعقد',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.all(12),
                          children: [
                            _buildDropdown<String>(
                              label: 'فئة السجل (Category)',
                              value: tempRecordBookCategory,
                              hint: 'الكل',
                              items: const [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    'الكل',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'guardian_recording',
                                  child: Text(
                                    'سجلات حفظ أمناء',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'documentation_recording',
                                  child: Text(
                                    'سجلات حفظ توثيق',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'documentation_final',
                                  child: Text(
                                    'سجلات توثيق نهائية',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                              ],
                              onChanged: (val) => setState(() {
                                tempRecordBookCategory = val;
                                tempRecordBookTypeId =
                                    null; // reset dependent dropdown
                              }),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown<int>(
                                    label: 'نوع الدفتر',
                                    value: tempRecordBookTypeId,
                                    hint: 'الكل',
                                    items: [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text(
                                          'الكل',
                                          style: TextStyle(
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ),
                                      ...filteredBookTypes.map(
                                        (t) => DropdownMenuItem(
                                          value: t['id'] as int,
                                          child: Text(
                                            t['name'] ?? '',
                                            style: const TextStyle(
                                              fontFamily: 'Tajawal',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (val) => setState(
                                      () => tempRecordBookTypeId = val,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdown<int>(
                                    label: 'نوع العقد',
                                    value: tempContractTypeId,
                                    hint: 'الكل',
                                    items: [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text(
                                          'الكل',
                                          style: TextStyle(
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ),
                                      ...contractTypes.map(
                                        (t) => DropdownMenuItem(
                                          value: t['id'] as int,
                                          child: Text(
                                            t['name'] ?? '',
                                            style: const TextStyle(
                                              fontFamily: 'Tajawal',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (val) => setState(
                                      () => tempContractTypeId = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildSectionTitle('حالة القيد'),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  {
                                    'all': 'الكل',
                                    'documented': 'موثق',
                                    'registered': 'مقيدة',
                                    'pending': 'قيد التدقيق',
                                    'draft': 'مسودة',
                                    'rejected': 'مرفوض',
                                  }.entries.map((e) {
                                    final isSel =
                                        (tempStatus ?? 'all') == e.key;
                                    return ChoiceChip(
                                      label: Text(
                                        e.value,
                                        style: const TextStyle(
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      selected: isSel,
                                      onSelected: (val) {
                                        if (val) {
                                          setState(
                                            () => tempStatus = e.key == 'all'
                                                ? null
                                                : e.key,
                                          );
                                        }
                                      },
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),

                        // --- 3. Writer Details ---
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: const Text(
                            '3. التصفية حسب الكاتب',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.all(12),
                          children: [
                            _buildDropdown<String>(
                              label: 'نوع الكاتب',
                              value: tempWriterType,
                              hint: 'الكل',
                              items: const [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    'الكل',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'guardian',
                                  child: Text(
                                    'أمين شرعي',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'documentation',
                                  child: Text(
                                    'موظف قلم توثيق',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'external',
                                  child: Text(
                                    'كاتب خارجي آخر',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  tempWriterType = val;
                                  tempFilteredWriterId = null;
                                });
                                if (val != null) {
                                  _fetchWritersForType(val);
                                } else {
                                  _writersList = [];
                                }
                              },
                            ),
                            if (tempWriterType != null) ...[
                              const SizedBox(height: 12),
                              if (_isLoadingWriters)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else
                                _buildDropdown<int>(
                                  label: 'اسم الكاتب المخصص',
                                  value: tempFilteredWriterId,
                                  hint: 'ابحث عن اسم الكاتب...',
                                  items: [
                                    const DropdownMenuItem(
                                      value: null,
                                      child: Text(
                                        'الكل',
                                        style: TextStyle(fontFamily: 'Tajawal'),
                                      ),
                                    ),
                                    ..._writersList.map(
                                      (w) => DropdownMenuItem(
                                        value: w['id'] as int,
                                        child: Text(
                                          w['name'] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Tajawal',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (val) => setState(
                                    () => tempFilteredWriterId = val,
                                  ),
                                ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Apply & Clear Buttons
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
                              'تطبيق الفلترة',
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? hint,
  }) {
    // Prevent dropdown from crashing if value is not in items
    final effectiveValue = items.any((i) => i.value == value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: effectiveValue,
              isExpanded: true,
              hint: Text(
                hint ?? '',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
