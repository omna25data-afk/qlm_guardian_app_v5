import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// الأدوات والإعدادات — للمشرف
class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'الأدوات والإعدادات',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم إضافة أدوات النظام والإعدادات',
            style: GoogleFonts.tajawal(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
