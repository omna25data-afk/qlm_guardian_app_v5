import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/records/presentation/providers/records_provider.dart';
import '../../../features/records/presentation/screens/record_books_screen.dart';
import 'guardian_entries_list_screen.dart';

/// سجلاتي + قيودي — TabBar يبدل بينهما (كما في v4)
class MyRecordsTab extends ConsumerStatefulWidget {
  const MyRecordsTab({super.key});

  @override
  ConsumerState<MyRecordsTab> createState() => _MyRecordsTabState();
}

class _MyRecordsTabState extends ConsumerState<MyRecordsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Tab Bar
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'سجلاتي'),
              Tab(text: 'قيودي'),
            ],
            indicator: BoxDecoration(
              color: const Color(0xFF006400),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Tajawal',
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'Tajawal',
            ),
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.all(4),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // سجلاتي - الحاويات المركزية (7 أنواع)
              _buildContainersTab(),
              // قيودي - entries
              const GuardianEntriesListScreen(),
            ],
          ),
        ),
      ],
    );
  }

  /// عرض 7 حاويات مركزية (حسب نوع العقد)
  /// عند الضغط → شاشة الدفاتر الفرعية → الضغط على دفتر → قيود الدفتر
  Widget _buildContainersTab() {
    final typesState = ref.watch(recordBookTypesProvider);
    final booksState = ref.watch(recordBooksProvider);

    return typesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل السجلات',
              style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(recordBookTypesProvider);
                ref.read(recordBooksProvider.notifier).fetchRecordBooks();
              },
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
      data: (types) {
        return booksState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(recordBooksProvider.notifier).fetchRecordBooks(),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
              ],
            ),
          ),
          data: (books) {
            if (types.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد سجلات',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(recordBookTypesProvider);
                ref.read(recordBooksProvider.notifier).fetchRecordBooks();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final typeMap = types[index];
                  final typeId = typeMap['id'] as int;
                  final typeName = typeMap['name'] as String;
                  final contractTypeId = typeMap['contract_type_id'] as int?;

                  // حساب عدد الدفاتر والقيود المرتبطة بهذا النوع
                  final matchingBooks = books.where((b) {
                    if (contractTypeId != null &&
                        b.contractTypeId == contractTypeId)
                      return true;
                    if (b.recordBookTypeId == typeId) return true;
                    return false;
                  }).toList();

                  int totalEntries = matchingBooks.fold(
                    0,
                    (sum, b) => sum + b.totalEntries,
                  );
                  int activeBooks = matchingBooks.fold(
                    0,
                    (sum, b) => sum + b.notebooksCount,
                  );

                  return _buildContainerCard(
                    context: context,
                    typeName: typeName,
                    contractTypeId: contractTypeId ?? typeId,
                    totalEntries: totalEntries,
                    activeBooks: activeBooks,
                    icon: _getContainerIcon(typeName),
                    color: _getContainerColor(index),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContainerCard({
    required BuildContext context,
    required String typeName,
    required int contractTypeId,
    required int totalEntries,
    required int activeBooks,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecordBookNotebooksScreen(
                contractTypeId: contractTypeId,
                contractTypeName: typeName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // أيقونة الحاوية
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // اسم الحاوية والعداد
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildBadge(
                          '$activeBooks دفتر',
                          color.withValues(alpha: 0.1),
                          color,
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          '$totalEntries قيد',
                          Colors.grey.shade100,
                          Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // سهم الدخول
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  /// أيقونة مخصصة حسب نوع العقد
  IconData _getContainerIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('زواج') || lower.contains('نكاح')) {
      return Icons.favorite;
    }
    if (lower.contains('طلاق')) return Icons.heart_broken;
    if (lower.contains('رجعة')) return Icons.replay;
    if (lower.contains('وكالة') || lower.contains('وكالات')) {
      return Icons.assignment_ind;
    }
    if (lower.contains('مبيع') || lower.contains('بيع')) {
      return Icons.store;
    }
    if (lower.contains('تصرف')) return Icons.swap_horiz;
    if (lower.contains('قسمة')) return Icons.pie_chart;
    if (lower.contains('وصية')) return Icons.description;
    return Icons.book;
  }

  /// لون مخصص لكل حاوية
  Color _getContainerColor(int index) {
    const colors = [
      Color(0xFF006400), // أخضر داكن
      Color(0xFF1565C0), // أزرق
      Color(0xFFE65100), // برتقالي
      Color(0xFF6A1B9A), // بنفسجي
      Color(0xFF00838F), // تيل
      Color(0xFFC62828), // أحمر
      Color(0xFF4E342E), // بني
    ];
    return colors[index % colors.length];
  }
}
