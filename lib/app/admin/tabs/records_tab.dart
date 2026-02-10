import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// السجلات والقيود — عرض شامل لكل السجلات مع فلترة متقدمة
class RecordsTab extends StatelessWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.source_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'السجلات والقيود',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم إضافة قوائم السجلات والقيود مع فلترة متقدمة',
            style: GoogleFonts.tajawal(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
