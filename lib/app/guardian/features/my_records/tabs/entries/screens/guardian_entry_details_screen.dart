import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../features/system/data/models/registry_entry_sections.dart';
import '../../../../../../../features/registry/presentation/providers/entries_provider.dart';
import '../../../../../../../features/admin/presentation/widgets/activity_log_widget.dart';

class GuardianEntryDetailsScreen extends ConsumerStatefulWidget {
  final RegistryEntrySections entry;

  // Guardian Specific Theme Colors
  static const Color guardianPrimary = Color(0xFF006400);
  static const Color guardianLight = Color(0xFFE8F5E9);

  const GuardianEntryDetailsScreen({super.key, required this.entry});

  @override
  ConsumerState<GuardianEntryDetailsScreen> createState() =>
      _GuardianEntryDetailsScreenState();
}

class _GuardianEntryDetailsScreenState
    extends ConsumerState<GuardianEntryDetailsScreen> {
  bool _isLoading = false;
  late RegistryEntrySections _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
  }

  Future<void> _requestDocumentation() async {
    setState(() => _isLoading = true);
    try {
      final targetId = _entry.remoteId ?? _entry.id;
      await ref.read(registryRepositoryProvider).requestDocumentation(targetId);

      ref.invalidate(rawEntriesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إرسال طلب التوثيق بنجاح',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _entry = RegistryEntrySections(
            id: _entry.id,
            uuid: _entry.uuid,
            remoteId: _entry.remoteId,
            basicInfo: _entry.basicInfo,
            writerInfo: _entry.writerInfo,
            documentInfo: _entry.documentInfo,
            financialInfo: _entry.financialInfo,
            guardianInfo: _entry.guardianInfo,
            statusInfo: RegistryStatusInfo(
              status: 'pending_documentation',
              deliveryStatus: _entry.statusInfo.deliveryStatus,
              statusLabel: 'بانتظار التوثيق',
              statusColor: 'warning',
              deliveryStatusLabel: _entry.statusInfo.deliveryStatusLabel,
              deliveryStatusColor: _entry.statusInfo.deliveryStatusColor,
              notes: _entry.statusInfo.notes,
            ),
            metadata: _entry.metadata,
            formData: _entry.formData,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canRequestDocumentation =
        _entry.statusInfo.status == 'draft' ||
        _entry.statusInfo.status == 'registered_guardian';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildPartiesCard(),
                  const SizedBox(height: 24),
                  _buildContractDetailsCard(),
                  const SizedBox(height: 24),
                  _buildFinancialCard(),
                  const SizedBox(height: 24),
                  _buildGuardianRecordInfoCard(),
                  const SizedBox(height: 24),
                  _buildSystemInfoCard(),

                  if (_entry.id > 0) ...[
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      'سجل العمليات (التتبع)',
                      Icons.history_outlined,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ActivityLogWidget(entryId: _entry.id),
                      ),
                    ),
                  ],

                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: canRequestDocumentation
          ? _buildBottomAction()
          : null,
    );
  }

  Widget _buildSliverAppBar() {
    final contractTypeId = _entry.basicInfo.contractTypeId;
    final headerColor = _getContractColor(contractTypeId);

    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      backgroundColor: headerColor,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        title: Text(
          'تفاصيل القيد',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            fontSize: 18,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    headerColor.withValues(alpha: 0.8),
                    headerColor.withValues(alpha: 1.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Decorative background circles
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getContractIcon(contractTypeId),
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _entry.basicInfo.contractType?.name ?? 'محرر غير محدد',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'الرقم المتسلسل: ${_entry.basicInfo.serialNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = _entry.statusInfo.statusColor != null
        ? _parseColor(_entry.statusInfo.statusColor!)
        : _getStatusColor(_entry.statusInfo.status);

    final statusLabel =
        _entry.statusInfo.statusLabel ??
        _getStatusLabel(_entry.statusInfo.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_outline, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة القيد',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
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

  Widget _buildPartiesCard() {
    return _buildCardWrapper(
      icon: Icons.group_outlined,
      title: 'أطراف العقد',
      child: Column(
        children: [
          _buildPartyTile(
            title: 'الطرف الأول',
            name: _entry.basicInfo.firstPartyName,
            icon: Icons.person,
            iconColor: GuardianEntryDetailsScreen.guardianPrimary,
          ),
          if (_entry.basicInfo.secondPartyName.isNotEmpty) ...[
            const Divider(height: 24),
            _buildPartyTile(
              title: 'الطرف الثاني',
              name: _entry.basicInfo.secondPartyName,
              icon: Icons.person_outline,
              iconColor: Colors.blue[700]!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContractDetailsCard() {
    final Map<String, dynamic>? formFields = _entry.formData;
    bool hasSubject =
        _entry.basicInfo.subject != null &&
        _entry.basicInfo.subject!.trim().isNotEmpty;
    bool hasContent =
        _entry.basicInfo.content != null &&
        _entry.basicInfo.content!.trim().isNotEmpty;
    bool hasDynamicForm =
        formFields != null &&
        formFields.isNotEmpty &&
        formFields.entries.any(
          (e) => e.value != null && e.value.toString().isNotEmpty,
        );

    return _buildCardWrapper(
      icon: Icons.description_outlined,
      title: 'تفاصيل المحرر',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDataContainer(
                  'تاريخ ہجري',
                  _entry.documentInfo.documentHijriDate?.split('T').first ??
                      '-',
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataContainer(
                  'تاريخ ميلادي',
                  _entry.documentInfo.documentGregorianDate != null
                      ? intl.DateFormat('yyyy/MM/dd', 'ar').format(
                          DateTime.tryParse(
                                _entry.documentInfo.documentGregorianDate!,
                              ) ??
                              DateTime.now(),
                        )
                      : '-',
                  Icons.event,
                ),
              ),
            ],
          ),

          if (hasSubject) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموضوع:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _entry.basicInfo.subject!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (hasContent) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'البنود / المحتوى:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _entry.basicInfo.content!,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Render Dynamic Form Elements
          if (hasDynamicForm) ...[
            const SizedBox(height: 20),
            Text(
              'بيانات إضافية المخصصة:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: GuardianEntryDetailsScreen.guardianPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: formFields.entries
                  .where(
                    (e) => e.value != null && e.value.toString().isNotEmpty,
                  )
                  .length,
              itemBuilder: (context, index) {
                final entryItem = formFields.entries
                    .where(
                      (e) => e.value != null && e.value.toString().isNotEmpty,
                    )
                    .elementAt(index);
                return _buildDataContainer(
                  _translateKey(entryItem.key),
                  entryItem.value.toString(),
                  Icons.my_library_books_outlined,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialCard() {
    final double fees = _entry.financialInfo.feeAmount ?? 0.0;

    // If no fees are applicable, don't show full details just an indicator.
    if (_entry.financialInfo.totalAmount == 0 && fees == 0) {
      return _buildCardWrapper(
        icon: Icons.payments_outlined,
        title: 'الرسوم المالية',
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'لا توجد رسوم مسجلة او أنها معفاة',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_entry.financialInfo.exemptionType != null) ...[
              const Spacer(),
              Chip(
                label: Text(
                  _entry.financialInfo.exemptionType!,
                  style: TextStyle(fontSize: 11),
                ),
                backgroundColor: Colors.green[50],
              ),
            ],
          ],
        ),
      );
    }

    return _buildCardWrapper(
      icon: Icons.account_balance_wallet_outlined,
      title: 'الرسوم والإيرادات الموثقة',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAmountRow(
                  'رسوم التوثيق:',
                  fees,
                  Icons.description_outlined,
                ),
              ),
              Expanded(
                child: _buildAmountRow(
                  'رسوم المصادقة:',
                  _entry.financialInfo.authenticationFeeAmount ?? 0,
                  Icons.verified_user_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAmountRow(
                  'رسوم الانتقال:',
                  _entry.financialInfo.transferFeeAmount ?? 0,
                  Icons.directions_car_outlined,
                ),
              ),
              Expanded(
                child: _buildAmountRow(
                  'مبلغ الدعم:',
                  _entry.financialInfo.supportAmount ?? 0,
                  Icons.volunteer_activism_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAmountRow(
                  'الاستدامة:',
                  _entry.financialInfo.sustainabilityAmount ?? 0,
                  Icons.eco_outlined,
                ),
              ),
              Expanded(
                child: _buildAmountRow(
                  'الغرامة:',
                  _entry.financialInfo.penaltyAmount ?? 0,
                  Icons.money_off_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GuardianEntryDetailsScreen.guardianPrimary.withValues(
                alpha: 0.05,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: GuardianEntryDetailsScreen.guardianPrimary.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المبلغ الإجمالي:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  '${_entry.financialInfo.totalAmount.toStringAsFixed(2)} ر.ي',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GuardianEntryDetailsScreen.guardianPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          if (_entry.financialInfo.receiptNumber != null &&
              _entry.financialInfo.receiptNumber!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Text(
                    'رقم السند المالي: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    _entry.financialInfo.receiptNumber!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuardianRecordInfoCard() {
    return _buildCardWrapper(
      icon: Icons.menu_book,
      title: 'السجل المادي لدى الأمين (الدفتر)',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCircleData(
            'رقم السجل',
            _entry.guardianInfo.guardianRecordBookNumber?.toString() ?? '-',
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildCircleData(
            'رقم الصفحة',
            _entry.guardianInfo.guardianPageNumber?.toString() ?? '-',
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildCircleData(
            'رقم القيد',
            _entry.guardianInfo.guardianEntryNumber?.toString() ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return _buildCardWrapper(
      icon: Icons.computer,
      title: 'بيانات النظام والكاتب',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDataContainer(
                  'تاريخ الإنشاء',
                  _entry.metadata.createdAt != null
                      ? intl.DateFormat('yyyy/MM/dd HH:mm', 'en').format(
                          DateTime.tryParse(_entry.metadata.createdAt!) ??
                              DateTime.now(),
                        )
                      : '-',
                  Icons.access_time,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataContainer(
                  'تاريخ التحديث',
                  _entry.metadata.updatedAt != null
                      ? intl.DateFormat('yyyy/MM/dd HH:mm', 'en').format(
                          DateTime.tryParse(_entry.metadata.updatedAt!) ??
                              DateTime.now(),
                        )
                      : '-',
                  Icons.update,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Icon(Icons.person_pin_circle, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بواسطة الكاتب:',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[800],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      _entry.writerInfo.writerName ?? 'غير محدد',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (_entry.writerInfo.writerType != null)
                  Chip(
                    label: Text(
                      _entry.writerInfo.writerType!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    backgroundColor: Colors.blue[400],
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(
        16,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _requestDocumentation,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.send, color: Colors.white),
        label: Text(
          _isLoading ? 'جاري إرسال الطلب...' : 'طلب توثيق العقد',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: GuardianEntryDetailsScreen.guardianPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCardWrapper({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title, icon),
          Padding(padding: const EdgeInsets.all(16.0), child: child),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GuardianEntryDetailsScreen.guardianLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: GuardianEntryDetailsScreen.guardianPrimary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: GuardianEntryDetailsScreen.guardianPrimary,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyTile({
    required String title,
    required String name,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataContainer(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: GuardianEntryDetailsScreen.guardianPrimary.withValues(
              alpha: 0.7,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        const Spacer(),
        Text(
          '${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildCircleData(String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GuardianEntryDetailsScreen.guardianPrimary.withValues(
              alpha: 0.05,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GuardianEntryDetailsScreen.guardianPrimary,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- Translation Methods From Generic View ---

  String _translateKey(String key) {
    final Map<String, String> translations = {
      'seller_name': 'اسم البائع',
      'buyer_name': 'اسم المشتري',
      'sale_type': 'نوع المبيع',
      'sale_area': 'مساحة المبيع',
      'sale_price': 'قيمة المبيع',
      'dowry_amount': 'المهر',
      'husband_name': 'الزوج',
      'wife_name': 'الزوجة',
      'agency_type': 'نوع الوكالة',
      'principal_name': 'الموكل',
      'agent_name': 'الوكيل',
    };
    if (translations.containsKey(key)) return translations[key]!;
    return key
        .replaceAll('_', ' ')
        .replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (m) => m.group(0)!.toUpperCase(),
        );
  }

  Color _parseColor(String colorName) {
    // ... logic copied perfectly ...
    switch (colorName.toLowerCase()) {
      case 'success':
      case 'green':
        return AppColors.success;
      case 'danger':
      case 'error':
      case 'red':
        return AppColors.error;
      case 'warning':
      case 'orange':
        return Colors.orange;
      case 'info':
      case 'blue':
        return Colors.blue;
      case 'primary':
        return GuardianEntryDetailsScreen.guardianPrimary;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        if (colorName.startsWith('#')) {
          try {
            return Color(
              int.parse(colorName.substring(1), radix: 16) + 0xFF000000,
            );
          } catch (_) {}
        }
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
      case 'approved':
      case 'completed':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'pending_documentation':
      case 'pending':
        return Colors.orange;
      case 'registered_guardian':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
        return 'موثق';
      case 'approved':
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      case 'pending_documentation':
      case 'pending':
        return 'بانتظار التوثيق';
      case 'registered_guardian':
        return 'مقيد لدى الأمين';
      case 'draft':
        return 'مسودة';
      default:
        return status;
    }
  }

  Color _getContractColor(int? typeId) {
    switch (typeId) {
      case 1:
        return const Color(0xFFE91E63);
      case 4:
        return const Color(0xFF795548);
      case 5:
        return const Color(0xFF009688);
      case 6:
        return const Color(0xFF673AB7);
      case 7:
        return const Color(0xFFF44336);
      case 8:
        return const Color(0xFFFF5722);
      case 10:
        return const Color(0xFF4CAF50);
      default:
        return GuardianEntryDetailsScreen.guardianPrimary;
    }
  }

  IconData _getContractIcon(int? typeId) {
    switch (typeId) {
      case 1:
        return Icons.favorite;
      case 4:
        return Icons.gavel;
      case 5:
        return Icons.swap_horiz;
      case 6:
        return Icons.account_tree;
      case 7:
        return Icons.heart_broken;
      case 8:
        return Icons.replay;
      case 10:
        return Icons.shopping_cart_outlined;
      default:
        return Icons.description_outlined;
    }
  }
}
