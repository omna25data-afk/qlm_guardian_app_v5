import 'dart:io';

void main() {
  final file = File(
    'lib/features/admin/presentation/screens/tabs/record_books_tab.dart',
  );
  final lines = file.readAsLinesSync();

  final importIndex = lines.indexWhere(
    (l) => l.contains('class RecordBooksTab extends'),
  );
  final startIndex = lines.indexWhere(
    (l) => l.contains('Widget _buildFiltersSection() {'),
  );
  final endIndex = lines.indexWhere(
    (l) => l.contains('  Widget _buildRecordBooksList() {'),
  );

  if (importIndex != -1 && startIndex != -1 && endIndex != -1) {
    final newImports =
        '''import '../../../../admin/presentation/widgets/advanced_record_books_filter_sheet.dart';''';
    lines.insert(importIndex, newImports);

    // After inserting import, start and end index shifted by 1
    final actualStart = lines.indexWhere(
      (l) => l.contains('Widget _buildFiltersSection() {'),
    );
    final actualEnd = lines.indexWhere(
      (l) => l.contains('  Widget _buildRecordBooksList() {'),
    );

    final newContent = '''
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
      if (state.categoryFilter == 'documentation_recording') label = 'تحرير التوثيق';
      if (state.categoryFilter == 'documentation_final') label = 'التوثيق النهائي';
      activeFilters.add(_buildActiveFilterChip(label, () => notifier.setCategoryFilter(null)));
    }
    
    if (state.statusFilter != null) {
      final statuses = {'active': 'نشط', 'closed': 'مغلق', 'completed': 'مكتمل', 'pending': 'معلق'};
      activeFilters.add(_buildActiveFilterChip(statuses[state.statusFilter] ?? state.statusFilter!, () => notifier.setStatusFilter(null)));
    }
    
    if (state.typeFilter != null) {
      activeFilters.add(_buildActiveFilterChip(state.typeFilter!, () => notifier.setTypeFilter(null)));
    }
    
    if (state.guardianFilter != null) {
      activeFilters.add(_buildActiveFilterChip('أمين محدد', () => notifier.setGuardianFilter(null)));
    }
    
    if (state.periodType != null) {
      String label = '';
      if (state.periodType == 'yearly') label = 'سنة \${state.periodYear}';
      else if (state.periodType == 'half_yearly') label = 'نصف \${state.periodValue == '1' ? 'أول' : 'ثاني'} \${state.periodYear}';
      else if (state.periodType == 'quarterly') label = 'ربع \${state.periodValue} \${state.periodYear}';
      else if (state.periodType == 'custom') label = '\${state.dateFrom} - \${state.dateTo}';
      activeFilters.add(_buildActiveFilterChip(label, () => notifier.setPeriodFilter(periodType: null)));
    }
    
    if (state.sortField != null) {
      final sorts = {'book_number': 'رقم السجل', 'created_at': 'تاريخ الإنشاء', 'usage': 'نسبة الاستخدام', 'entries_count': 'عدد القيود'};
      activeFilters.add(_buildActiveFilterChip('ترتيب: \${sorts[state.sortField] ?? state.sortField}', () => notifier.setSortField(null)));
    }
    
     if (state.groupBy != null) {
      final groups = {'type': 'نوع العقد', 'guardian': 'الأمين', 'year': 'السنة الهجرية', 'writer_type': 'نوع الكاتب'};
      activeFilters.add(_buildActiveFilterChip('تجميع: \${groups[state.groupBy] ?? state.groupBy}', () => notifier.setGroupBy(null)));
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
            const Text('فلاتر نشطة:', style: TextStyle(fontFamily: 'Tajawal', fontSize: 11, color: Colors.grey)),
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
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
''';

    lines.removeRange(actualStart - 1, actualEnd); // also remove the comment
    lines.insert(actualStart - 1, newContent);

    // Now replace the build method contents to use the new methods
    final buildStart = lines.indexWhere(
      (l) =>
          l.contains('  @override') &&
          lines
              .skip(lines.indexWhere((l) => l.contains('  @override')) + 1)
              .first
              .contains('  Widget build(BuildContext context) {'),
    );
    if (buildStart != -1) {
      for (var i = buildStart; i < buildStart + 20; i++) {
        if (lines[i].contains('_buildFiltersSection()')) {
          lines[i] =
              '          _buildSearchBarAndFilterIcon(),\\n          _buildActiveFiltersRow(),';
        }
        if (lines[i].contains('_buildGroupBySortBar()')) {
          lines[i] = '';
        }
      }
    }

    file.writeAsStringSync(lines.join('\\n'));
    print('Dart Replace Success');
  } else {
    print('Failed to find indices');
  }
}
