import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../features/registry/presentation/providers/entries_provider.dart'
    show entrySortProvider;
import '../../../../../../../features/registry/presentation/providers/registry_provider.dart'
    show registryRepositoryProvider;
import '../../../../../../../features/registry/presentation/providers/contract_types_provider.dart';
import '../../../../../../../features/registry/presentation/screens/guardian_entry_screen.dart';
import '../widgets/advanced_guardian_filter_sheet.dart';
import '../widgets/guardian_registry_entry_card.dart';
import 'guardian_entry_details_screen.dart';

import '../../../providers/guardian_entries_provider.dart';

/// شاشة قائمة قيود الأمين الشرعي
/// تعرض جميع القيود مع إمكانية البحث والتصفية والترتيب
class GuardianEntriesListScreen extends ConsumerStatefulWidget {
  const GuardianEntriesListScreen({super.key});

  @override
  ConsumerState<GuardianEntriesListScreen> createState() =>
      _GuardianEntriesListScreenState();
}

class _GuardianEntriesListScreenState
    extends ConsumerState<GuardianEntriesListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(guardianAllEntriesProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entriesState = ref.watch(guardianAllEntriesProvider);
    final selectedStatuses = ref.watch(guardianEntryStatusesFilterProvider);
    final sortOption = ref.watch(entrySortProvider);
    ref.watch(contractTypesProvider); // Trigger fetch

    // Apply local sorting if needed
    var entries = List.of(entriesState.entries);
    if (sortOption == 'newest') {
      entries.sort((a, b) => b.id.compareTo(a.id));
    } else if (sortOption == 'oldest') {
      entries.sort((a, b) => a.id.compareTo(b.id));
    }

    Widget content;
    if (entriesState.isLoading && entries.isEmpty) {
      content = const Center(
        child: CircularProgressIndicator(color: Color(0xFF006400)),
      );
    } else if (entriesState.error != null && entries.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ أثناء تحميل البيانات',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(guardianAllEntriesProvider.notifier).refresh(),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Color(0xFF006400),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (entries.isEmpty) {
      content = Center(
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
    } else {
      content = RefreshIndicator(
        color: const Color(0xFF006400),
        onRefresh: () async {
          return ref.read(guardianAllEntriesProvider.notifier).refresh();
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: entries.length + (entriesState.isFetchingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == entries.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF006400)),
                ),
              );
            }
            final entry = entries[index];
            return GuardianRegistryEntryCard(
              entry: entry,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GuardianEntryDetailsScreen(entry: entry),
                  ),
                );
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GuardianEntryScreen(entry: entry),
                  ),
                );
              },
              onRequestDocumentation:
                  (entry.statusInfo.status == 'draft' ||
                      entry.statusInfo.status == 'registered_guardian')
                  ? () async {
                      try {
                        final targetId = entry.remoteId ?? entry.id;
                        await ref
                            .read(registryRepositoryProvider)
                            .requestDocumentation(targetId);
                        ref.read(guardianAllEntriesProvider.notifier).refresh();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم إرسال طلب التوثيق بنجاح',
                                style: TextStyle(fontFamily: 'Tajawal'),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'خطأ: ${e.toString()}',
                                style: const TextStyle(fontFamily: 'Tajawal'),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  : null,
            );
          },
        ),
      );
    }

    return Column(
      children: [
        // Search and Filter Bar
        _buildSearchFilterBar(context, sortOption),

        // Active Filters Chips Row
        _buildActiveFiltersRow(selectedStatuses),

        // Entries List
        Expanded(child: content),
      ],
    );
  }

  /// شريط البحث والتصفية والترتيب
  Widget _buildSearchFilterBar(BuildContext context, String sortOption) {
    return Padding(
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
                    color: Color(0xFF006400),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintStyle: TextStyle(fontSize: 13, fontFamily: 'Tajawal'),
                ),
                onChanged: (value) {
                  ref.read(guardianEntrySearchQueryProvider.notifier).state =
                      value;
                  // Trigger a backend search update
                  ref.read(guardianAllEntriesProvider.notifier).refresh();
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
              child: const Icon(Icons.sort, color: Color(0xFF006400)),
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
                  'الأحدث إضافة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              PopupMenuItem(
                value: 'oldest',
                child: Text(
                  'الأقدم إضافة',
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
              PopupMenuItem(
                value: 'newest_doc_date',
                child: Text(
                  'الأحدث تاريخ محرر',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              PopupMenuItem(
                value: 'oldest_doc_date',
                child: Text(
                  'الأقدم تاريخ محرر',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              PopupMenuItem(
                value: 'status',
                child: Text(
                  'حسب الحالة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              PopupMenuItem(
                value: 'contract_type',
                child: Text(
                  'حسب نوع العقد',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Advanced Filter Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFF006400)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const AdvancedGuardianFilterSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// شريط شرائح التصفية النشطة
  Widget _buildActiveFiltersRow(List<String> selectedStatuses) {
    return Builder(
      builder: (context) {
        final activeFilters = <Widget>[];

        if (selectedStatuses.isNotEmpty) {
          for (var status in selectedStatuses) {
            activeFilters.add(
              _buildActiveFilterChip(_getStatusName(status), () {
                final current = List<String>.from(
                  ref.read(guardianEntryStatusesFilterProvider),
                );
                current.remove(status);
                ref.read(guardianEntryStatusesFilterProvider.notifier).state =
                    current;
                ref.read(guardianAllEntriesProvider.notifier).refresh();
              }),
            );
          }
        }

        final contractTypeId = ref.watch(
          guardianEntryContractTypeFilterProvider,
        );
        if (contractTypeId != null) {
          activeFilters.add(
            _buildActiveFilterChip('نوع العقد مخصص', () {
              ref.read(guardianEntryContractTypeFilterProvider.notifier).state =
                  null;
              ref.read(guardianAllEntriesProvider.notifier).refresh();
            }),
          );
        }

        // Removed deliveryStatus since it's not present in guardianEntry variants yet.
        // We can add it back if we introduce guardianEntryDeliveryStatusFilterProvider

        // Removed date filter block since we haven't created the guardianEntryDate variants

        if (activeFilters.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ).copyWith(bottom: 12),
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...activeFilters.expand(
                  (chip) => [chip, const SizedBox(width: 8)],
                ),
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
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  onPressed: () {
                    ref
                            .read(guardianEntryStatusesFilterProvider.notifier)
                            .state =
                        [];
                    ref
                            .read(
                              guardianEntryContractTypeFilterProvider.notifier,
                            )
                            .state =
                        null;
                    ref.read(guardianAllEntriesProvider.notifier).refresh();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF006400).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF006400).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: Color(0xFF006400),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Color(0xFF006400)),
          ),
        ],
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
