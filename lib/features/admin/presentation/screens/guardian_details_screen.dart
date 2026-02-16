import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_edit_guardian_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_guardian_model.dart';
import '../widgets/renew_card_sheet.dart';
import '../widgets/renew_license_sheet.dart';
import 'guardian_renewals_screen.dart';
import '../providers/guardian_inspections_provider.dart';

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
                        tag: 'guardian_details_${guardian.id}',
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
                              '#م ${guardian.serialNumber ?? '---'}',
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
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: _buildCircularStatusItem(
                          label: 'صلاحية الهوية',
                          days: guardian.identityDays,
                          color: guardian.identityStatusColor,
                        ),
                      ),
                      const SizedBox(height: 20, width: double.infinity),
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

                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: _buildCircularStatusItem(
                          label: 'صلاحية الترخيص',
                          days: guardian.licenseDays,
                          color: guardian.licenseStatusColor,
                        ),
                      ),
                      const SizedBox(height: 16, width: double.infinity),

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

                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: _buildCircularStatusItem(
                          label: 'صلاحية البطاقة',
                          days: guardian.cardDays,
                          color: guardian.cardStatusColor,
                        ),
                      ),
                      const SizedBox(height: 16, width: double.infinity),

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
                  const SizedBox(height: 16),

                  // Geographic Areas (Jurisdiction)
                  if ((guardian.villages != null &&
                          guardian.villages!.isNotEmpty) ||
                      (guardian.localities != null &&
                          guardian.localities!.isNotEmpty))
                    _buildSection(
                      context,
                      title: 'المناطق الجغرافية (الاختصاص)',
                      icon: Icons.location_on_outlined,
                      children: [
                        if (guardian.villages != null &&
                            guardian.villages!.isNotEmpty)
                          _buildAreaGroup(
                            'القرى',
                            guardian.villages!.map((e) => e.name).toList(),
                            AppColors.info,
                          ),
                        if (guardian.localities != null &&
                            guardian.localities!.isNotEmpty)
                          _buildAreaGroup(
                            'المحلات',
                            guardian.localities!.map((e) => e.name).toList(),
                            AppColors.success,
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  _buildInspectionsSection(context, ref),

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

  Widget _buildCircularStatusItem({
    required String label,
    required int? days,
    required Color color,
  }) {
    final String dayText = days == null
        ? '---'
        : (days < 0 ? 'منتهي' : '$days يوم');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 4),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days == null ? '?' : days.toString(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      fontFamily: 'Tajawal',
                      height: 1,
                    ),
                  ),
                  const Text(
                    'يوم',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          dayText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
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

  Widget _buildAreaGroup(String label, List<String> items, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withValues(alpha: 0.8),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInspectionsSection(BuildContext context, WidgetRef ref) {
    // Trigger fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(guardianInspectionsProvider.notifier)
          .fetchInspections(guardian.id);
    });

    final state = ref.watch(guardianInspectionsProvider);
    final inspections = state.inspectionsByGuardian[guardian.id] ?? [];

    return _buildSection(
      context,
      title: 'عمليات التفتيش',
      icon: Icons.fact_check_outlined,
      children: [
        if (state.isLoading && inspections.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (state.error != null && inspections.isEmpty)
          Center(
            child: Text(
              'خطأ في تحميل التفتيشات',
              style: TextStyle(color: AppColors.error, fontFamily: 'Tajawal'),
            ),
          )
        else if (inspections.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'لا توجد عمليات تفتيش مسجلة',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey),
              ),
            ),
          )
        else
          ...inspections.map((insp) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تفتيش بتاريخ: ${insp['date'] ?? '---'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      _buildStatusBadge(
                        insp['status_label'] ?? '---',
                        _parseColor(insp['status_color']),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insp['notes'] ?? 'لا توجد ملاحظات',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Color _parseColor(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'red':
      case 'danger':
      case 'error':
        return AppColors.error;
      case 'orange':
      case 'warning':
        return AppColors.warning;
      case 'green':
      case 'success':
        return AppColors.success;
      case 'blue':
      case 'info':
      case 'primary':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}
