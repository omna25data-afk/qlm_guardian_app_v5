import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../admin/presentation/providers/add_entry_provider.dart';
import '../widgets/contract_type_selector.dart';
import '../widgets/parties_section.dart';
import '../widgets/documentation_section.dart';
import '../widgets/guardian_section.dart';
import '../widgets/fees_summary_card.dart';
import '../widgets/form_section_card.dart';

class CompactRegistryEntryScreen extends ConsumerStatefulWidget {
  const CompactRegistryEntryScreen({super.key});

  @override
  ConsumerState<CompactRegistryEntryScreen> createState() =>
      _CompactRegistryEntryScreenState();
}

class _CompactRegistryEntryScreenState
    extends ConsumerState<CompactRegistryEntryScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // ── State ──
  int? _selectedContractTypeId;
  String _writerType = 'guardian';
  int? _selectedGuardianId;
  int? _selectedWriterId;
  int? _selectedOtherWriterId;
  String? _selectedSubtype1;
  String? _selectedSubtype2;
  int? _selectedDocRecordBookId;
  int? _guardianRecordBookId;
  bool _isExempted = false;
  bool _hasAuthenticationFee = false;
  bool _hasTransferFee = false;
  bool _hasOtherFee = false;
  bool _isOnline = true;

  // ── Controllers ──
  final _firstPartyCtrl = TextEditingController();
  final _secondPartyCtrl = TextEditingController();
  final _documentHijriDateCtrl = TextEditingController();
  final _documentGregorianDateCtrl = TextEditingController();
  final _divorceContractNumberCtrl = TextEditingController();
  final _returnDateCtrl = TextEditingController();
  final _docHijriDateCtrl = TextEditingController();
  final _docGregorianDateCtrl = TextEditingController();
  final _docRecordBookNumberCtrl = TextEditingController();
  final _docPageNumberCtrl = TextEditingController();
  final _docEntryNumberCtrl = TextEditingController();
  final _feeAmountCtrl = TextEditingController(text: '0');
  final _penaltyAmountCtrl = TextEditingController(text: '0');
  final _supportAmountCtrl = TextEditingController(text: '0');
  final _sustainabilityAmountCtrl = TextEditingController(text: '200');
  final _totalAmountCtrl = TextEditingController(text: '0');
  final _receiptNumberCtrl = TextEditingController();
  final _guardianRecordBookNumberCtrl = TextEditingController();
  final _guardianPageNumberCtrl = TextEditingController();
  final _guardianEntryNumberCtrl = TextEditingController();
  final Map<String, TextEditingController> _dynamicControllers = {};

  @override
  void initState() {
    super.initState();
    HijriCalendar.setLocal('ar');

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    // Set default dates
    final todayHijri = HijriCalendar.now();
    _documentHijriDateCtrl.text = todayHijri.toString();
    _documentGregorianDateCtrl.text = DateTime.now().toString().split(' ')[0];
    _docHijriDateCtrl.text = todayHijri.toString();
    _docGregorianDateCtrl.text = DateTime.now().toString().split(' ')[0];

    // Monitor connectivity
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (mounted) setState(() => _isOnline = hasConnection);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _firstPartyCtrl.dispose();
    _secondPartyCtrl.dispose();
    _documentHijriDateCtrl.dispose();
    _documentGregorianDateCtrl.dispose();
    _divorceContractNumberCtrl.dispose();
    _returnDateCtrl.dispose();
    _docHijriDateCtrl.dispose();
    _docGregorianDateCtrl.dispose();
    _docRecordBookNumberCtrl.dispose();
    _docPageNumberCtrl.dispose();
    _docEntryNumberCtrl.dispose();
    _feeAmountCtrl.dispose();
    _penaltyAmountCtrl.dispose();
    _supportAmountCtrl.dispose();
    _sustainabilityAmountCtrl.dispose();
    _totalAmountCtrl.dispose();
    _receiptNumberCtrl.dispose();
    _guardianRecordBookNumberCtrl.dispose();
    _guardianPageNumberCtrl.dispose();
    _guardianEntryNumberCtrl.dispose();
    for (final c in _dynamicControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Fee Calculation ──
  void _calculateFees() {
    if (_selectedContractTypeId == null) return;

    final contractId = _selectedContractTypeId!;
    double baseFee = 0;

    if ([1, 7, 8, 4].contains(contractId)) {
      baseFee = 400;
    } else if ([10, 5, 6].contains(contractId)) {
      final formData = ref.read(addEntryProvider).formData;
      final dynamicPrice =
          formData['sale_price'] ?? _dynamicControllers['sale_price']?.text;
      double price = 0;
      if (dynamicPrice != null) {
        price = double.tryParse(dynamicPrice.toString()) ?? 0;
      }
      baseFee = price > 0 ? price * 0.002 : 400;
    } else {
      baseFee = 2000;
    }

    double extra = 0;
    if (_hasAuthenticationFee) extra += 400;
    if (_hasTransferFee) extra += 400;
    if (_hasOtherFee) extra += 400;
    if (_writerType == 'documentation') extra += 400;

    double totalFee = baseFee + extra;
    double support = totalFee * 0.25;
    double sustainability =
        double.tryParse(_sustainabilityAmountCtrl.text) ?? 200;

    setState(() {
      _feeAmountCtrl.text = (baseFee + extra).toStringAsFixed(2);
      _penaltyAmountCtrl.text = '0.00';
      _supportAmountCtrl.text = support.toStringAsFixed(2);
      _totalAmountCtrl.text = (totalFee + support + sustainability)
          .toStringAsFixed(2);
    });
  }

  // ── Submit ──
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedContractTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار نوع العقد'),
          backgroundColor: AppColors.warning,
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
      'doc_hijri_date': _docHijriDateCtrl.text,
      'doc_gregorian_date': _docGregorianDateCtrl.text,
      'doc_record_book_number': int.tryParse(_docRecordBookNumberCtrl.text),
      'doc_page_number': int.tryParse(_docPageNumberCtrl.text),
      'doc_entry_number': int.tryParse(_docEntryNumberCtrl.text),
      'fee_amount': double.tryParse(_feeAmountCtrl.text) ?? 0,
      'penalty_amount': double.tryParse(_penaltyAmountCtrl.text) ?? 0,
      'support_amount': double.tryParse(_supportAmountCtrl.text) ?? 0,
      'sustainability_amount':
          double.tryParse(_sustainabilityAmountCtrl.text) ?? 200,
      'total_amount': double.tryParse(_totalAmountCtrl.text) ?? 0,
      'is_exempted': _isExempted,
      'has_authentication_fee': _hasAuthenticationFee,
      'has_transfer_fee': _hasTransferFee,
      'has_other_fee': _hasOtherFee,
    };

    if (_selectedDocRecordBookId != null) {
      data['documentation_record_book_id'] = _selectedDocRecordBookId;
    }
    if (_writerType == 'guardian') {
      data['guardian_id'] = _selectedGuardianId;
      if (_guardianRecordBookId != null) {
        data['guardian_record_book_id'] = _guardianRecordBookId;
      }
      data['guardian_record_book_number'] = int.tryParse(
        _guardianRecordBookNumberCtrl.text,
      );
      data['guardian_page_number'] = int.tryParse(_guardianPageNumberCtrl.text);
      data['guardian_entry_number'] = int.tryParse(
        _guardianEntryNumberCtrl.text,
      );
    } else if (_writerType == 'documentation') {
      data['writer_id'] = _selectedWriterId;
    } else if (_writerType == 'external') {
      data['other_writer_id'] = _selectedOtherWriterId;
    }

    if (_selectedSubtype1 != null) data['subtype_1'] = _selectedSubtype1;
    if (_selectedSubtype2 != null) data['subtype_2'] = _selectedSubtype2;

    if (_selectedContractTypeId == 8) {
      data['divorce_contract_number'] = _divorceContractNumberCtrl.text;
      data['return_date'] = _returnDateCtrl.text;
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
                _isOnline
                    ? 'تم الحفظ بنجاح'
                    : 'تم الحفظ محلياً - سيُرفع عند الاتصال',
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
      Navigator.pop(context);
    }
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
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Connectivity banner
                      if (!_isOnline) _buildOfflineBanner(),

                      // Contract Type
                      ContractTypeSelector(
                        contractTypes: state.contractTypes,
                        selectedId: _selectedContractTypeId,
                        onSelected: _onContractTypeSelected,
                      ),
                      const SizedBox(height: 20),

                      // Parties & Writer
                      FormSectionCard(
                        title: 'الكاتب والأطراف',
                        icon: Icons.people_alt,
                        accentColor: AppColors.primary,
                        child: PartiesSection(
                          selectedContractTypeId: _selectedContractTypeId,
                          writerType: _writerType,
                          selectedGuardianId: _selectedGuardianId,
                          firstPartyController: _firstPartyCtrl,
                          secondPartyController: _secondPartyCtrl,
                          documentHijriDateController: _documentHijriDateCtrl,
                          documentGregorianDateController:
                              _documentGregorianDateCtrl,
                          divorceContractNumberController:
                              _divorceContractNumberCtrl,
                          returnDateController: _returnDateCtrl,
                          dynamicControllers: _dynamicControllers,
                          selectedSubtype1: _selectedSubtype1,
                          selectedSubtype2: _selectedSubtype2,
                          onSubtype1Changed: (v) =>
                              setState(() => _selectedSubtype1 = v),
                          onSubtype2Changed: (v) =>
                              setState(() => _selectedSubtype2 = v),
                          onWriterTypeChanged: (v) {
                            setState(() => _writerType = v);
                            _calculateFees();
                          },
                          onGuardianChanged: (v) =>
                              setState(() => _selectedGuardianId = v),
                          onFeesRecalculate: _calculateFees,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Documentation
                      FormSectionCard(
                        title: 'التوثيق',
                        icon: Icons.description,
                        accentColor: AppColors.accent,
                        child: DocumentationSection(
                          selectedContractTypeId: _selectedContractTypeId,
                          selectedDocRecordBookId: _selectedDocRecordBookId,
                          docHijriDateCtrl: _docHijriDateCtrl,
                          docGregorianDateCtrl: _docGregorianDateCtrl,
                          docRecordBookNumberCtrl: _docRecordBookNumberCtrl,
                          docPageNumberCtrl: _docPageNumberCtrl,
                          docEntryNumberCtrl: _docEntryNumberCtrl,
                          feeAmountCtrl: _feeAmountCtrl,
                          penaltyAmountCtrl: _penaltyAmountCtrl,
                          supportAmountCtrl: _supportAmountCtrl,
                          sustainabilityAmountCtrl: _sustainabilityAmountCtrl,
                          totalAmountCtrl: _totalAmountCtrl,
                          receiptNumberCtrl: _receiptNumberCtrl,
                          isExempted: _isExempted,
                          hasAuthenticationFee: _hasAuthenticationFee,
                          hasTransferFee: _hasTransferFee,
                          hasOtherFee: _hasOtherFee,
                          onDocRecordBookChanged: (v) =>
                              setState(() => _selectedDocRecordBookId = v),
                          onExemptedChanged: (v) =>
                              setState(() => _isExempted = v),
                          onAuthFeeChanged: (v) =>
                              setState(() => _hasAuthenticationFee = v),
                          onTransferFeeChanged: (v) =>
                              setState(() => _hasTransferFee = v),
                          onOtherFeeChanged: (v) =>
                              setState(() => _hasOtherFee = v),
                          onFeesRecalculate: _calculateFees,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Fees Summary
                      FeesSummaryCard(
                        feeAmount: _feeAmountCtrl.text,
                        penaltyAmount: _penaltyAmountCtrl.text,
                        supportAmount: _supportAmountCtrl.text,
                        sustainabilityAmount: _sustainabilityAmountCtrl.text,
                        totalAmount: _totalAmountCtrl.text,
                        isExempted: _isExempted,
                      ),
                      const SizedBox(height: 16),

                      // Guardian (if writer is guardian)
                      if (_writerType == 'guardian')
                        FormSectionCard(
                          title: 'بيانات سجل الأمين',
                          icon: Icons.verified_user,
                          accentColor: AppColors.success,
                          isCollapsible: true,
                          child: GuardianSection(
                            guardianRecordBookId: _guardianRecordBookId,
                            recordBookNumberCtrl: _guardianRecordBookNumberCtrl,
                            pageNumberCtrl: _guardianPageNumberCtrl,
                            entryNumberCtrl: _guardianEntryNumberCtrl,
                            onRecordBookIdChanged: (v) =>
                                setState(() => _guardianRecordBookId = v),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Submit Button
                      _buildSubmitButton(state),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _onContractTypeSelected(int typeId) {
    setState(() {
      _selectedContractTypeId = typeId;
      _selectedSubtype1 = null;
      _selectedSubtype2 = null;
    });
    _calculateFees();
    final notifier = ref.read(addEntryProvider.notifier);
    notifier.loadDocumentationRecordBooks(typeId);
    notifier.loadFormFields(typeId);
    notifier.loadSubtypes(typeId);
  }

  PreferredSizeWidget _buildAppBar(AddEntryState state) {
    return AppBar(
      title: const Text('إضافة قيد جديد'),
      actions: [
        // Online/Offline indicator
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
        const SizedBox(width: 8),
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
              'أنت غير متصل بالإنترنت. سيُحفظ القيد محلياً ويُرفع تلقائياً عند الاتصال.',
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

  Widget _buildSubmitButton(AddEntryState state) {
    return SizedBox(
      height: 52,
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
}
