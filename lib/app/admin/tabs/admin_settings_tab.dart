import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/debug/presentation/screens/debug_screen.dart';

/// الأدوات والإعدادات — للمشرف
class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('أدوات النظام'),
        const SizedBox(height: 12),
        _buildSettingsTile(
          context,
          icon: Icons.network_check,
          title: 'مصحح الاتصال',
          subtitle: 'اختبار الاتصال بالخادم ونقاط النهاية',
          color: AppColors.info,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DebugScreen()),
          ),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.storage,
          title: 'قاعدة البيانات المحلية',
          subtitle: 'إدارة البيانات المخزنة محلياً',
          color: AppColors.warning,
          onTap: () {},
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('الإعدادات'),
        const SizedBox(height: 12),
        _buildSettingsTile(
          context,
          icon: Icons.notifications_outlined,
          title: 'الإشعارات',
          subtitle: 'إعدادات الإشعارات والتنبيهات',
          color: AppColors.primary,
          onTap: () {},
        ),
        _buildSettingsTile(
          context,
          icon: Icons.info_outline,
          title: 'حول التطبيق',
          subtitle: 'معلومات الإصدار والتطوير',
          color: AppColors.success,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.tajawal(color: AppColors.textHint, fontSize: 12),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textHint,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
