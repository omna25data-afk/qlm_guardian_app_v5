import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/entries_provider.dart';
import '../widgets/registry_entry_card.dart';
import 'entry_details_screen.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEntriesAsync = ref.watch(filteredEntriesProvider);
    final selectedFilter = ref.watch(entryStatusFilterProvider);

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
                      hintStyle: GoogleFonts.tajawal(fontSize: 13),
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
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedFilter != null
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: selectedFilter != null
                        ? Colors.white
                        : AppColors.primary,
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
                    child: Text('الكل', style: GoogleFonts.tajawal()),
                  ),
                  PopupMenuItem(
                    value: 'draft',
                    child: Text('مسودة', style: GoogleFonts.tajawal()),
                  ),
                  PopupMenuItem(
                    value: 'pending',
                    child: Text('قيد المعالجة', style: GoogleFonts.tajawal()),
                  ),
                  PopupMenuItem(
                    value: 'approved',
                    child: Text('مكتمل', style: GoogleFonts.tajawal()),
                  ),
                  PopupMenuItem(
                    value: 'rejected',
                    child: Text('مرفوض', style: GoogleFonts.tajawal()),
                  ),
                ],
              ),
            ],
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
                    style: GoogleFonts.tajawal(),
                  ),
                  TextButton(
                    onPressed: () => ref.refresh(rawEntriesProvider),
                    child: Text('إعادة المحاولة', style: GoogleFonts.tajawal()),
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
                        style: GoogleFonts.tajawal(
                          color: Colors.grey[600],
                          fontSize: 16,
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
}
