// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../providers/add_entry_provider.dart';
import '../providers/admin_pending_entries_provider.dart';
import '../../../records/data/models/record_book.dart';
import '../../../registry/presentation/widgets/contract_type_selector.dart';
import '../../../registry/presentation/widgets/fees_summary_card.dart';
import '../../../registry/presentation/widgets/form_section_card.dart';
import '../../../registry/presentation/widgets/dynamic_field_builder.dart';

/// Contract type label helpers
const Map<int, Map<String, String>> _contractPartyLabels = {
  1: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'},
  7: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'},
  8: {'first': 'اسم الزوج المراجع', 'second': 'اسم الزوجة'},
  4: {'first': 'اسم الموكل', 'second': 'اسم الوكيل'},
  5: {'first': 'اسم المتصرف', 'second': 'اسم المتصرف إليه'},
  6: {'first': 'اسم المؤرث', 'second': 'أسماء الورثة'},
  10: {'first': 'اسم البائع', 'second': 'اسم المشتري'},
};

class AdminAddEntryScreen extends ConsumerStatefulWidget {
  const AdminAddEntryScreen({super.key});

  @override
  ConsumerState<AdminAddEntryScreen> createState() =>
      _AdminAddEntryScreenState();
}

class _AdminAddEntryScreenState extends ConsumerState<AdminAddEntryScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  // ── State ──
  int? _selectedContractTypeId;
  String _writerType = 'guardian';
  int? _selectedGuardianId;
  int? _selectedWriterId;
  int? _selectedOtherWriterId;
  String? _selectedSubtype1;
  String? _selectedSubtype2;
  int? _selectedDocRecordBookId;
  bool _isExempted = false;
  String? _exemptionType;
  bool _hasAuthenticationFee = false;
  bool _hasTransferFee = false;
  bool _hasOtherFee = false;
  bool _isOnline = true;

  // ── Controllers ──
  final _firstPartyCtrl = TextEditingController();
  final _secondPartyCtrl = TextEditingController();
  final _documentHijriDateCtrl = TextEditingController();
  final _documentGregorianDateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _divorceContractNumberCtrl = TextEditingController();
  final _returnDateCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _saleAreaCtrl = TextEditingController();
  final _deedNumberCtrl = TextEditingController();
  final _propertyLocationCtrl = TextEditingController();
  final _propertyBoundariesCtrl = TextEditingController();
  final _itemDescriptionCtrl = TextEditingController();
  final _dispositionSubjectCtrl = TextEditingController();
  final _docHijriDateCtrl = TextEditingController();
  final _docGregorianDateCtrl = TextEditingController();
  final _docEntryNumberCtrl = TextEditingController();
  final _docPageNumberCtrl = TextEditingController();
  final _docRecordBookNumberCtrl = TextEditingController();
  final _docBoxNumberCtrl = TextEditingController();
  final _docDocumentNumberCtrl = TextEditingController();
  final _receiptNumberCtrl = TextEditingController();
  final _feeAmountCtrl = TextEditingController(text: '0');
  final _penaltyAmountCtrl = TextEditingController(text: '0');
  final _supportAmountCtrl = TextEditingController(text: '0');
  final _sustainabilityAmountCtrl = TextEditingController(text: '200');
  final _totalAmountCtrl = TextEditingController(text: '0');
  final _exemptionReasonCtrl = TextEditingController();
  final _taxAmountCtrl = TextEditingController(text: '0');
  final _taxReceiptNumberCtrl = TextEditingController();
  final _zakatAmountCtrl = TextEditingController(text: '0');
  final _zakatReceiptNumberCtrl = TextEditingController();
  final _guardianRecordBookNumberCtrl = TextEditingController();
  final _guardianPageNumberCtrl = TextEditingController();
  final _guardianEntryNumberCtrl = TextEditingController();
  final Map<String, TextEditingController> _dynamicControllers = {};

  @override
  void initState() {
    super.initState();
    HijriCalendar.setLocal('ar');
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (mounted) setState(() => _isOnline = online);
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    for (final c in [
      _firstPartyCtrl,
      _secondPartyCtrl,
      _documentHijriDateCtrl,
      _documentGregorianDateCtrl,
      _notesCtrl,
      _divorceContractNumberCtrl,
      _returnDateCtrl,
      _salePriceCtrl,
      _saleAreaCtrl,
      _deedNumberCtrl,
      _propertyLocationCtrl,
      _propertyBoundariesCtrl,
      _itemDescriptionCtrl,
      _dispositionSubjectCtrl,
      _docHijriDateCtrl,
      _docGregorianDateCtrl,
      _docEntryNumberCtrl,
      _docPageNumberCtrl,
      _docRecordBookNumberCtrl,
      _docBoxNumberCtrl,
      _docDocumentNumberCtrl,
      _receiptNumberCtrl,
      _feeAmountCtrl,
      _penaltyAmountCtrl,
      _supportAmountCtrl,
      _sustainabilityAmountCtrl,
      _totalAmountCtrl,
      _exemptionReasonCtrl,
      _taxAmountCtrl,
      _taxReceiptNumberCtrl,
      _zakatAmountCtrl,
      _zakatReceiptNumberCtrl,
      _guardianRecordBookNumberCtrl,
      _guardianPageNumberCtrl,
      _guardianEntryNumberCtrl,
    ]) {
      c.dispose();
    }
    for (final c in _dynamicControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Fee Calculation ──
  void _calculateFees() {
    if (_selectedContractTypeId == null) return;
    final nonFinancial = [1, 7, 8, 4];
    final financial = [10, 5, 6];
    double baseFee = 0;

    if (nonFinancial.contains(_selectedContractTypeId)) {
      baseFee = 400;
    } else if (financial.contains(_selectedContractTypeId)) {
      final formData = ref.read(addEntryProvider).formData;
      final dynamicPrice =
          formData['sale_price'] ?? _dynamicControllers['sale_price']?.text;
      final salePrice = double.tryParse(_salePriceCtrl.text) ?? 0;
      double price = dynamicPrice != null
          ? (double.tryParse(dynamicPrice.toString()) ?? salePrice)
          : salePrice;
      baseFee = price > 0 ? price * 0.002 : 400;
    } else {
      baseFee = 2000;
    }

    double extra = 0;
    if (_hasAuthenticationFee) extra += 400;
    if (_hasTransferFee) extra += 400;
    if (_hasOtherFee) extra += 400;
    if (_writerType == 'documentation') extra += 400;

    final totalFee = baseFee + extra;
    final support = totalFee * 0.25;
    final sustainability =
        double.tryParse(_sustainabilityAmountCtrl.text) ?? 200;

    setState(() {
      _feeAmountCtrl.text = (baseFee + extra).toStringAsFixed(0);
      _penaltyAmountCtrl.text = '0';
      _supportAmountCtrl.text = support.toStringAsFixed(0);
      _totalAmountCtrl.text = (totalFee + support + sustainability)
          .toStringAsFixed(0);
    });
  }

  // ── Hijri Date Picker ──
  Future<void> _selectHijriDate(
    BuildContext context,
    TextEditingController hijriCtrl,
    TextEditingController gregCtrl,
  ) async {
    final picked = await showHijriDatePicker(
      context: context,
      initialDate: HijriCalendar.now(),
      lastDate: HijriCalendar()
        ..hYear = 1498
        ..hMonth = 12
        ..hDay = 30,
      firstDate: HijriCalendar()
        ..hYear = 1356
        ..hMonth = 1
        ..hDay = 1,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      setState(() {
        hijriCtrl.text = picked.toString();
        gregCtrl.text = picked
            .hijriToGregorian(picked.hYear, picked.hMonth, picked.hDay)
            .toString()
            .split(' ')[0];
      });
    }
  }

  Future<void> _selectGregorianDate(
    BuildContext context,
    TextEditingController gregCtrl,
    TextEditingController hijriCtrl,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2075),
    );
    if (picked != null) {
      setState(() {
        gregCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        hijriCtrl.text = HijriCalendar.fromDate(picked).toString();
      });
    }
  }

  // ── Submit ──
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedContractTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار نوع العقد'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final data = <String, dynamic>{
      'contract_type_id': _selectedContractTypeId,
      'first_party_name': _firstPartyCtrl.text,
      'second_party_name': _secondPartyCtrl.text,
      'writer_type': _writerType,
      'document_hijri_date': _documentHijriDateCtrl.text,
      'document_gregorian_date': _documentGregorianDateCtrl.text,
      'transaction_date': _documentGregorianDateCtrl.text,
      'notes': _notesCtrl.text,
      'status': 'draft',
    };

    // Writer
    if (_writerType == 'guardian' && _selectedGuardianId != null) {
      data['guardian_id'] = _selectedGuardianId;
      data['guardian_page_number'] = int.tryParse(_guardianPageNumberCtrl.text);
      data['guardian_entry_number'] = int.tryParse(
        _guardianEntryNumberCtrl.text,
      );
      data['guardian_record_book_number'] = int.tryParse(
        _guardianRecordBookNumberCtrl.text,
      );
    } else if (_writerType == 'documentation' && _selectedWriterId != null) {
      data['writer_id'] = _selectedWriterId;
    } else if (_writerType == 'external' && _selectedOtherWriterId != null) {
      data['other_writer_id'] = _selectedOtherWriterId;
    }

    // Contract-specific
    if (_selectedContractTypeId == 8) {
      data['divorce_contract_number'] = _divorceContractNumberCtrl.text;
      data['return_date'] = _returnDateCtrl.text;
    }
    if (_selectedContractTypeId == 10 || _selectedContractTypeId == 5) {
      data['subtype_1'] = _selectedSubtype1;
      data['subtype_2'] = _selectedSubtype2;
    }
    if (_selectedContractTypeId == 10) {
      data['sale_price'] = double.tryParse(_salePriceCtrl.text) ?? 0;
      data['sale_area'] = _saleAreaCtrl.text;
      data['deed_number'] = _deedNumberCtrl.text;
      data['property_location'] = _propertyLocationCtrl.text;
      data['property_boundaries'] = _propertyBoundariesCtrl.text;
      data['item_description'] = _itemDescriptionCtrl.text;
    }
    if (_selectedContractTypeId == 5) {
      data['disposition_subject'] = _dispositionSubjectCtrl.text;
    }

    // Documentation
    data['doc_hijri_date'] = _docHijriDateCtrl.text;
    data['doc_gregorian_date'] = _docGregorianDateCtrl.text;
    data['doc_entry_number'] = int.tryParse(_docEntryNumberCtrl.text);
    data['doc_page_number'] = int.tryParse(_docPageNumberCtrl.text);
    data['doc_record_book_number'] = int.tryParse(
      _docRecordBookNumberCtrl.text,
    );
    data['doc_box_number'] = int.tryParse(_docBoxNumberCtrl.text);
    data['doc_document_number'] = int.tryParse(_docDocumentNumberCtrl.text);
    data['receipt_number'] = _receiptNumberCtrl.text;
    if (_selectedDocRecordBookId != null) {
      data['documentation_record_book_id'] = _selectedDocRecordBookId;
    }

    // Fees
    data['fee_amount'] = double.tryParse(_feeAmountCtrl.text) ?? 0;
    data['penalty_amount'] = double.tryParse(_penaltyAmountCtrl.text) ?? 0;
    data['support_amount'] = double.tryParse(_supportAmountCtrl.text) ?? 0;
    data['sustainability_amount'] =
        double.tryParse(_sustainabilityAmountCtrl.text) ?? 200;
    data['total_amount'] = double.tryParse(_totalAmountCtrl.text) ?? 0;
    data['is_exempted'] = _isExempted;
    data['exemption_type'] = _exemptionType;
    data['exemption_reason'] = _exemptionReasonCtrl.text;
    data['has_authentication_fee'] = _hasAuthenticationFee;
    data['has_transfer_fee'] = _hasTransferFee;
    data['has_other_fee'] = _hasOtherFee;

    // Tax & Zakat
    if (_selectedContractTypeId == 10 || _selectedContractTypeId == 5) {
      data['tax_amount'] = double.tryParse(_taxAmountCtrl.text) ?? 0;
      data['tax_receipt_number'] = _taxReceiptNumberCtrl.text;
    }
    if (_selectedContractTypeId == 10) {
      data['zakat_amount'] = double.tryParse(_zakatAmountCtrl.text) ?? 0;
      data['zakat_receipt_number'] = _zakatReceiptNumberCtrl.text;
    }

    data.removeWhere((key, value) => value == null || value == '');

    final success = await ref.read(addEntryProvider.notifier).submitEntry(data);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                _isOnline ? 'تم الحفظ بنجاح' : 'تم الحفظ محلياً',
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      ref
          .read(adminPendingEntriesProvider.notifier)
          .fetchEntries(refresh: true);
      Navigator.pop(context);
    }
  }

  void _onContractTypeSelected(int typeId) {
    setState(() {
      _selectedContractTypeId = typeId;
      _selectedSubtype1 = null;
      _selectedSubtype2 = null;
    });
    final notifier = ref.read(addEntryProvider.notifier);
    notifier.loadSubtypes(typeId);
    notifier.loadDocumentationRecordBooks(typeId);
    notifier.loadFormFields(typeId);
    _calculateFees();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEntryProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(state),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isOnline) _buildOfflineBanner(),
                        // Error
                        if (state.error != null) _buildError(state.error!),

                        // Contract Type
                        ContractTypeSelector(
                          contractTypes: state.contractTypes,
                          selectedId: _selectedContractTypeId,
                          onSelected: _onContractTypeSelected,
                        ),
                        const SizedBox(height: 16),

                        // Writer & Parties
                        FormSectionCard(
                          title: 'بيانات المحرر والكاتب',
                          icon: Icons.person_pin,
                          accentColor: AppColors.primary,
                          child: _buildWriterAndPartiesSection(state),
                        ),
                        const SizedBox(height: 16),

                        // Dynamic Fields from API
                        if (state.filteredFields.isNotEmpty ||
                            state.isLoadingFields)
                          FormSectionCard(
                            title: 'بيانات إضافية',
                            icon: Icons.dynamic_form,
                            accentColor: Colors.teal,
                            child: DynamicFieldBuilder(
                              fields: state.filteredFields,
                              isLoading: state.isLoadingFields,
                              controllers: _dynamicControllers,
                              onFieldChanged: (entry) {
                                ref
                                    .read(addEntryProvider.notifier)
                                    .updateFormData(entry.key, entry.value);
                                if (entry.key == 'sale_price') {
                                  Future.delayed(Duration.zero, _calculateFees);
                                }
                              },
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Documentation Record
                        FormSectionCard(
                          title: 'بيانات القيد في قلم التوثيق',
                          icon: Icons.assignment,
                          accentColor: AppColors.accent,
                          child: _buildDocRecordSection(state),
                        ),
                        const SizedBox(height: 16),

                        // Financial
                        FormSectionCard(
                          title: 'البيانات المالية',
                          icon: Icons.attach_money,
                          accentColor: Colors.orange,
                          child: _buildFinancialSection(state),
                        ),
                        const SizedBox(height: 16),

                        // Fees card
                        FeesSummaryCard(
                          feeAmount: _feeAmountCtrl.text,
                          penaltyAmount: _penaltyAmountCtrl.text,
                          supportAmount: _supportAmountCtrl.text,
                          sustainabilityAmount: _sustainabilityAmountCtrl.text,
                          totalAmount: _totalAmountCtrl.text,
                          isExempted: _isExempted,
                        ),
                        const SizedBox(height: 16),

                        // Guardian Record
                        if (_writerType == 'guardian')
                          FormSectionCard(
                            title: 'بيانات سجل الأمين',
                            icon: Icons.verified_user,
                            accentColor: AppColors.success,
                            isCollapsible: true,
                            child: _buildGuardianRecordSection(),
                          ),
                        const SizedBox(height: 24),

                        _buildSubmitButton(state),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AddEntryState state) {
    return AppBar(
      title: const Text('إضافة قيد جديد'),
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _isOnline
                ? AppColors.success.withValues(alpha: 0.2)
                : AppColors.error.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isOnline ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: _isOnline ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                _isOnline ? 'متصل' : 'غير متصل',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w600,
                  color: _isOnline ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),
        if (state.isSubmitting)
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          )
        else
          TextButton.icon(
            onPressed: _submitForm,
            icon: Icon(Icons.save, color: Colors.white, size: 20),
            label: const Text(
              'حفظ',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 18, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'أنت غير متصل. سيُحفظ القيد محلياً ويُرفع عند الاتصال.',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String err) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Text(
        err,
        style: const TextStyle(color: AppColors.error, fontFamily: 'Tajawal'),
      ),
    );
  }

  // ═══════ Writer & Parties ═══════
  Widget _buildWriterAndPartiesSection(AddEntryState state) {
    final labels =
        _contractPartyLabels[_selectedContractTypeId] ??
        {'first': 'الطرف الأول', 'second': 'الطرف الثاني'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date
        _sectionLabel('تاريخ المحرر'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _dateField(
                _documentHijriDateCtrl,
                'التاريخ الهجري',
                Icons.calendar_month,
                () => _selectHijriDate(
                  context,
                  _documentHijriDateCtrl,
                  _documentGregorianDateCtrl,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dateField(
                _documentGregorianDateCtrl,
                'التاريخ الميلادي',
                Icons.event,
                () => _selectGregorianDate(
                  context,
                  _documentGregorianDateCtrl,
                  _documentHijriDateCtrl,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        // Writer Type
        _sectionLabel('بيانات الكاتب'),
        const SizedBox(height: 8),
        _buildWriterTypeChips(),
        const SizedBox(height: 16),
        _buildWriterSelector(state),

        const Divider(height: 32),

        // Parties
        _sectionLabel('الأطراف'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _textField(
                _firstPartyCtrl,
                labels['first']!,
                required: true,
                icon: Icons.person,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textField(
                _secondPartyCtrl,
                labels['second']!,
                required: true,
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),

        // Contract-specific
        if (_selectedContractTypeId == 8) ..._buildReturnFields(),
        if (_selectedContractTypeId == 10) ..._buildSaleFields(state),
        if (_selectedContractTypeId == 5) ..._buildDispositionFields(state),

        const SizedBox(height: 16),
        _textField(
          _notesCtrl,
          'ملاحظات إضافية',
          maxLines: 3,
          icon: Icons.notes,
        ),
      ],
    );
  }

  Widget _buildWriterTypeChips() {
    return Row(
      children: [
        _writerChip('guardian', 'أمين شرعي', Icons.verified_user),
        const SizedBox(width: 8),
        _writerChip('documentation', 'قلم التوثيق', Icons.badge),
        const SizedBox(width: 8),
        _writerChip('external', 'آخرون', Icons.person_outline),
      ],
    );
  }

  Widget _writerChip(String value, String label, IconData icon) {
    final sel = _writerType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _writerType = value);
          _calculateFees();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: sel
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: sel ? AppColors.primary : AppColors.border,
              width: sel ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: sel ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                  color: sel ? AppColors.primary : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWriterSelector(AddEntryState state) {
    if (_writerType == 'guardian') {
      return SearchableDropdown<Map<String, dynamic>>(
        items: state.guardians,
        label: 'اختر الأمين *',
        hint: 'ابحث عن اسم الأمين...',
        value: _selectedGuardianId != null
            ? state.guardians.firstWhere(
                (g) => g['id'] == _selectedGuardianId,
                orElse: () => {},
              )
            : null,
        itemLabelBuilder: (item) => item['name']?.toString() ?? '',
        onChanged: (item) {
          if (item != null)
            setState(() => _selectedGuardianId = item['id'] as int);
        },
        validator: (item) =>
            _writerType == 'guardian' && (item == null || item.isEmpty)
            ? 'مطلوب'
            : null,
      );
    } else if (_writerType == 'documentation') {
      return SearchableDropdown<Map<String, dynamic>>(
        items: state.writers,
        label: 'اختر الموثق *',
        hint: 'ابحث عن الموثق...',
        value: _selectedWriterId != null
            ? state.writers.firstWhere(
                (w) => w['id'] == _selectedWriterId,
                orElse: () => {},
              )
            : null,
        itemLabelBuilder: (item) => item['name']?.toString() ?? '',
        onChanged: (item) {
          if (item != null) {
            setState(() => _selectedWriterId = item['id'] as int);
            _calculateFees();
          }
        },
        validator: (item) =>
            _writerType == 'documentation' && (item == null || item.isEmpty)
            ? 'مطلوب'
            : null,
      );
    } else {
      return SearchableDropdown<Map<String, dynamic>>(
        items: state.otherWriters,
        label: 'اختر الكاتب *',
        hint: 'ابحث عن الكاتب...',
        value: _selectedOtherWriterId != null
            ? state.otherWriters.firstWhere(
                (w) => w['id'] == _selectedOtherWriterId,
                orElse: () => {},
              )
            : null,
        itemLabelBuilder: (item) => item['name']?.toString() ?? '',
        onChanged: (item) {
          if (item != null)
            setState(() => _selectedOtherWriterId = item['id'] as int);
        },
        validator: (item) =>
            _writerType == 'external' && (item == null || item.isEmpty)
            ? 'مطلوب'
            : null,
      );
    }
  }

  List<Widget> _buildReturnFields() {
    return [
      const SizedBox(height: 16),
      _sectionLabel('بيانات الرجعة'),
      const SizedBox(height: 8),
      _textField(
        _divorceContractNumberCtrl,
        'رقم عقد الطلاق',
        keyboardType: TextInputType.number,
        icon: Icons.numbers,
      ),
      const SizedBox(height: 12),
      _dateField(_returnDateCtrl, 'تاريخ الرجعة', Icons.calendar_today, () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2075),
        );
        if (date != null)
          _returnDateCtrl.text =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }),
    ];
  }

  List<Widget> _buildSaleFields(AddEntryState state) {
    return [
      const SizedBox(height: 16),
      _sectionLabel('بيانات المبيع'),
      const SizedBox(height: 8),
      if (state.subtypes1.isNotEmpty) ...[
        _buildSubtypeDropdown(
          state.subtypes1,
          'نوع المبيع',
          _selectedSubtype1,
          (code) {
            setState(() {
              _selectedSubtype1 = code;
              _selectedSubtype2 = null;
            });
            if (code != null && _selectedContractTypeId != null) {
              ref
                  .read(addEntryProvider.notifier)
                  .loadSubtypes(_selectedContractTypeId!, parentCode: code);
            }
          },
        ),
        const SizedBox(height: 12),
      ],
      if (state.subtypes2.isNotEmpty) ...[
        _buildSubtypeDropdown(
          state.subtypes2,
          'النوع الفرعي',
          _selectedSubtype2,
          (code) => setState(() => _selectedSubtype2 = code),
        ),
        const SizedBox(height: 12),
      ],
      _textField(
        _salePriceCtrl,
        'ثمن المبيع (ر.ي)',
        keyboardType: TextInputType.number,
        icon: Icons.attach_money,
        onChanged: (_) => _calculateFees(),
      ),
      const SizedBox(height: 12),
      _textField(_saleAreaCtrl, 'المساحة', icon: Icons.square_foot),
      const SizedBox(height: 12),
      _textField(_deedNumberCtrl, 'رقم الصك/الوثيقة', icon: Icons.receipt_long),
      const SizedBox(height: 12),
      _textField(
        _propertyLocationCtrl,
        'موقع العقار',
        maxLines: 2,
        icon: Icons.location_on,
      ),
      const SizedBox(height: 12),
      _textField(
        _propertyBoundariesCtrl,
        'الحدود',
        maxLines: 2,
        icon: Icons.border_all,
      ),
      const SizedBox(height: 12),
      _textField(
        _itemDescriptionCtrl,
        'وصف المبيع (للمنقول)',
        maxLines: 2,
        icon: Icons.description,
      ),
    ];
  }

  List<Widget> _buildDispositionFields(AddEntryState state) {
    return [
      const SizedBox(height: 16),
      _sectionLabel('بيانات التصرف'),
      const SizedBox(height: 8),
      if (state.subtypes1.isNotEmpty) ...[
        _buildSubtypeDropdown(
          state.subtypes1,
          'نوع التصرف',
          _selectedSubtype1,
          (code) {
            setState(() {
              _selectedSubtype1 = code;
              _selectedSubtype2 = null;
            });
            if (code != null && _selectedContractTypeId != null) {
              ref
                  .read(addEntryProvider.notifier)
                  .loadSubtypes(_selectedContractTypeId!, parentCode: code);
            }
          },
        ),
        const SizedBox(height: 12),
      ],
      _textField(
        _dispositionSubjectCtrl,
        'موضوع التصرف',
        maxLines: 3,
        icon: Icons.subject,
      ),
    ];
  }

  Widget _buildSubtypeDropdown(
    List<Map<String, dynamic>> items,
    String label,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    return SearchableDropdown<Map<String, dynamic>>(
      items: items,
      label: label,
      value: selected != null
          ? items.firstWhere(
              (s) =>
                  (s['code']?.toString() ?? s['name']?.toString()) == selected,
              orElse: () => {},
            )
          : null,
      itemLabelBuilder: (item) => item['name']?.toString() ?? '',
      onChanged: (item) {
        if (item == null) return;
        onChanged(item['code']?.toString() ?? item['name']?.toString());
      },
    );
  }

  // ═══════ Documentation Record ═══════
  Widget _buildDocRecordSection(AddEntryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('تاريخ التوثيق'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _dateField(
                _docHijriDateCtrl,
                'التاريخ الهجري',
                Icons.calendar_month,
                () => _selectHijriDate(
                  context,
                  _docHijriDateCtrl,
                  _docGregorianDateCtrl,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dateField(
                _docGregorianDateCtrl,
                'التاريخ الميلادي',
                Icons.event,
                () => _selectGregorianDate(
                  context,
                  _docGregorianDateCtrl,
                  _docHijriDateCtrl,
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 32),
        _sectionLabel('سجل التوثيق'),
        const SizedBox(height: 8),
        SearchableDropdown<RecordBook>(
          items: state.documentationRecordBooks,
          label: 'سجل التوثيق *',
          hint: 'اختر سجل الوثائق...',
          value: _selectedDocRecordBookId != null
              ? state.documentationRecordBooks.firstWhere(
                  (b) => b.id == _selectedDocRecordBookId,
                  orElse: () => state.documentationRecordBooks.first,
                )
              : null,
          itemLabelBuilder: (b) =>
              'سجل رقم ${b.bookNumber} لسنة ${b.hijriYear}',
          onChanged: (book) {
            if (book != null) {
              setState(() {
                _selectedDocRecordBookId = book.id;
                _docRecordBookNumberCtrl.text = book.bookNumber.toString();
              });
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _textField(
                _docEntryNumberCtrl,
                'رقم القيد',
                keyboardType: TextInputType.number,
                icon: Icons.tag,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textField(
                _docPageNumberCtrl,
                'رقم الصفحة',
                keyboardType: TextInputType.number,
                icon: Icons.find_in_page,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _textField(
                _docRecordBookNumberCtrl,
                'رقم السجل',
                keyboardType: TextInputType.number,
                readOnly: true,
                icon: Icons.book,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textField(
                _docBoxNumberCtrl,
                'رقم الصندوق',
                keyboardType: TextInputType.number,
                icon: Icons.inventory_2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textField(
                _docDocumentNumberCtrl,
                'رقم الوثيقة',
                keyboardType: TextInputType.number,
                icon: Icons.receipt,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════ Financial ═══════
  Widget _buildFinancialSection(AddEntryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('الرسوم المستحقة'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _textField(
                _feeAmountCtrl,
                'الرسوم الأساسية',
                keyboardType: TextInputType.number,
                readOnly: true,
                icon: Icons.attach_money,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textField(
                _penaltyAmountCtrl,
                'الغرامة',
                keyboardType: TextInputType.number,
                icon: Icons.warning_amber,
                onChanged: (_) => _calculateFees(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _textField(
                _supportAmountCtrl,
                'دعم القضاء (25%)',
                keyboardType: TextInputType.number,
                readOnly: true,
                icon: Icons.volunteer_activism,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textField(
                _sustainabilityAmountCtrl,
                'صندوق الاستدامة',
                keyboardType: TextInputType.number,
                icon: Icons.eco,
                onChanged: (_) => _calculateFees(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _textField(
          _receiptNumberCtrl,
          'رقم سند القبض',
          icon: Icons.receipt_long,
        ),

        const SizedBox(height: 24),
        _sectionLabel('رسوم إضافية'),
        _buildFeeCheckboxes(),

        const Divider(height: 24),
        _buildExemptionSection(),

        // Tax & Zakat
        if (_selectedContractTypeId == 10 || _selectedContractTypeId == 5) ...[
          const Divider(height: 32),
          _sectionLabel('ضريبة التصرفات العقارية'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _textField(
                  _taxAmountCtrl,
                  'مبلغ الضريبة',
                  keyboardType: TextInputType.number,
                  icon: Icons.receipt,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  _taxReceiptNumberCtrl,
                  'رقم سند السداد',
                  icon: Icons.numbers,
                ),
              ),
            ],
          ),
        ],
        if (_selectedContractTypeId == 10) ...[
          const SizedBox(height: 12),
          _sectionLabel('الزكاة'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _textField(
                  _zakatAmountCtrl,
                  'مبلغ الزكاة',
                  keyboardType: TextInputType.number,
                  icon: Icons.mosque,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  _zakatReceiptNumberCtrl,
                  'رقم سند السداد',
                  icon: Icons.numbers,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFeeCheckboxes() {
    return Row(
      children: [
        _feeChip(
          'المصادقة',
          _hasAuthenticationFee,
          Icons.verified,
          (v) => setState(() {
            _hasAuthenticationFee = v;
            _calculateFees();
          }),
        ),
        const SizedBox(width: 8),
        _feeChip(
          'الانتقال',
          _hasTransferFee,
          Icons.swap_horiz,
          (v) => setState(() {
            _hasTransferFee = v;
            _calculateFees();
          }),
        ),
        const SizedBox(width: 8),
        _feeChip(
          'أخرى',
          _hasOtherFee,
          Icons.more_horiz,
          (v) => setState(() {
            _hasOtherFee = v;
            _calculateFees();
          }),
        ),
      ],
    );
  }

  Widget _feeChip(
    String label,
    bool active,
    IconData icon,
    ValueChanged<bool> onChanged,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(!active),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? AppColors.accent.withValues(alpha: 0.12)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppColors.accent : AppColors.border,
              width: active ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? AppColors.accent : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExemptionSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _isExempted
                ? AppColors.successLight
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isExempted ? AppColors.success : AppColors.border,
            ),
          ),
          child: SwitchListTile(
            title: Text(
              'إعفاء من الرسوم',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: _isExempted ? AppColors.success : AppColors.textPrimary,
              ),
            ),
            secondary: Icon(
              Icons.money_off,
              color: _isExempted ? AppColors.success : AppColors.textSecondary,
            ),
            value: _isExempted,
            onChanged: (v) => setState(() => _isExempted = v),
            activeTrackColor: AppColors.success.withValues(alpha: 0.5),
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (_isExempted) ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _exemptionType,
            decoration: InputDecoration(
              labelText: 'نوع الإعفاء',
              prefixIcon: const Icon(Icons.category, size: 20),
            ),
            items: const [
              DropdownMenuItem(
                value: 'disability',
                child: Text('عجز', style: TextStyle(fontFamily: 'Tajawal')),
              ),
              DropdownMenuItem(
                value: 'poverty',
                child: Text('فقر', style: TextStyle(fontFamily: 'Tajawal')),
              ),
              DropdownMenuItem(
                value: 'social_security',
                child: Text(
                  'ضمان اجتماعي',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
              DropdownMenuItem(
                value: 'special_case',
                child: Text(
                  'حالة خاصة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _exemptionType = v),
          ),
          const SizedBox(height: 8),
          _textField(
            _exemptionReasonCtrl,
            'سبب الإعفاء',
            icon: Icons.text_snippet,
          ),
        ],
      ],
    );
  }

  // ═══════ Guardian Record ═══════
  Widget _buildGuardianRecordSection() {
    String recordType = '';
    switch (_selectedContractTypeId) {
      case 1:
        recordType = 'سجل الزواج';
        break;
      case 7:
        recordType = 'سجل الطلاق';
        break;
      case 8:
        recordType = 'سجل الرجعة';
        break;
      default:
        recordType = 'سجل المحررات';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textField(
          TextEditingController(text: recordType),
          'نوع السجل',
          readOnly: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _textField(
                _guardianRecordBookNumberCtrl,
                'رقم السجل',
                keyboardType: TextInputType.number,
                icon: Icons.menu_book,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _textField(
                _guardianPageNumberCtrl,
                'رقم الصفحة',
                keyboardType: TextInputType.number,
                icon: Icons.find_in_page,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _textField(
                _guardianEntryNumberCtrl,
                'رقم القيد',
                keyboardType: TextInputType.number,
                icon: Icons.tag,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AddEntryState state) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
        child: state.isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_isOnline ? Icons.save : Icons.save_alt, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    _isOnline ? 'حفظ القيد' : 'حفظ محلياً',
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ═══════ Helper Widgets ═══════
  Widget _sectionLabel(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
        color: color ?? AppColors.primary,
      ),
    );
  }

  Widget _textField(
    TextEditingController ctrl,
    String label, {
    TextInputType? keyboardType,
    bool required = false,
    bool readOnly = false,
    int maxLines = 1,
    IconData? icon,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'مطلوب' : null
          : null,
    );
  }

  Widget _dateField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
