import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_guardian_model.dart';

class GuardianRenewalsScreen extends ConsumerStatefulWidget {
  final AdminGuardianModel guardian;

  const GuardianRenewalsScreen({super.key, required this.guardian});

  @override
  ConsumerState<GuardianRenewalsScreen> createState() =>
      _GuardianRenewalsScreenState();
}

class _GuardianRenewalsScreenState extends ConsumerState<GuardianRenewalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentGuardian = widget.guardian;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'سجل التجديدات',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          labelStyle: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'تجديد الترخيص'),
            Tab(text: 'تجديد البطاقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRenewalsList(currentGuardian.licenseRenewals, isLicense: true),
          _buildRenewalsList(currentGuardian.cardRenewals, isLicense: false),
        ],
      ),
    );
  }

  Widget _buildRenewalsList(
    List<Map<String, dynamic>>? renewals, {
    required bool isLicense,
  }) {
    if (renewals == null || renewals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLicense ? Icons.verified_user_outlined : Icons.badge_outlined,
              size: 64,
              color: AppColors.textHint.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد سجلات تجديد',
              style: GoogleFonts.tajawal(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    // Sort by renewal date desc
    final sortedRenewals = List<Map<String, dynamic>>.from(renewals);
    sortedRenewals.sort((a, b) {
      final dateA = a['renewal_date'] ?? '';
      final dateB = b['renewal_date'] ?? '';
      return dateB.compareTo(dateA);
    });

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sortedRenewals.length,
      separatorBuilder: (ctx, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = sortedRenewals[index];
        return _buildRenewalItem(item, isLicense);
      },
    );
  }

  Widget _buildRenewalItem(Map<String, dynamic> item, bool isLicense) {
    final renewalNumber = item['renewal_number'] ?? '-';
    final renewalDate = item['renewal_date'] ?? '-';
    final expiryDate = item['expiry_date'] ?? '-';
    final receiptNumber = item['receipt_number'];
    final notes = item['notes'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isLicense ? AppColors.info : AppColors.warning)
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLicense ? Icons.verified_user : Icons.badge,
                        color: isLicense ? AppColors.info : AppColors.warning,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التجديد رقم $renewalNumber',
                          style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          renewalDate,
                          style: GoogleFonts.tajawal(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'مكتمل',
                    style: GoogleFonts.tajawal(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _buildInfoColumn('تاريخ الانتهاء', expiryDate),
                if (receiptNumber != null) ...[
                  const SizedBox(width: 24),
                  _buildInfoColumn('رقم الإيصال', receiptNumber.toString()),
                ],
              ],
            ),
            if (notes != null && notes.toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'ملاحظات: $notes',
                style: GoogleFonts.tajawal(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.tajawal(color: AppColors.textHint, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
