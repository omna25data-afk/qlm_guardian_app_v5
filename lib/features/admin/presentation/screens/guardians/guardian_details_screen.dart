import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/admin_guardian_model.dart';
import '../../providers/admin_dashboard_provider.dart';
import '../../widgets/guardians/guardian_details_section.dart';
import '../../widgets/guardians/guardian_info_grid_item.dart';
import '../add_edit_guardian_screen.dart';

class GuardianDetailsScreen extends ConsumerStatefulWidget {
  final AdminGuardianModel guardian;

  const GuardianDetailsScreen({super.key, required this.guardian});

  @override
  ConsumerState<GuardianDetailsScreen> createState() =>
      _GuardianDetailsScreenState();
}

class _GuardianDetailsScreenState extends ConsumerState<GuardianDetailsScreen> {
  late AdminGuardianModel _guardian;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _guardian = widget.guardian;
    _fetchFreshData();
  }

  Future<void> _fetchFreshData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final freshGuardian = await repo.getGuardianDetails(_guardian.id);
      if (mounted) {
        setState(() {
          _guardian = freshGuardian;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الأمين'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _hasChanges),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchFreshData,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditGuardianScreen(guardian: _guardian),
                ),
              ).then((result) {
                if (result == true) {
                  _hasChanges = true;
                  _fetchFreshData();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Photo Header
            if (_guardian.photoUrl != null)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(_guardian.photoUrl!),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

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
                    value: _guardian.shortName,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.numbers,
                    label: 'الرقم التسلسلي',
                    value: _guardian.serialNumber ?? 'غير محدد',
                    isCopyable: true,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الميلاد',
                    value: _guardian.birthDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.cake_outlined,
                    label: 'العمر',
                    value: _calculateAge(_guardian.birthDate),
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
                    value: _guardian.phone ?? 'غير محدد',
                    isCopyable: true,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.home_outlined,
                    label: 'هاتف المنزل',
                    value: _guardian.homePhone ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.location_on_outlined,
                    label: 'محل الميلاد والإقامة',
                    value:
                        '${_guardian.birthPlace ?? ''} - ${_guardian.mainDistrictName ?? ''}'
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
                    value: _guardian.proofType ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.numbers,
                    label: 'رقم الإثبات',
                    value: _guardian.proofNumber ?? 'غير محدد',
                    isCopyable: true,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الإصدار',
                    value: _guardian.issueDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.event_busy_outlined,
                    label: 'تاريخ الانتهاء',
                    value: _guardian.expiryDate ?? 'غير محدد',
                    valueColor: _guardian.identityStatusColor,
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.account_balance_outlined,
                    label: 'جهة الإصدار',
                    value: _guardian.issuingAuthority ?? 'غير محدد',
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
                    value: _guardian.qualification ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.business_center_outlined,
                    label: 'المهنة',
                    value: _guardian.job ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.corporate_fare_outlined,
                    label: 'جهة العمل',
                    value: _guardian.workplace ?? 'غير محدد',
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
                    value: _guardian.ministerialDecisionNumber ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ القرار الوزاري',
                    value: _guardian.ministerialDecisionDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.card_membership_outlined,
                    label: 'رقم الترخيص',
                    value: _guardian.licenseNumber ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الإصدار',
                    value: _guardian.licenseIssueDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.event_busy_outlined,
                    label: 'انتهاء الترخيص',
                    value: _guardian.licenseExpiryDate ?? 'غير محدد',
                    valueColor: _guardian.licenseStatusColor,
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
                    value: _guardian.professionCardNumber ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الإصدار',
                    value: _guardian.professionCardIssueDate ?? 'غير محدد',
                  ),
                  GuardianInfoGridItem(
                    icon: Icons.event_busy_outlined,
                    label: 'تاريخ الانتهاء',
                    value: _guardian.professionCardExpiryDate ?? 'غير محدد',
                    valueColor: _guardian.cardStatusColor,
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
                    value: _guardian.mainDistrictName ?? 'غير محدد',
                  ),
                  const SizedBox(height: 16),
                  GuardianInfoGridItem(
                    icon: Icons.location_city_outlined,
                    label: 'القرى',
                    value:
                        _guardian.villages?.map((e) => e.name).join('، ') ??
                        'لا توجد قرى مخصصة',
                  ),
                  const SizedBox(height: 16),
                  GuardianInfoGridItem(
                    icon: Icons.home_work_outlined,
                    label: 'المحلات',
                    value:
                        _guardian.localities?.map((e) => e.name).join('، ') ??
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
                        icon: _guardian.employmentStatus == 'على رأس العمل'
                            ? Icons.check_circle
                            : Icons.cancel,
                        label: 'حالة العمل',
                        value: _guardian.employmentStatus ?? 'غير محدد',
                        valueColor:
                            _guardian.employmentStatus == 'على رأس العمل'
                            ? AppColors.success
                            : AppColors.error,
                        iconColor: _guardian.employmentStatus == 'على رأس العمل'
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ],
                  ),
                  if (_guardian.stopDate != null ||
                      _guardian.stopReason != null) ...[
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
                          value: _guardian.stopReason ?? 'غير محدد',
                          valueColor: AppColors.error,
                        ),
                        GuardianInfoGridItem(
                          icon: Icons.event_busy_outlined,
                          label: 'تاريخ الإيقاف',
                          value: _guardian.stopDate ?? 'غير محدد',
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
