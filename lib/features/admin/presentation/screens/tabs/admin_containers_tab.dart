import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../providers/admin_containers_provider.dart';
import '../../widgets/admin_container_card.dart';

/// تبويب الحاويات المركزية (السجل العام لدفاتر السجلات) - قسم الإدارة
class AdminContainersTab extends ConsumerStatefulWidget {
  const AdminContainersTab({super.key});

  @override
  ConsumerState<AdminContainersTab> createState() => _AdminContainersTabState();
}

class _AdminContainersTabState extends ConsumerState<AdminContainersTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminContainersProvider.notifier).loadContainers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminContainersProvider);

    if (state.isLoading && state.containers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.error != null && state.containers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'خطأ في تحميل الحاويات',
              style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  ref.read(adminContainersProvider.notifier).loadContainers(),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      );
    }

    if (state.containers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            const Text(
              'لا توجد حاويات سجلات',
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

    final body = RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await ref.read(adminContainersProvider.notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.containers.length,
        itemBuilder: (context, index) {
          final container = state.containers[index];

          return AdminContainerCard(
            typeName: container.name,
            contractTypeId: container.contractTypeId ?? 0,
            totalEntries: container.totalEntries,
            activeBooks: container.notebooksCount,
            icon: _getContainerIcon(container.name),
            color: _getContainerColor(index),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة السجلات',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF006400),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[50],
      body: body,
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
