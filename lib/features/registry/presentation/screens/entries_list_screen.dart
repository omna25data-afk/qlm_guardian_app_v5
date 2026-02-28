import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/entries_provider.dart';
import '../providers/contract_types_provider.dart';
import '../widgets/registry_entry_card.dart';
import 'entry_details_screen.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEntriesAsync = ref.watch(filteredEntriesProvider);
    final selectedStatuses = ref.watch(entryStatusesFilterProvider);
    final sortOption = ref.watch(entrySortProvider);
    ref.watch(contractTypesProvider); // Trigger fetch

    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'بحث باسم الطرف، الموضوع، رقم القيد...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintStyle: TextStyle(fontSize: 13, fontFamily: 'Tajawal'),
                    ),
                    onChanged: (value) {
                      ref.read(entrySearchQueryProvider.notifier).state = value;
                    },
                  ),
                ),
              ),
              // Sort Menu
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.sort, color: AppColors.primary),
                ),
                tooltip: 'ترتيب حسب',
                initialValue: sortOption,
                onSelected: (value) {
                  ref.read(entrySortProvider.notifier).state = value;
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'newest',
                    child: Text(
                      'الأحدث أضافة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'oldest',
                    child: Text(
                      'الأقدم أضافة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'highest_amount',
                    child: Text(
                      'الأعلى مبلغاً',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'lowest_amount',
                    child: Text(
                      'الأقل مبلغاً',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // Filter Menu (Multiple Select)
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedStatuses.isNotEmpty
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedStatuses.isNotEmpty
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: selectedStatuses.isNotEmpty
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),
                tooltip: 'تصفية حسب الحالة',
                itemBuilder: (context) => [
                  _buildFilterItem(ref, selectedStatuses, 'draft', 'مسودة'),
                  _buildFilterItem(
                    ref,
                    selectedStatuses,
                    'pending',
                    'قيد المعالجة',
                    'pending_documentation',
                  ),
                  _buildFilterItem(
                    ref,
                    selectedStatuses,
                    'ready',
                    'جاهز',
                    'registered_guardian',
                  ),
                  _buildFilterItem(
                    ref,
                    selectedStatuses,
                    'approved',
                    'مكتمل',
                    'documented',
                  ),
                  _buildFilterItem(ref, selectedStatuses, 'rejected', 'مرفوض'),
                ],
              ),
            ],
          ),
        ),

        // Active Filters Chips Row
        if (selectedStatuses.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ).copyWith(bottom: 12),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...selectedStatuses.map((status) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Chip(
                        label: Text(
                          _getStatusName(status),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        onDeleted: () {
                          final current = List<String>.from(
                            ref.read(entryStatusesFilterProvider),
                          );
                          current.remove(status);
                          ref.read(entryStatusesFilterProvider.notifier).state =
                              current;
                        },
                        deleteIconColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    );
                  }),
                  // Clear all button
                  ActionChip(
                    label: const Text(
                      'مسح الكل',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red.withOpacity(0.3)),
                    ),
                    onPressed: () {
                      ref.read(entryStatusesFilterProvider.notifier).state = [];
                    },
                  ),
                ],
              ),
            ),
          ),

        // Entries List
        Expanded(
          child: filteredEntriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ أثناء تحميل البيانات',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  TextButton(
                    onPressed: () => ref.refresh(rawEntriesProvider),
                    child: Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            ),
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد قيود تطابق البحث',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  return ref.refresh(rawEntriesProvider.future);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildFilterItem(
    WidgetRef ref,
    List<String> selectedStatuses,
    String value,
    String label, [
    String? alternateValue,
  ]) {
    final effectiveValue = alternateValue ?? value;
    final isSelected = selectedStatuses.contains(effectiveValue);

    return PopupMenuItem(
      value: effectiveValue,
      child: StatefulBuilder(
        builder: (context, setState) {
          return CheckboxListTile(
            title: Text(label, style: const TextStyle(fontFamily: 'Tajawal')),
            value: isSelected,
            onChanged: (bool? checked) {
              final current = List<String>.from(
                ref.read(entryStatusesFilterProvider),
              );
              if (checked == true) {
                current.add(effectiveValue);
              } else {
                current.remove(effectiveValue);
              }
              ref.read(entryStatusesFilterProvider.notifier).state = current;
              // Close the popup after selection (optional, or keep open for multiple selections)
              Navigator.pop(context);
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          );
        },
      ),
    );
  }

  String _getStatusName(String status) {
    switch (status) {
      case 'draft':
        return 'مسودة';
      case 'pending':
      case 'pending_documentation':
        return 'قيد المعالجة';
      case 'documented':
      case 'approved':
      case 'completed':
        return 'مكتمل';
      case 'registered_guardian':
        return 'جاهز';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }
}
