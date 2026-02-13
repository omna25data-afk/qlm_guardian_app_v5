import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/dashboard/data/models/dashboard_data.dart';
import '../../../features/dashboard/presentation/providers/dashboard_provider.dart';

/// لوحة الرئيسية للأمين الشرعي — مربوطة بـ API
class GuardianDashboardTab extends ConsumerWidget {
  const GuardianDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final dashboardState = ref.watch(dashboardProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardProvider.notifier).fetchDashboard(),
      child: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorView(ref, error),
        data: (dashboard) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWelcomeCard(
              user?.guardian?.fullName ?? user?.name ?? 'الأمين الشرعي',
              dashboard,
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('إحصائياتي', Icons.bar_chart),
            const SizedBox(height: 12),
            _buildStatsGrid(dashboard.stats),
            const SizedBox(height: 20),
            _buildSectionHeader('حالة الترخيص والبطاقة', Icons.verified_user),
            const SizedBox(height: 12),
            _buildStatusCard(
              'حالة الترخيص',
              Icons.card_membership,
              dashboard.licenseStatus,
            ),
            const SizedBox(height: 12),
            _buildStatusCard(
              'حالة البطاقة',
              Icons.credit_card,
              dashboard.cardStatus,
            ),
            if (dashboard.recentActivities.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionHeader('آخر النشاطات', Icons.history),
              const SizedBox(height: 12),
              ...dashboard.recentActivities
                  .take(5)
                  .map((entry) => _buildActivityItem(entry)),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل البيانات',
            style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () =>
                ref.read(dashboardProvider.notifier).fetchDashboard(),
            icon: const Icon(Icons.refresh),
            label: Text(
              'إعادة المحاولة',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String name, DashboardData dashboard) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF006400), Color(0xFF228B22)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006400).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mosque, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dashboard.welcomeMessage.isNotEmpty
                      ? dashboard.welcomeMessage
                      : 'مرحباً بك',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          if (dashboard.dateHijri.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${dashboard.dateHijri}  •  ${dashboard.dateGregorian}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white60,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
          if (dashboard.unreadNotifications > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${dashboard.unreadNotifications} إشعار جديد',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _StatCard(
          title: 'إجمالي القيود',
          value: '${stats.totalEntries}',
          icon: Icons.description,
          color: AppColors.statBlue,
        ),
        _StatCard(
          title: 'الموثقة',
          value: '${stats.documentedEntries}',
          icon: Icons.check_circle,
          color: AppColors.statGreen,
        ),
        _StatCard(
          title: 'بانتظار التوثيق',
          value: '${stats.pendingDocumentationEntries}',
          icon: Icons.hourglass_empty,
          color: AppColors.statAmber,
        ),
        _StatCard(
          title: 'هذا الشهر',
          value: '${stats.thisMonthEntries}',
          icon: Icons.calendar_month,
          color: AppColors.statIndigo,
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, IconData icon, RenewalStatus status) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: status.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: status.color,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            if (status.daysRemaining != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${status.daysRemaining} يوم',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: status.color,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(dynamic entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.description,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          entry.subject ?? 'قيد',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Text(
          entry.contractTypeName ?? '',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Tajawal',
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey[400],
        ),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}
