import 'dart:io';

void main() {
  final file = File(
    'lib/features/admin/presentation/screens/tabs/all_entries_tab.dart',
  );
  final lines = file.readAsLinesSync();

  final importIndex = lines.indexWhere(
    (l) => l.contains('class AllEntriesState {'),
  );
  final startFilterChipIndex = lines.indexWhere(
    (l) => l.contains('  Widget _buildFilterChip('),
  );
  final buildIndex = lines.indexWhere(
    (l) => l.contains('  Widget build(BuildContext context, WidgetRef ref) {'),
  );

  if (importIndex != -1 && startFilterChipIndex != -1 && buildIndex != -1) {
    final newImports =
        '''import '../../../../admin/presentation/widgets/advanced_all_entries_filter_sheet.dart';''';
    lines.insert(importIndex, newImports);

    // After inserting import, indices shift by 1
    final actualStart = lines.indexWhere(
      (l) => l.contains('  Widget _buildFilterChip('),
    );
    final bodyStartIndex = lines.indexWhere(
      (l) => l.contains('      body: Column('),
    );

    // Find where the Expanded containing Entries List starts.
    int expectedExpandedIndex = -1;
    for (int i = bodyStartIndex; i < lines.length; i++) {
      if (lines[i].contains('          // Entries List') ||
          lines[i].contains('          Expanded(')) {
        expectedExpandedIndex = i;
        if (lines[i].contains('          // Entries List')) {
          // check next line for expanded
          if (lines[i + 1].contains('          Expanded(') ||
              lines[i + 1].contains('          child: Expanded(') ||
              lines[i + 1].contains(
                '          child: entriesState.isLoading',
              )) {
            // all good
            break;
          }
        } else {
          break;
        }
      }
    }

    final newContent = '''
  Widget _buildSearchBarAndFilterIcon(BuildContext context, WidgetRef ref, AllEntriesNotifier notifier, AllEntriesState entriesState) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث في المحررات (رقم القيد، الأطراف...)',
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
                notifier.updateFilters(search: val, clearSearch: val.isEmpty);
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
                  builder: (ctx) => const AdvancedAllEntriesFilterSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow(AllEntriesState state, AllEntriesNotifier notifier) {
    final activeFilters = <Widget>[];

    if (state.contractTypeId != null) {
      activeFilters.add(_buildActiveFilterChip('نوع العقد مخصص', () => notifier.updateFilters(clearContractTypeId: true)));
    }
    
    if (state.status != null) {
      final statuses = {'documented': 'موثق', 'registered': 'مقيدة', 'pending': 'قيد التدقيق', 'draft': 'مسودة', 'rejected': 'مرفوض'};
      activeFilters.add(_buildActiveFilterChip(statuses[state.status] ?? state.status!, () => notifier.setStatus(null)));
    }
    
    if (state.writerType != null) {
      activeFilters.add(_buildActiveFilterChip(state.writerType!, () => notifier.setWriterType(null)));
    }
    
    if (state.year != null) {
      activeFilters.add(_buildActiveFilterChip('سنة \${state.year}', () => notifier.updateFilters(clearYear: true)));
    }
    
    if (state.dateFrom != null || state.dateTo != null) {
      activeFilters.add(_buildActiveFilterChip('\${state.dateFrom ?? '...'} - \${state.dateTo ?? '...'}', () => notifier.updateFilters(clearDates: true)));
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

    // Remove `_buildFilterChip` and `_showAdvancedFilters`
    lines.removeRange(actualStart, buildIndex);

    // Add our new functions above the build widget
    final updatedBuildIndex = lines.indexWhere(
      (l) =>
          l.contains('  Widget build(BuildContext context, WidgetRef ref) {'),
    );
    lines.insert(updatedBuildIndex, newContent);

    // Update the Widget build() body
    final currentBodyStart = lines.indexWhere(
      (l) => l.contains('      body: Column('),
    );
    final expectedEx = lines.indexWhere(
      (l) =>
          l.contains('          // Entries List') ||
          (l.contains('          Expanded(') &&
              !l.contains('Expanded(child: TextField(decoration')),
    );

    if (expectedEx != -1) {
      final replacementList = [
        '      body: Column(',
        '        children: [',
        '          _buildSearchBarAndFilterIcon(context, ref, notifier, entriesState),',
        '          _buildActiveFiltersRow(entriesState, notifier),',
      ];
      lines.replaceRange(currentBodyStart, expectedEx, replacementList);

      file.writeAsStringSync(lines.join('\\n'));
      print('AllEntriesTab Replace Success');
    } else {
      print('Could not find expected Expanded');
    }
  } else {
    print('Failed to find indices');
  }
}
