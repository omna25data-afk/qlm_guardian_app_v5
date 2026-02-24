import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/admin_guardian_model.dart';
import '../../widgets/guardians/guardian_details_section.dart';
import '../../widgets/guardians/guardian_info_grid_item.dart';

class GuardianDetailsScreen extends StatelessWidget {
  final AdminGuardianModel guardian;

  const GuardianDetailsScreen({super.key, required this.guardian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الأمين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: Navigate to Edit screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. المعلومات الشخصية الأساسية
            GuardianDetailsSection(
              title: 'المعلومات الشخصية الأساسية',
              icon: Icons.person_outline,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.badge_outlined,
                    label: 'الاسم الكامل',
                    value: guardian.shortName,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.numbers,
                    label: 'الرقم التسلسلي',
                    value: guardian.serialNumber ?? 'غير محدد',
                    isCopyable: true,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الميلاد',
                    value: guardian.birthDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.cake_outlined,
                    label: 'العمر',
                    value: _calculateAge(guardian.birthDate),
                  ),
                ],
              ),
            ),

            // 2. معلومات الاتصال
            GuardianDetailsSection(
              title: 'معلومات الاتصال',
              icon: Icons.phone_outlined,
              initiallyExpanded: false,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.smartphone_outlined,
                    label: 'رقم الهاتف',
                    value: guardian.phone ?? 'غير محدد',
                    isCopyable: true,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.home_outlined,
                    label: 'هاتف المنزل',
                    value: guardian.homePhone ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.location_on_outlined,
                    label: 'محل الميلاد والإقامة',
                    value:
                        '${guardian.birthPlace ?? ''} - ${guardian.mainDistrictName ?? ''}'
                            .trim()
                            .replaceAll(RegExp(r'^-|-$'), ''),
                  ),
                ],
              ),
            ),

            // 3. بيانات إثبات الشخصية
            GuardianDetailsSection(
              title: 'بيانات إثبات الشخصية',
              icon: Icons.assignment_ind_outlined,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.credit_card_outlined,
                    label: 'نوع الإثبات',
                    value: guardian.proofType ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.numbers,
                    label: 'رقم الإثبات',
                    value: guardian.proofNumber ?? 'غير محدد',
                    isCopyable: true,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الإصدار',
                    value: guardian.issueDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.event_busy_outlined,
                    label: 'تاريخ الانتهاء',
                    value: guardian.expiryDate ?? 'غير محدد',
                    valueColor: guardian.identityStatusColor,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.account_balance_outlined,
                    label: 'جهة الإصدار',
                    value: guardian.issuingAuthority ?? 'غير محدد',
                  ),
                ],
              ),
            ),

            // 4. البيانات المهنية
            GuardianDetailsSection(
              title: 'البيانات المهنية',
              icon: Icons.work_outline,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.school_outlined,
                    label: 'المؤهل',
                    value: guardian.qualification ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.business_center_outlined,
                    label: 'المهنة',
                    value: guardian.job ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.corporate_fare_outlined,
                    label: 'جهة العمل',
                    value: guardian.workplace ?? 'غير محدد',
                  ),
                ],
              ),
            ),

            // 5. القرار الوزاري والترخيص
            GuardianDetailsSection(
              title: 'القرار الوزاري والترخيص',
              icon: Icons.verified_user_outlined,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.gavel_outlined,
                    label: 'رقم القرار الوزاري',
                    value: guardian.ministerialDecisionNumber ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ القرار الوزاري',
                    value: guardian.ministerialDecisionDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.card_membership_outlined,
                    label: 'رقم الترخيص',
                    value: guardian.licenseNumber ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.event_busy_outlined,
                    label: 'انتهاء الترخيص',
                    value: guardian.licenseExpiryDate ?? 'غير محدد',
                    valueColor: guardian.licenseStatusColor,
                  ),
                ],
              ),
            ),

            // 6. بطاقة المهنة
            GuardianDetailsSection(
              title: 'بطاقة المهنة',
              icon: Icons.badge_outlined,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.numbers,
                    label: 'رقم البطاقة',
                    value: guardian.professionCardNumber ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.event_busy_outlined,
                    label: 'تاريخ الانتهاء',
                    value: guardian.professionCardExpiryDate ?? 'غير محدد',
                    valueColor: guardian.cardStatusColor,
                  ),
                ],
              ),
            ),

            // 7. مناطق الاختصاص
            GuardianDetailsSection(
              title: 'مناطق الاختصاص',
              icon: Icons.map_outlined,
              child: Column(
                children: [
                  GuardianInfoGridItem(
                    icon: Icons.push_pin_outlined,
                    label: 'العزلة الرئيسية',
                    value: guardian.mainDistrictName ?? 'غير محدد',
                  ),
                  const SizedBox(height: 16),
                  GuardianInfoGridItem(
                    icon: Icons.location_city_outlined,
                    label: 'القرى',
                    value:
                        guardian.villages?.map((e) => e.name).join('، ') ??
                        'لا توجد قرى مخصصة',
                  ),
                  const SizedBox(height: 16),
                  GuardianInfoGridItem(
                    icon: Icons.home_work_outlined,
                    label: 'المحلات',
                    value:
                        guardian.localities?.map((e) => e.name).join('، ') ??
                        'لا توجد محلات مخصصة',
                  ),
                ],
              ),
            ),

            // 8. الحالة الوظيفية
            GuardianDetailsSection(
              title: 'الحالة الوظيفية',
              icon: Icons.assignment_turned_in_outlined,
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: [
                      GuardianInfoGridItem(
                        icon: guardian.employmentStatus == 'على رأس العمل'
                            ? Icons.check_circle
                            : Icons.cancel,
                        label: 'حالة العمل',
                        value: guardian.employmentStatus ?? 'غير محدد',
                        valueColor: guardian.employmentStatus == 'على رأس العمل'
                            ? AppColors.success
                            : AppColors.error,
                        iconColor: guardian.employmentStatus == 'على رأس العمل'
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ],
                  ),
                  if (guardian.stopDate != null ||
                      guardian.stopReason != null) ...[
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        GuardianInfoGridItem(
                          icon: Icons.warning_amber_rounded,
                          label: 'سبب الإيقاف',
                          value: guardian.stopReason ?? 'غير محدد',
                          valueColor: AppColors.error,
                        ),
                        GuardianInfoGridItem(
                          icon: Icons.event_busy_outlined,
                          label: 'تاريخ الإيقاف',
                          value: guardian.stopDate ?? 'غير محدد',
                          valueColor: AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAge(String? birthDateStr) {
    if (birthDateStr == null) return 'غير محدد';
    try {
      final dob = DateTime.parse(birthDateStr);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age سنة';
    } catch (e) {
      return 'غير محدد';
    }
  }
}
