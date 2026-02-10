import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

/// لوحة الأمين الشرعي — إحصائياتي + حالة الترخيص/البطاقة
class GuardianDashboardTab extends ConsumerWidget {
  const GuardianDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh guardian dashboard data from API
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً، ${user?.guardian?.fullName ?? user?.name ?? "الأمين"}',
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF006400),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user?.guardian?.specializationArea != null)
                    Text(
                      'منطقة الاختصاص: ${user!.guardian!.specializationArea}',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Stats Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إحصائياتي',
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: const [
              _StatCard(
                title: 'إجمالي القيود',
                value: '—',
                icon: Icons.all_inbox_outlined,
                color: Colors.blue,
              ),
              _StatCard(
                title: 'موثق',
                value: '—',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              _StatCard(
                title: 'بانتظار التوثيق',
                value: '—',
                icon: Icons.access_time_outlined,
                color: Colors.orange,
              ),
              _StatCard(
                title: 'المسودات',
                value: '—',
                icon: Icons.drafts_outlined,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // License Status
          _StatusCard(
            title: 'حالة الترخيص',
            status: user?.guardian?.licenseStatus ?? 'غير محدد',
          ),
          const SizedBox(height: 12),
          _StatusCard(
            title: 'حالة البطاقة',
            status: user?.guardian?.cardStatus ?? 'غير محدد',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                Text(
                  value,
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String status;

  const _StatusCard({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: GoogleFonts.tajawal(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
