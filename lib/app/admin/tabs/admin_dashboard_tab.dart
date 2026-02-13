import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_tab_bar.dart';
import '../../../features/admin/data/models/admin_dashboard_data.dart';
import '../../../features/admin/presentation/providers/admin_dashboard_provider.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

/// لوحة تحكم رئيس القلم — إحصائيات شاملة (تم نقلها من v4)
class AdminDashboardTab extends ConsumerStatefulWidget {
  const AdminDashboardTab({super.key});

  @override
  ConsumerState<AdminDashboardTab> createState() => _AdminDashboardTabState();
}

class _AdminDashboardTabState extends ConsumerState<AdminDashboardTab>
    with SingleTickerProviderStateMixin {
  late TabController _guardianStatsController;

  @override
  void initState() {
    super.initState();
    _guardianStatsController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _guardianStatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return dashboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ أثناء تحميل البيانات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(adminDashboardProvider.notifier).fetchDashboard(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () =>
            ref.read(adminDashboardProvider.notifier).fetchDashboard(),
        color: AppColors.primary,
        child: Container(
          color: Colors.grey[50],
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Welcome Card (Keep v5 style but enhanced)
              _buildWelcomeCard(user?.name),
              const SizedBox(height: 24),

              // 2. Summary
              _buildSectionHeader('ملخص النظام', Icons.analytics),
              const SizedBox(height: 12),
              _buildSummaryCards(),

              const SizedBox(height: 24),

              // 3. Urgent Actions
              _buildSectionHeader(
                'الإجراءات العاجلة ⚠️',
                Icons.notification_important,
                color: AppColors.error,
              ),
              const SizedBox(height: 12),
              _buildUrgentActionsList(data.urgentActions),

              const SizedBox(height: 24),

              // 4. Guardians Data with Custom Tab Bar
              _buildSectionHeader('بيانات الأمناء والتراخيص', Icons.people),
              const SizedBox(height: 12),
              _buildGuardiansStatsSection(data.stats),

              const SizedBox(height: 24),

              // 5. Logs
              _buildSectionHeader('آخر العمليات', Icons.history),
              const SizedBox(height: 12),
              _buildLogsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(String? name) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً، ${name ?? "الرئيس"}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'رئيس قلم التوثيق',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon, {
    Color color = AppColors.primary,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return SizedBox(
      height: 140,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pie_chart,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'مساحة للرسوم البيانية التفاعلية',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentActionsList(List<UrgentAction> actions) {
    if (actions.isEmpty) {
      return Card(
        elevation: 0,
        color: AppColors.success.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.success.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لا توجد إجراءات عاجلة',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      'جميع الأمور تسير بشكل جيد',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: actions
          .map(
            (action) => Card(
              elevation: 0,
              color: action.color.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: action.color.withValues(alpha: 0.2)),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: action.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: action.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            action.subtitle,
                            style: TextStyle(
                              color: action.color,
                              fontSize: 12,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: action.color,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: action.color.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Text(
                              action.actionLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGuardiansStatsSection(AdminStats stats) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: CustomSegmentedTabBar(
              controller: _guardianStatsController,
              tabs: const ['الأمناء', 'التراخيص', 'البطائق'],
              activeColor: AppColors.primary,
            ),
          ),
          SizedBox(
            height: 280,
            child: TabBarView(
              controller: _guardianStatsController,
              children: [
                _buildGridStats([
                  _StatItem(
                    'إجمالي الأمناء',
                    stats.guardians.total.toString(),
                    AppColors.statBlue,
                    Icons.group,
                  ),
                  _StatItem(
                    'على رأس العمل',
                    stats.guardians.active.toString(),
                    AppColors.statGreen,
                    Icons.work,
                  ),
                  _StatItem(
                    'متوقف عن العمل',
                    stats.guardians.inactive.toString(),
                    AppColors.statRed,
                    Icons.cancel,
                  ),
                  _StatItem(
                    'قيد المراجعة',
                    '0',
                    AppColors.statOrange,
                    Icons.help_outline,
                  ),
                ]),
                _buildGridStats([
                  _StatItem(
                    'إجمالي التراخيص',
                    stats.licenses.total.toString(),
                    AppColors.statIndigo,
                    Icons.card_membership,
                  ),
                  _StatItem(
                    'سارية',
                    stats.licenses.active.toString(),
                    AppColors.statGreen,
                    Icons.check_circle,
                  ),
                  _StatItem(
                    'تنتهي قريباً',
                    stats.licenses.warning.toString(),
                    AppColors.statAmber,
                    Icons.warning,
                  ),
                  _StatItem(
                    'منتهية',
                    stats.licenses.inactive.toString(),
                    AppColors.statRed,
                    Icons.error,
                  ),
                ]),
                _buildGridStats([
                  _StatItem(
                    'إجمالي البطائق',
                    stats.cards.total.toString(),
                    AppColors.statTeal,
                    Icons.badge,
                  ),
                  _StatItem(
                    'سارية',
                    stats.cards.active.toString(),
                    AppColors.statGreen,
                    Icons.check_circle,
                  ),
                  _StatItem(
                    'تنتهي قريباً',
                    stats.cards.warning.toString(),
                    AppColors.statAmber,
                    Icons.warning,
                  ),
                  _StatItem(
                    'منتهية',
                    stats.cards.inactive.toString(),
                    AppColors.statRed,
                    Icons.error,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridStats(List<_StatItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.35,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.color.withValues(alpha: 0.08),
                item.color.withValues(alpha: 0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: item.color.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 24, color: item.color),
              ),
              const SizedBox(height: 10),
              Text(
                item.value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: item.color,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogsSection() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return CustomInlineTabBar(
                  controller: DefaultTabController.of(context),
                  tabs: const ['عملياتي (Admin)', 'عمليات الأمناء'],
                  indicatorColor: AppColors.primary,
                );
              },
            ),
            SizedBox(
              height: 200,
              child: TabBarView(
                children: [
                  _buildLogPlaceholder(
                    'لا توجد عمليات مسجلة حالياً',
                    Icons.admin_panel_settings,
                  ),
                  _buildLogPlaceholder('لا توجد سجلات حالياً', Icons.history),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogPlaceholder(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500], fontFamily: 'Tajawal'),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  _StatItem(this.title, this.value, this.color, this.icon);
}
