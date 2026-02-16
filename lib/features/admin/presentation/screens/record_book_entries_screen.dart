import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';

import 'package:qlm_guardian_app_v5/features/registry/presentation/widgets/registry_entry_card.dart';
import 'package:qlm_guardian_app_v5/features/registry/presentation/screens/entry_details_screen.dart';
import '../../../records/data/models/record_book.dart';
import '../providers/record_book_entries_provider.dart';

class RecordBookEntriesScreen extends ConsumerStatefulWidget {
  final RecordBook book;

  const RecordBookEntriesScreen({super.key, required this.book});

  @override
  ConsumerState<RecordBookEntriesScreen> createState() =>
      _RecordBookEntriesScreenState();
}

class _RecordBookEntriesScreenState
    extends ConsumerState<RecordBookEntriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider family with the specific book ID
    final entriesState = ref.watch(recordBookEntriesProvider(widget.book.id));
    final notifier = ref.read(
      recordBookEntriesProvider(widget.book.id).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'قيود السجل',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.book.title.isNotEmpty
                  ? widget.book.title
                  : 'سجل رقم ${widget.book.number}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث في القيود (رقم القيد، الأطراف...)',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    // Simple debounce could be added here
                    notifier.updateFilters(search: val);
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'الكل',
                        isActive: notifier.status == null,
                        onTap: () => notifier.updateFilters(status: null),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'موثق',
                        isActive: notifier.status == 'documented',
                        onTap: () =>
                            notifier.updateFilters(status: 'documented'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'تم التسجيل',
                        isActive: notifier.status == 'registered_guardian',
                        onTap: () => notifier.updateFilters(
                          status: 'registered_guardian',
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'بانتظار التوثيق',
                        isActive: notifier.status == 'pending_documentation',
                        onTap: () => notifier.updateFilters(
                          status: 'pending_documentation',
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'مسودة',
                        isActive: notifier.status == 'draft',
                        onTap: () => notifier.updateFilters(status: 'draft'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'مرفوض',
                        isActive: notifier.status == 'rejected',
                        onTap: () => notifier.updateFilters(status: 'rejected'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List
          Expanded(
            child: entriesState.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد قيود في هذا السجل',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return RegistryEntryCard(
                      entry: entry,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EntryDetailsScreen(entry: entry),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              error: (err, st) => Center(child: Text('خطأ: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? null
              : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }
}
