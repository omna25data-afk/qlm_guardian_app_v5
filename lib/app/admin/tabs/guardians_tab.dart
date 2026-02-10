import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../features/admin/data/models/admin_guardian_model.dart';
import '../../../../features/admin/presentation/providers/admin_guardians_provider.dart';

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
    return Column(
      children: [
        // 1. Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              ref.read(adminGuardiansProvider.notifier).onSearchChanged(value);
            },
            decoration: InputDecoration(
              hintText: 'بحث عن أمين (الاسم، السجل، رقم الهوية...)',
              hintStyle: GoogleFonts.tajawal(color: Colors.grey),
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
            labelStyle: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: GoogleFonts.tajawal(
              fontWeight: FontWeight.w500,
              fontSize: 14,
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
              const Center(child: Text('قريباً: تجديد الرخص')),
              const Center(child: Text('قريباً: تجديد البطاقات')),
              const Center(child: Text('قريباً: المناطق')),
              const Center(child: Text('قريباً: التكليفات')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuardiansList() {
    final guardiansAsync = ref.watch(adminGuardiansProvider);

    return guardiansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('خطأ: $error')),
      data: (guardians) {
        if (guardians.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'لا توجد نتائج',
                  style: GoogleFonts.tajawal(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: guardians.length,
          itemBuilder: (context, index) {
            return _buildGuardianCard(guardians[index]);
          },
        );
      },
    );
  }

  Widget _buildGuardianCard(AdminGuardianModel guardian) {
    return Card(
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
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'سجل رقم: ${guardian.serialNumber}',
                        style: GoogleFonts.tajawal(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(
                  guardian.employmentStatus ?? 'غير محدد',
                  _parseColor(guardian.employmentStatusColor),
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
        style: GoogleFonts.tajawal(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
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
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey),
            ),
            Text(
              value,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _parseColor(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'red':
      case 'danger':
        return AppColors.error;
      case 'orange':
      case 'warning':
        return AppColors.warning;
      case 'green':
      case 'success':
        return AppColors.success;
      case 'blue':
      case 'primary':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }
}
