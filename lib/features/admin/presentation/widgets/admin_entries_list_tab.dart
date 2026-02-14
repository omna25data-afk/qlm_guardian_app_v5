import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../registry/presentation/widgets/registry_entry_card.dart';
import '../../../registry/presentation/screens/entry_details_screen.dart';
import '../providers/admin_entries_provider.dart';

class AdminEntriesListTab extends ConsumerStatefulWidget {
  const AdminEntriesListTab({super.key});

  @override
  ConsumerState<AdminEntriesListTab> createState() =>
      _AdminEntriesListTabState();
}

class _AdminEntriesListTabState extends ConsumerState<AdminEntriesListTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminEntriesProvider.notifier).fetchEntries(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminEntriesProvider.notifier).fetchEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminEntriesProvider);

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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'بحث باسم الطرف، الموضوع، رقم القيد...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintStyle: TextStyle(fontSize: 13, fontFamily: 'Tajawal'),
                    ),
                    onSubmitted: (value) {
                      ref
                          .read(adminEntriesProvider.notifier)
                          .setSearchQuery(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String?>(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: state.statusFilter != null
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: state.statusFilter != null
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: state.statusFilter != null
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),
                tooltip: 'تصفية حسب الحالة',
                initialValue: state.statusFilter,
                onSelected: (value) {
                  ref
                      .read(adminEntriesProvider.notifier)
                      .setStatusFilter(value);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: null,
                    child: Text(
                      'الكل',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'draft',
                    child: Text(
                      'مسودة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'pending',
                    child: Text(
                      'قيد المعالجة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'approved',
                    child: Text(
                      'مكتمل',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  const PopupMenuItem(
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

        // Error State
        if (state.error != null && state.entries.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'خطأ في تحميل القيود',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref
                        .read(adminEntriesProvider.notifier)
                        .fetchEntries(refresh: true),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(
                      'إعادة المحاولة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // List
        if (state.error == null || state.entries.isNotEmpty)
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(adminEntriesProvider.notifier)
                    .fetchEntries(refresh: true);
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.entries.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.entries.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.entries.isEmpty && !state.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[300],
                          ),
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

                  final entry = state.entries[index];
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
            ),
          ),
      ],
    );
  }
}
