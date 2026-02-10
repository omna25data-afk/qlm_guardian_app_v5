import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// التقارير — إحصائية ومالية وأداء
class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'التقارير',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم إضافة التقارير الإحصائية والمالية',
            style: GoogleFonts.tajawal(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
