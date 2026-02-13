import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../features/admin/presentation/providers/reports_provider.dart';

/// التقارير — إحصائية ومالية وأداء
class ReportsTab extends ConsumerStatefulWidget {
  const ReportsTab({super.key});

  @override
  ConsumerState<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends ConsumerState<ReportsTab> {
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(reportsProvider.notifier);
      notifier.loadYears();
      notifier.loadGuardianStats();
      notifier.loadEntriesStats();
      notifier.loadContractTypesSummary();
    });
  }

  void _onYearChanged(int? year) {
    setState(() => _selectedYear = year);
    final notifier = ref.read(reportsProvider.notifier);
    notifier.loadGuardianStats(year: year);
    notifier.loadEntriesStats(year: year);
    notifier.loadContractTypesSummary(year: year);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportsProvider);

    if (state.isLoading &&
        state.guardianStats == null &&
        state.entriesStats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null &&
        state.guardianStats == null &&
        state.entriesStats == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(state.error!, style: TextStyle(fontFamily: 'Tajawal')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(reportsProvider.notifier);
                notifier.loadYears();
                notifier.loadGuardianStats();
                notifier.loadEntriesStats();
                notifier.loadContractTypesSummary();
              },
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final notifier = ref.read(reportsProvider.notifier);
        await notifier.loadGuardianStats(year: _selectedYear);
        await notifier.loadEntriesStats(year: _selectedYear);
        await notifier.loadContractTypesSummary(year: _selectedYear);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year filter
            if (state.years.isNotEmpty) ...[
              _buildYearFilter(state.years),
              const SizedBox(height: 20),
            ],

            // Guardian Statistics
            if (state.guardianStats != null)
              _buildGuardianStatsSection(state.guardianStats!),
            const SizedBox(height: 20),

            // Entries Statistics
            if (state.entriesStats != null)
              _buildEntriesStatsSection(state.entriesStats!),
            const SizedBox(height: 20),

            // Contract Types Summary
            if (state.contractTypesSummary != null)
              _buildContractTypesSummarySection(state.contractTypesSummary!),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildYearFilter(List<int> years) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Text(
            'السنة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<int?>(
              value: _selectedYear,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              hint: Text(
                'الكل',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontFamily: 'Tajawal',
                ),
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text('الكل', style: TextStyle(fontFamily: 'Tajawal')),
                ),
                ...years.map(
                  (y) => DropdownMenuItem<int?>(
                    value: y,
                    child: Text('$y', style: TextStyle(fontFamily: 'Tajawal')),
                  ),
                ),
              ],
              onChanged: _onYearChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 10),
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

  Widget _buildGuardianStatsSection(Map<String, dynamic> stats) {
    final total = stats['total'] ?? 0;
    final active = stats['active'] ?? 0;
    final inactive = stats['inactive'] ?? 0;
    final expiredLicense = stats['expired_license'] ?? 0;
    final expiredCard = stats['expired_card'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('إحصائيات الأمناء', Icons.people),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            StatCard(
              title: 'إجمالي الأمناء',
              count: '$total',
              icon: Icons.people,
              iconColor: AppColors.primary,
            ),
            StatCard(
              title: 'نشط',
              count: '$active',
              icon: Icons.check_circle,
              iconColor: AppColors.success,
            ),
            StatCard(
              title: 'متوقف',
              count: '$inactive',
              icon: Icons.pause_circle,
              iconColor: AppColors.error,
            ),
            StatCard(
              title: 'ترخيص منتهي',
              count: '$expiredLicense',
              icon: Icons.warning,
              iconColor: AppColors.warning,
            ),
            StatCard(
              title: 'بطاقة منتهية',
              count: '$expiredCard',
              icon: Icons.credit_card_off,
              iconColor: Colors.deepOrange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEntriesStatsSection(Map<String, dynamic> stats) {
    final total = stats['total'] ?? 0;
    final documented = stats['documented'] ?? 0;
    final draft = stats['draft'] ?? 0;
    final pending = stats['pending_documentation'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('إحصائيات القيود', Icons.list_alt),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            StatCard(
              title: 'إجمالي القيود',
              count: '$total',
              icon: Icons.list_alt,
              iconColor: AppColors.primary,
            ),
            StatCard(
              title: 'موثّق',
              count: '$documented',
              icon: Icons.verified,
              iconColor: AppColors.success,
            ),
            StatCard(
              title: 'مسودة',
              count: '$draft',
              icon: Icons.edit_note,
              iconColor: AppColors.warning,
            ),
            StatCard(
              title: 'بانتظار التوثيق',
              count: '$pending',
              icon: Icons.pending_actions,
              iconColor: AppColors.info,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContractTypesSummarySection(Map<String, dynamic> summary) {
    final types = summary['data'] as List? ?? [];

    if (types.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ملخص أنواع العقود', Icons.category),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: types.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.border.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              final type = types[index] as Map<String, dynamic>;
              final name = type['name'] ?? 'غير محدد';
              final count = type['count'] ?? 0;
              final percentage = type['percentage'];

              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTypeColor(index).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(index),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                title: Text(
                  name.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    if (percentage != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.info,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.error,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}
