/// [DEPRECATED] هذه الشاشة قديمة وتم استبدالها بشاشة بتصميم احترافي وبطاقي جديدة.
///
/// الرجاء استخدام الشاشة الجديدة المتواجدة في المسار التالي:
/// lib/app/guardian/features/my_records/tabs/entries/screens/guardian_entry_details_screen.dart
///
/// تم الإبقاء على هذا الملف لأغراض الأرشفة والرجوع إليه عند الحاجة، ولا يتم استخدامه في التطبيق حالياً.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../../../features/registry/presentation/providers/entries_provider.dart';

class GuardianEntryDetailsScreen extends ConsumerStatefulWidget {
  final RegistryEntrySections entry;

  // Guardian Specific Green Theme
  static const Color guardianPrimary = Color(0xFF006400);

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
      // The backend expects the remote ID
      final targetId = _entry.remoteId ?? _entry.id;
      await ref.read(registryRepositoryProvider).requestDocumentation(targetId);

      // Refresh entries list to reflect new status
      ref.invalidate(rawEntriesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إرسال طلب التوثيق بنجاح',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Locally update the UI
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
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل القيد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            _buildHeaderSection(),
            // ==========================================
            // 1. بيانات المحرر (العقد)
            // ==========================================
            _buildSectionTitle('بيانات المحرر (العقد)'),
            _buildInfoGrid([
              _buildGridItem(
                'نوع العقد',
                _entry.basicInfo.contractType?.name ?? 'غير محدد',
                Icons.description_outlined,
              ),
              _buildGridItem(
                'تاريخ المحرر (هـ)',
                _entry.documentInfo.documentHijriDate?.split('T').first ?? '-',
                Icons.calendar_today,
              ),
              _buildGridItem(
                'تاريخ المحرر (م)',
                _entry.documentInfo.documentGregorianDate != null
                    ? intl.DateFormat('yyyy/MM/dd').format(
                        DateTime.tryParse(
                              _entry.documentInfo.documentGregorianDate!,
                            ) ??
                            DateTime.now(),
                      )
                    : '-',
                Icons.event,
              ),
              _buildGridItem(
                'الطرف الأول',
                _entry.basicInfo.firstPartyName,
                Icons.person,
              ),
              _buildGridItem(
                'الطرف الثاني',
                _entry.basicInfo.secondPartyName,
                Icons.person_outline,
              ),
              // Dynamic Form Data
              if (_entry.formData != null && _entry.formData!.isNotEmpty)
                ..._entry.formData!.entries
                    .where(
                      (e) => e.value != null && e.value.toString().isNotEmpty,
                    )
                    .map(
                      (e) => _buildGridItem(
                        _translateKey(e.key),
                        e.value.toString(),
                        Icons.info_outline,
                      ),
                    ),
            ]),
            const SizedBox(height: 16),

            // Content Sub-section inside the Editor Category
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
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
                  const SizedBox(height: 4),
                  Text(
                    _entry.basicInfo.subject ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'البنود/المحتوى:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _entry.basicInfo.content ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ==========================================
            // 2. بيانات القيد في سجل الأمين
            // ==========================================
            _buildSectionTitle('بيانات القيد في سجل الأمين'),
            _buildInfoGrid([
              _buildGridItem(
                'رقم القيد لدى الأمين',
                _entry.guardianInfo.guardianEntryNumber?.toString() ?? '-',
                Icons.numbers_outlined,
              ),
              _buildGridItem(
                'رقم السجل',
                _entry.guardianInfo.guardianRecordBookNumber?.toString() ?? '-',
                Icons.menu_book_outlined,
              ),
              _buildGridItem(
                'رقم الصفحة',
                _entry.guardianInfo.guardianPageNumber?.toString() ?? '-',
                Icons.find_in_page_outlined,
              ),
              _buildGridItem(
                'تاريخ القيد (هـ)',
                _entry.guardianInfo.guardianHijriDate?.split('T').first ?? '-',
                Icons.calendar_month_outlined,
              ),
              _buildGridItem('تاريخ القيد (م)', '-', Icons.event_outlined),
            ]),
            const SizedBox(height: 32),

            // ==========================================
            // 3. معلومات النظام
            // ==========================================
            _buildSectionTitle('معلومات النظام'),
            _buildInfoGrid([
              _buildGridItem(
                'الحالة',
                _getStatusLabel(_entry.statusInfo.status),
                Icons.info_outline,
              ),
              _buildGridItem(
                'تاريخ الإنشاء',
                _entry.metadata.createdAt != null
                    ? intl.DateFormat('yyyy/MM/dd HH:mm').format(
                        DateTime.tryParse(_entry.metadata.createdAt!) ??
                            DateTime.now(),
                      )
                    : '-',
                Icons.access_time_outlined,
              ),
              _buildGridItem(
                'تاريخ آخر تحديث',
                _entry.metadata.updatedAt != null
                    ? intl.DateFormat('yyyy/MM/dd HH:mm').format(
                        DateTime.tryParse(_entry.metadata.updatedAt!) ??
                            DateTime.now(),
                      )
                    : '-',
                Icons.update,
              ),
              _buildGridItem(
                'نوع الكاتب',
                _entry.writerInfo.writerType ?? '-',
                Icons.person_pin_outlined,
              ),
              _buildGridItem(
                'اسم الكاتب',
                _entry.writerInfo.writerName ?? '-',
                Icons.person_search_outlined,
              ),
            ]),
            const SizedBox(height: 40),

            // Status Actions
            if (_entry.statusInfo.status == 'draft' ||
                _entry.statusInfo.status == 'registered_guardian')
              SizedBox(
                width: double.infinity,
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
                      : const Icon(Icons.send_outlined, color: Colors.white),
                  label: Text(
                    _isLoading ? 'جاري الإرسال...' : 'طلب توثيق العقد',
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
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final headerColor = _getContractColor(_entry.basicInfo.contractTypeId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: headerColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getContractIcon(_entry.basicInfo.contractTypeId),
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            _entry.basicInfo.contractType?.name ?? 'محرر غير محدد',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'الرقم المتسلسل: ${_entry.basicInfo.serialNumber}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: GuardianEntryDetailsScreen.guardianPrimary,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildInfoGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cross axis count based on screen width
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        // Adjust for very small screens
        if (constraints.maxWidth < 350) crossAxisCount = 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5, // Adjust based on your content needs
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }

  Widget _buildGridItem(
    String label,
    String value,
    IconData icon, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: GuardianEntryDetailsScreen.guardianPrimary.withValues(
                alpha: 0.05,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: GuardianEntryDetailsScreen.guardianPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
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
        return const Color(0xFFE91E63); // وردي للزواج
      case 4:
        return const Color(0xFF795548); // بني للوكالات
      case 5:
        return const Color(0xFF009688); // أخضر مزرق للتصرفيات
      case 6:
        return const Color(0xFF673AB7); // بنفسجي للقسمة
      case 7:
        return const Color(0xFFF44336); // أحمر للطلاق
      case 8:
        return const Color(0xFFFF5722); // برتقالي للرجعة
      case 10:
        return const Color(0xFF4CAF50); // أخضر للمبيعات
      default:
        // Use guardian primary default here instead of AppColors.primary
        return GuardianEntryDetailsScreen.guardianPrimary;
    }
  }

  IconData _getContractIcon(int? typeId) {
    switch (typeId) {
      case 1:
        return Icons.favorite; // زواج
      case 4:
        return Icons.gavel; // وكالة
      case 5:
        return Icons.swap_horiz; // تصرف
      case 6:
        return Icons.account_tree; // قسمة
      case 7:
        return Icons.heart_broken; // طلاق
      case 8:
        return Icons.replay; // رجعة
      case 10:
        return Icons.shopping_cart_outlined; // مبيع
      default:
        return Icons.description_outlined;
    }
  }

  String _translateKey(String key) {
    final Map<String, String> translations = {
      // Sale Contracts
      'seller_name': 'اسم البائع',
      'buyer_name': 'اسم المشتري',
      'sale_type': 'نوع المبيع',
      'sale_area': 'مساحة/موقع المبيع',
      'sale_price': 'قيمة المبيع',
      // Disposition Records
      'disposer_name': 'اسم المتصرف',
      'disposed_to_name': 'اسم المتصرف له',
      'disposition_type': 'نوع التصرف',
      // Division Records
      'inheritor_name': 'المؤرث',
      'heirs_names': 'أسماء الورثة',
      // Agency Contracts
      'principal_name': 'الموكل',
      'agent_name': 'الوكيل',
      'agency_type': 'نوع الوكالة',
      // Marriage
      'husband_name': 'اسم الزوج',
      'wife_name': 'اسم الزوجة',
      'husband_birth_date': 'تاريخ ميلاد الزوج',
      'wife_birth_date': 'تاريخ ميلاد الزوجة',
      'wife_age': 'عمر الزوجة',
      'dowry_amount': 'مبلغ المهر',
      'dowry_type': 'نوع المهر',
      // Divorce
      'divorcer_name': 'المطلق',
      'divorced_name': 'المطلقة',
      // Return
      'return_date': 'تاريخ المراجعة',
      // Shared/Fallback
      'price': 'المبلغ/الثمن',
      'currency': 'العملة',
      'property_details': 'تفاصيل العقار',
    };

    // Convert snake_case or camelCase to a readable format if no translation
    if (translations.containsKey(key)) {
      return translations[key]!;
    }

    return key
        .replaceAll('_', ' ')
        .replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (match) => match.group(0)!.toUpperCase(),
        );
  }
}
