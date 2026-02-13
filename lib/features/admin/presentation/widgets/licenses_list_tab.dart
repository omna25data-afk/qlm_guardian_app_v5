import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_licenses_provider.dart';
import '../../data/models/admin_renewal_model.dart';

class LicensesListTab extends ConsumerStatefulWidget {
  const LicensesListTab({super.key});

  @override
  ConsumerState<LicensesListTab> createState() => _LicensesListTabState();
}

class _LicensesListTabState extends ConsumerState<LicensesListTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminLicensesProvider.notifier).fetchLicenses(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminLicensesProvider);

    return Column(
      children: [
        // List
        Expanded(
          child: state.isLoading && state.licenses.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.error != null && state.licenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(adminLicensesProvider.notifier)
                            .fetchLicenses(refresh: true),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : state.licenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 60,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد رخص',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!state.isLoading &&
                        state.hasMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      ref.read(adminLicensesProvider.notifier).fetchLicenses();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => ref
                        .read(adminLicensesProvider.notifier)
                        .fetchLicenses(refresh: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount:
                          state.licenses.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.licenses.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final license = state.licenses[index];
                        return _buildLicenseCard(context, license);
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildLicenseCard(BuildContext context, AdminRenewalModel license) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    license.guardianName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(
                  license.status,
                  _getStatusColor(license.statusColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.badge_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'رقم الرخصة: ${license.id}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${license.renewalDate}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            if (license.type.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    license.type,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'green':
      case 'success':
        return AppColors.success;
      case 'red':
      case 'error':
      case 'danger':
        return AppColors.error;
      case 'orange':
      case 'warning':
        return AppColors.warning;
      case 'blue':
      case 'info':
        return AppColors.info;
      default:
        return AppColors.textHint;
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
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
}
