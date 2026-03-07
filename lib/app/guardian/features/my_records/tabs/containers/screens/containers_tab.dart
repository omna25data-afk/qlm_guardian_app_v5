import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../features/records/presentation/providers/records_provider.dart';
import '../widgets/container_card.dart';

/// تبويب الحاويات المركزية (السجل العام لدفاتر السجلات)
/// يعرض الحاويات المُجمّعة حسب نوع العقد — كما يعيدها الـ API
/// كل حاوية تحتوي على totalEntries و notebooksCount مُحسوبة من الباكند
class ContainersTab extends ConsumerWidget {
  const ContainersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(recordBooksProvider);

    return booksState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF006400)),
      ),
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
        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, size: 64, color: AppColors.textHint),
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

        // الـ API يعيد سجلاً واحداً مُجمّعاً لكل نوع عقد
        // كل سجل يحتوي على totalEntries و notebooksCount محسوبة من الباكند
        return RefreshIndicator(
          color: const Color(0xFF006400),
          onRefresh: () async {
            ref.read(recordBooksProvider.notifier).fetchRecordBooks();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return ContainerCard(
                typeName: book.name,
                contractTypeId: book.contractTypeId ?? 0,
                totalEntries: book.totalEntries,
                activeBooks: book.notebooksCount,
                icon: _getContainerIcon(book.name),
                color: _getContainerColor(index),
              );
            },
          ),
        );
      },
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
