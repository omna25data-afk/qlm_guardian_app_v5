import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Actually, I'll just remove the lines reported as unused.

import '../../../../system/data/models/registry_entry_sections.dart';
import '../../../../admin/presentation/widgets/premium_entry_card.dart';
import '../../../../admin/data/repositories/admin_repository.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/injection.dart';
import '../../../../admin/presentation/widgets/registry_entry_correction_dialog.dart';
import '../../../../registry/presentation/screens/compact_registry_entry_screen.dart';
import '../admin_add_entry_screen.dart';

// Create a provider for All Entries specifically
final allEntriesProvider =
    StateNotifierProvider.autoDispose<
      AllEntriesNotifier,
      AsyncValue<List<RegistryEntrySections>>
    >((ref) {
      return AllEntriesNotifier(getIt<AdminRepository>());
    });

class AllEntriesNotifier
    extends StateNotifier<AsyncValue<List<RegistryEntrySections>>> {
  final AdminRepository _repository;

  // Filters
  String? searchQuery;
  String? status;
  int? year;
  int? contractTypeId;
  String? writerType;

  AllEntriesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchEntries();
  }

  Future<void> fetchEntries() async {
    state = const AsyncValue.loading();
    try {
      final entries = await _repository.getRegistryEntries(
        searchQuery: searchQuery,
        status: status,
        year: year,
        contractTypeId: contractTypeId,
        writerType: writerType,
      );
      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateFilters({
    String? search,
    String? status,
    int? year,
    int? contractTypeId,
    String? writerType,
  }) {
    if (search != null) searchQuery = search;
    if (status != null) this.status = status;
    if (year != null) this.year = year;
    if (contractTypeId != null) this.contractTypeId = contractTypeId;
    if (writerType != null) this.writerType = writerType;
    fetchEntries();
  }
}

class AllEntriesTab extends ConsumerWidget {
  const AllEntriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesState = ref.watch(allEntriesProvider);
    final notifier = ref.read(allEntriesProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_entry_compact_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompactRegistryEntryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.architecture, size: 20),
            label: const Text(
              'النموذج المقسم (تجريبي)',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_entry_normal_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminAddEntryScreen()),
              );
            },
            icon: const Icon(Icons.add_circle, size: 20),
            label: const Text(
              'إضافة قيد جديد',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar (Search + Chips)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث في المحررات (رقم القيد، الأطراف...)',
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
                    // Debounce in a real app
                    notifier.updateFilters(search: val);
                  },
                ),
                const SizedBox(height: 12),
                // Horizontal Filter Chips
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
                        label: 'قيد التدقيق', // Pending
                        isActive: notifier.status == 'pending',
                        onTap: () => notifier.updateFilters(status: 'pending'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'مسودة', // Draft
                        isActive: notifier.status == 'draft',
                        onTap: () => notifier.updateFilters(status: 'draft'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Entries List
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
                          'لا توجد محررات مطابقة',
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
                    return PremiumEntryCard(
                      entry: entry,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              RegistryEntryCorrectionDialog(entry: entry),
                        );
                      },
                    );
                  },
                );
              },
              error: (err, st) => Center(
                child: Text(
                  'حدث خطأ: $err',
                  style: const TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
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
      onTap: isActive ? null : onTap, // Prevent reload if already active
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
