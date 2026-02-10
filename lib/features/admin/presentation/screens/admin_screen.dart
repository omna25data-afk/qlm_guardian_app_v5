import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Admin panel home screen — accessible only by رئيس القلم
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة إدارة القلم')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإدارة',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildAdminCard(
                    context,
                    icon: Icons.people_outline,
                    title: 'إدارة الأمناء',
                    subtitle: 'عرض وتعديل بيانات الأمناء',
                    onTap: () {
                      // TODO: Navigate to guardians management
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.book_outlined,
                    title: 'إدارة السجلات',
                    subtitle: 'تعيين ومراجعة السجلات',
                    onTap: () {
                      // TODO: Navigate to records management
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'التقارير',
                    subtitle: 'إحصائيات وتقارير شاملة',
                    onTap: () {
                      // TODO: Navigate to reports
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'الإعدادات',
                    subtitle: 'إعدادات النظام',
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
