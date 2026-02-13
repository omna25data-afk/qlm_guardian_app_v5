import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_edit_guardian_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_guardian_model.dart';
import '../widgets/renew_card_sheet.dart';
import '../widgets/renew_license_sheet.dart';
import 'guardian_renewals_screen.dart';

class GuardianDetailsScreen extends ConsumerWidget {
  final AdminGuardianModel guardian;

  const GuardianDetailsScreen({super.key, required this.guardian});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isActive = guardian.employmentStatus == 'على رأس العمل';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'تعديل البيانات',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditGuardianScreen(guardian: guardian),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                tooltip: 'سجل التجديدات',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GuardianRenewalsScreen(guardian: guardian),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar
                      Hero(
                        tag: 'guardian_${guardian.id}',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withValues(alpha: 0.2),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: guardian.photoUrl != null
                                ? NetworkImage(guardian.photoUrl!)
                                : null,
                            child: guardian.photoUrl == null
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Name
                      Text(
                        guardian.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      // Serial & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              guardian.serialNumber,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.success
                                  : AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isActive ? 'نشط' : 'متوقف',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Quick Actions
                  _buildQuickActionsRow(context),
                  const SizedBox(height: 16),

                  // Info Sections
                  _buildSection(
                    context,
                    title: 'المعلومات الشخصية',
                    icon: Icons.person_outline,
                    children: [
                      _buildGridItem(
                        'الاسم الكامل',
                        guardian.name,
                        isFullWidth: true,
                      ),
                      _buildGridItem(
                        'تاريخ الميلاد',
                        guardian.birthDate ?? 'غير محدد',
                      ),
                      _buildGridItem(
                        'مكان الميلاد',
                        guardian.birthPlace ?? 'غير محدد',
                      ),
                      _buildGridItem(
                        'هاتف المنزل',
                        guardian.homePhone ?? 'غير محدد',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSection(
                    context,
                    title: 'الهوية والسكن',
                    icon: Icons.badge_outlined,
                    children: [
                      _buildGridItem(
                        'نوع الإثبات',
                        guardian.proofType ?? 'غير محدد',
                      ),
                      _buildGridItem(
                        'رقم الإثبات',
                        guardian.proofNumber ?? 'غير محدد',
                        isCopyable: true,
                      ),
                      _buildGridItem(
                        'جهة الإصدار',
                        guardian.issuingAuthority ?? 'غير محدد',
                      ),
                      _buildGridItem(
                        'تاريخ الإصدار',
                        guardian.issueDate ?? 'غير محدد',
                      ),
                      _buildGridItem(
                        'تاريخ الانتهاء',
                        guardian.expiryDate ?? 'غير محدد',
                        color: guardian.identityStatusColor,
                        makeBold: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSection(
                    context,
                    title: 'المهنة والترخيص',
                    icon: Icons.work_outline,
                    children: [
                      _buildGridItem(
                        'المؤهل العلمي',
                        guardian.qualification ?? 'غير محدد',
                      ),
                      _buildGridItem('الوظيفة', guardian.job ?? 'غير محدد'),

                      _buildSectionDivider(
                        context,
                        'الترخيص',
                        onRenew: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) =>
                                RenewLicenseSheet(guardian: guardian),
                          );
                        },
                      ),

                      _buildGridItem(
                        'رقم الترخيص',
                        guardian.licenseNumber ?? 'غير محدد',
                        isCopyable: true,
                      ),
                      _buildGridItem(
                        'تاريخ انتهائه',
                        guardian.licenseExpiryDate ?? 'غير محدد',
                        color: guardian.licenseStatusColor,
                        makeBold: true,
                      ),

                      _buildSectionDivider(
                        context,
                        'بطاقة المهنة',
                        onRenew: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => RenewCardSheet(guardian: guardian),
                          );
                        },
                      ),

                      _buildGridItem(
                        'رقم البطاقة',
                        guardian.professionCardNumber ?? 'غير محدد',
                        isCopyable: true,
                      ),
                      _buildGridItem(
                        'تاريخ انتهائها',
                        guardian.professionCardExpiryDate ?? 'غير محدد',
                        color: guardian.cardStatusColor,
                        makeBold: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSection(
                    context,
                    title: 'المواقع والحالة',
                    icon: Icons.map_outlined,
                    children: [
                      _buildGridItem(
                        'عزلة الاختصاص',
                        guardian.mainDistrictName ?? 'غير محدد',
                        isFullWidth: true,
                      ),
                      _buildGridItem(
                        'الحالة الوظيفية',
                        guardian.employmentStatus ?? 'غير محدد',
                        color: _parseColor(guardian.employmentStatusColor),
                        makeBold: true,
                      ),
                      if (guardian.notes != null)
                        _buildGridItem(
                          'ملاحظات',
                          guardian.notes,
                          isFullWidth: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        if (guardian.phone != null)
          Expanded(
            child: _buildQuickActionButton(
              context,
              icon: Icons.phone,
              label: 'اتصال',
              color: AppColors.success,
              onTap: () => launchUrl(Uri.parse('tel:${guardian.phone}')),
            ),
          ),
        if (guardian.phone != null) const SizedBox(width: 10),
        Expanded(
          child: _buildQuickActionButton(
            context,
            icon: Icons.refresh,
            label: 'سجل التجديدات',
            color: AppColors.warning,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GuardianRenewalsScreen(guardian: guardian),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildQuickActionButton(
            context,
            icon: Icons.message,
            label: 'واتساب',
            color: Colors.teal,
            onTap: () =>
                launchUrl(Uri.parse('https://wa.me/${guardian.phone}')),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
          ),
          const SizedBox(height: 20),
          Wrap(spacing: 16, runSpacing: 16, children: children),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(
    BuildContext context,
    String label, {
    VoidCallback? onRenew,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
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
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
              fontFamily: 'Tajawal',
            ),
          ),
          const Spacer(),
          if (onRenew != null)
            TextButton.icon(
              onPressed: onRenew,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(
                Icons.refresh,
                size: 16,
                color: AppColors.warning,
              ),
              label: Text(
                'تجديد',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    String label,
    String? value, {
    bool isFullWidth = false,
    bool isCopyable = false,
    Color? color,
    bool makeBold = false,
  }) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: isFullWidth ? double.infinity : 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 13,
              fontWeight: makeBold ? FontWeight.bold : FontWeight.w500,
              height: 1.4,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'red':
      case 'danger':
        return AppColors.error;
      case 'orange':
      case 'warning':
        return AppColors.warning;
      case 'green':
      case 'success':
        return AppColors.success;
      case 'blue':
      case 'primary':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}
