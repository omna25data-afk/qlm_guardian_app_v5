import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/records/presentation/providers/records_provider.dart';
import '../../../features/registry/presentation/screens/entries_list_screen.dart';
import '../../../features/registry/presentation/screens/add_registry_entry_screen.dart';

/// تبويب أدوات الأمين الشرعي
class GuardianToolsTab extends ConsumerWidget {
  const GuardianToolsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'أدوات الأمين',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'أدوات سريعة لمساعدتك في أعمالك اليومية',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          _buildSectionHeader('إجراءات سريعة'),
          const SizedBox(height: 12),
          _buildToolCard(
            context,
            icon: Icons.add_circle_outline,
            title: 'إضافة قيد جديد',
            subtitle: 'إنشاء قيد جديد في السجل',
            color: AppColors.statGreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddRegistryEntryScreen(),
                ),
              );
            },
          ),
          _buildToolCard(
            context,
            icon: Icons.search,
            title: 'البحث في القيود',
            subtitle: 'بحث سريع في قيودك المسجلة',
            color: AppColors.statBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EntriesListScreen()),
              );
            },
          ),

          const SizedBox(height: 24),

          // Registry tools
          _buildSectionHeader('أدوات السجلات'),
          const SizedBox(height: 12),
          _buildToolCard(
            context,
            icon: Icons.sync,
            title: 'مزامنة البيانات',
            subtitle: 'مزامنة آخر التحديثات من الخادم',
            color: AppColors.statIndigo,
            onTap: () {
              // Refresh records data
              ref.read(recordBooksProvider.notifier).fetchRecordBooks();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'جاري المزامنة...',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  backgroundColor: AppColors.info,
                ),
              );
            },
          ),
          _buildToolCard(
            context,
            icon: Icons.calculate_outlined,
            title: 'حاسبة الرسوم',
            subtitle: 'حساب رسوم التوثيق حسب نوع العقد',
            color: AppColors.statAmber,
            onTap: () => _showFeeCalculator(context),
          ),

          const SizedBox(height: 24),

          // Support
          _buildSectionHeader('الدعم والمساعدة'),
          const SizedBox(height: 12),
          _buildToolCard(
            context,
            icon: Icons.help_outline,
            title: 'دليل الاستخدام',
            subtitle: 'تعلّم كيفية استخدام التطبيق',
            color: Colors.teal,
            onTap: () => _showUsageGuide(context),
          ),
          _buildToolCard(
            context,
            icon: Icons.info_outline,
            title: 'حول التطبيق',
            subtitle: 'معلومات الإصدار والتراخيص',
            color: Colors.blueGrey,
            onTap: () => _showAboutDialog(context),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF006400),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
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

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeeCalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'حاسبة الرسوم',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 16),
            _buildFeeRow('توثيق عقد زواج', '750 ر.س'),
            _buildFeeRow('توثيق عقد طلاق', '500 ر.س'),
            _buildFeeRow('توثيق رجعة', '350 ر.س'),
            _buildFeeRow('توثيق خلع', '500 ر.س'),
            _buildFeeRow('إثبات حالة', '400 ر.س'),
            const SizedBox(height: 16),
            Text(
              '* الرسوم تقريبية وقد تختلف حسب المنطقة',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(String label, String fee) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontFamily: 'Tajawal')),
          Text(
            fee,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006400),
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  void _showUsageGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'دليل الاستخدام',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildGuideStep(
                '1',
                'إضافة قيد جديد',
                'اضغط على زر "+" أسفل الشاشة لإنشاء قيد جديد. اختر نوع العقد ثم أدخل البيانات المطلوبة.',
              ),
              _buildGuideStep(
                '2',
                'مراجعة السجلات',
                'من تبويب "سجلاتي" يمكنك الاطلاع على جميع سجلاتك ودفاتر القيود.',
              ),
              _buildGuideStep(
                '3',
                'متابعة الحالة',
                'لوحة الرئيسية تعرض حالة الترخيص والبطاقة وإحصائيات القيود.',
              ),
              _buildGuideStep(
                '4',
                'المزامنة',
                'اضغط على أيقونة المزامنة في أعلى الشاشة لتحديث البيانات.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF006400),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'بوابة الأمين الشرعي',
        applicationVersion: 'الإصدار 5.0.0',
        applicationIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF006400).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.gavel, color: Color(0xFF006400), size: 40),
        ),
        children: [
          Text(
            'تطبيق بوابة الأمين الشرعي لإدارة القيود والسجلات والتوثيق.',
            style: TextStyle(fontSize: 13, fontFamily: 'Tajawal'),
          ),
        ],
      ),
    );
  }
}
