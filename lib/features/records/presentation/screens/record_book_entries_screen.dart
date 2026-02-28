import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../../registry/presentation/providers/registry_provider.dart';
import '../../../registry/presentation/widgets/registry_entry_card.dart';

class RecordBookEntriesScreen extends ConsumerStatefulWidget {
  final int contractTypeId;
  final String contractTypeName;
  final int bookNumber;

  const RecordBookEntriesScreen({
    super.key,
    required this.contractTypeId,
    required this.contractTypeName,
    required this.bookNumber,
  });

  @override
  ConsumerState<RecordBookEntriesScreen> createState() =>
      _RecordBookEntriesScreenState();
}

class _RecordBookEntriesScreenState
    extends ConsumerState<RecordBookEntriesScreen> {
  // Sort direction: true = descending (newest first), false = ascending
  bool _sortDescending = true;

  @override
  Widget build(BuildContext context) {
    // Provide arguments using a record
    final args = (
      contractTypeId: widget.contractTypeId,
      bookNumber: widget.bookNumber,
    );
    final entriesAsync = ref.watch(entriesByRecordBookProvider(args));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'قيود دفتر رقم ${widget.bookNumber}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _sortDescending ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            tooltip: 'ترتيب حسب السنة الهجرية',
            onPressed: () {
              setState(() {
                _sortDescending = !_sortDescending;
              });
            },
          ),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'خطأ: $error',
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(entriesByRecordBookProvider(args).future),
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد قيود مرتبطة بهذا الدفتر',
                style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
              ),
            );
          }

          // Sort entries by Hijri Year
          final sortedEntries = List<RegistryEntrySections>.from(entries);
          sortedEntries.sort((a, b) {
            final yearA = _extractHijriYear(a);
            final yearB = _extractHijriYear(b);
            if (_sortDescending) {
              return yearB.compareTo(yearA);
            } else {
              return yearA.compareTo(yearB);
            }
          });

          // Group by Hijri Year
          final grouped = <int, List<RegistryEntrySections>>{};
          for (final entry in sortedEntries) {
            final year = _extractHijriYear(entry);
            grouped.putIfAbsent(year, () => []).add(entry);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(registryEntriesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: grouped.keys.length,
              itemBuilder: (context, index) {
                final yearKey = grouped.keys.elementAt(index);
                final yearEntries = grouped[yearKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            yearKey == 0 ? 'سنة غير محددة' : 'سنة $yearKey هـ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${yearEntries.length} قيد',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ...yearEntries.map(
                      (entry) => RegistryEntryCard(entry: entry),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  int _extractHijriYear(RegistryEntrySections entry) {
    // Attempt to extract from documentHijriDate first
    final docDate =
        entry.documentInfo.documentHijriDate ?? entry.documentInfo.docHijriDate;
    if (docDate != null && docDate.isNotEmpty) {
      final parts = docDate.split('-');
      if (parts.isNotEmpty) {
        final year = int.tryParse(parts[0]);
        if (year != null && year > 1000) return year; // Basic validation
      }
    }
    // Fallback to basicInfo hijriYear
    if (entry.basicInfo.hijriYear > 0) {
      return entry.basicInfo.hijriYear;
    }
    return 0;
  }
}
