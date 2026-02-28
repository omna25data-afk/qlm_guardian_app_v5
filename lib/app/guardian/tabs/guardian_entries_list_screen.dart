import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/registry/presentation/providers/entries_provider.dart';
import '../../../../features/registry/presentation/providers/contract_types_provider.dart';
import 'widgets/guardian_registry_entry_card.dart';
import 'screens/guardian_entry_details_screen.dart';

class GuardianEntriesListScreen extends ConsumerWidget {
  const GuardianEntriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEntriesAsync = ref.watch(filteredEntriesProvider);
    final selectedFilter = ref.watch(entryStatusFilterProvider);
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
                      prefixIcon: const Icon(
                        Icons.search,
                        color: const Color(0xFF006400),
                      ),
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
              const SizedBox(width: 10),
              PopupMenuButton<String?>(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedFilter != null
                        ? const Color(0xFF006400)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedFilter != null
                          ? const Color(0xFF006400)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: selectedFilter != null
                        ? Colors.white
                        : const Color(0xFF006400),
                  ),
                ),
                tooltip: 'تصفية حسب الحالة',
                initialValue: selectedFilter,
                onSelected: (value) {
                  ref.read(entryStatusFilterProvider.notifier).state = value;
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: null,
                    child: Text(
                      'الكل',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'draft',
                    child: Text(
                      'مسودة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'pending',
                    child: Text(
                      'قيد المعالجة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'approved',
                    child: Text(
                      'مكتمل',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'rejected',
                    child: Text(
                      'مرفوض',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Entries List
        Expanded(
          child: filteredEntriesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF006400)),
            ),
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
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0xFF006400),
                      ),
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
                color: const Color(0xFF006400),
                onRefresh: () async {
                  return ref.refresh(rawEntriesProvider.future);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return GuardianRegistryEntryCard(
                      entry: entry,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GuardianEntryDetailsScreen(entry: entry),
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
}
