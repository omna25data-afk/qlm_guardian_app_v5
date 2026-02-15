import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/admin/data/models/admin_guardian_model.dart';
import '../../../../features/admin/presentation/providers/admin_guardians_provider.dart';
import '../../../../features/admin/presentation/widgets/licenses_list_tab.dart';
import '../../../../features/admin/presentation/widgets/cards_list_tab.dart';
import '../../../../features/admin/presentation/widgets/areas_list_tab.dart';
import '../../../../features/admin/presentation/widgets/assignments_list_tab.dart';
import '../../../../features/admin/presentation/screens/guardian_details_screen.dart';
import '../../../../features/admin/presentation/screens/add_edit_guardian_screen.dart';

class GuardiansTab extends ConsumerStatefulWidget {
  const GuardiansTab({super.key});

  @override
  ConsumerState<GuardiansTab> createState() => _GuardiansTabState();
}

class _GuardiansTabState extends ConsumerState<GuardiansTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(adminGuardiansProvider.notifier)
                    .onSearchChanged(value);
              },
              decoration: InputDecoration(
                hintText: 'بحث عن أمين (الاسم، السجل، رقم الهوية...)',
                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // 2. Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabAlignment: TabAlignment.start,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
              tabs: const [
                Tab(text: 'الأمناء'),
                Tab(text: 'تجديد الرخص'),
                Tab(text: 'تجديد البطاقات'),
                Tab(text: 'المناطق'),
                Tab(text: 'التكليفات'),
              ],
            ),
          ),

          // 3. Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGuardiansList(),
                const LicensesListTab(),
                const CardsListTab(),
                const AreasListTab(),
                const AssignmentsListTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditGuardianScreen()),
        ),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGuardiansList() {
    final state = ref.watch(adminGuardiansProvider);
    final notifier = ref.read(adminGuardiansProvider.notifier);

    if (state.isLoading && state.guardians.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.guardians.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل البيانات',
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
              onPressed: () => notifier.fetchGuardians(refresh: true),
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
      );
    }

    if (state.guardians.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد نتائج',
              style: TextStyle(color: Colors.grey[600], fontFamily: 'Tajawal'),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!state.isLoading &&
            state.hasMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          notifier.fetchGuardians();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async => notifier.fetchGuardians(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.guardians.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.guardians.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final guardian = state.guardians[index];
            return _buildGuardianCard(guardian);
          },
        ),
      ),
    );
  }

  Widget _buildGuardianCard(AdminGuardianModel guardian) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuardianDetailsScreen(guardian: guardian),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: guardian.photoUrl != null
                        ? NetworkImage(guardian.photoUrl!)
                        : null,
                    child: guardian.photoUrl == null
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guardian.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Text(
                          'سجل رقم: ${guardian.serialNumber}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(
                    guardian.employmentStatus ?? 'غير محدد',
                    _parseColor(guardian.employmentStatusColor),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditGuardianScreen(guardian: guardian),
                          ),
                        );
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(guardian);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'تعديل',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'حذف',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    Icons.card_membership,
                    'الترخيص',
                    guardian.licenseStatus ?? '-',
                    guardian.licenseStatusColor,
                  ),
                  _buildInfoItem(
                    Icons.badge,
                    'المزاولة',
                    guardian.cardStatus ?? '-',
                    guardian.cardStatusColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _parseColor(String? colorName) {
    if (colorName == null) return Colors.grey;
    switch (colorName.toLowerCase()) {
      case 'success':
      case 'green':
        return AppColors.success;
      case 'danger':
      case 'error':
      case 'red':
        return AppColors.error;
      case 'warning':
      case 'orange':
        return AppColors.warning;
      case 'info':
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation(AdminGuardianModel guardian) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف الأمين "${guardian.name}"؟ لا يمكن التراجع عن هذا الإجراء.',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(adminGuardiansProvider.notifier)
                  .deleteGuardian(guardian.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف الأمين بنجاح')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }
}
