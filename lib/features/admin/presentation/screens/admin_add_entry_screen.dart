// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../providers/add_entry_provider.dart';
import '../providers/admin_pending_entries_provider.dart';
import '../../../records/data/models/record_book.dart';

/// Contract type label helpers (matches Filament RegistryEntryForm)
const Map<int, Map<String, String>> _contractPartyLabels = {
  1: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'}, // زواج
  7: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'}, // طلاق
  8: {'first': 'اسم الزوج المراجع', 'second': 'اسم الزوجة'}, // رجعة
  4: {'first': 'اسم الموكل', 'second': 'اسم الوكيل'}, // وكالة
  5: {'first': 'اسم المتصرف', 'second': 'اسم المتصرف إليه'}, // تصرف
  6: {'first': 'اسم المؤرث', 'second': 'أسماء الورثة'}, // قسمة
  10: {'first': 'اسم البائع', 'second': 'اسم المشتري'}, // مبيع
};

class AdminAddEntryScreen extends ConsumerStatefulWidget {
  const AdminAddEntryScreen({super.key});

  @override
  ConsumerState<AdminAddEntryScreen> createState() =>
      _AdminAddEntryScreenState();
}

class _AdminAddEntryScreenState extends ConsumerState<AdminAddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // ── Section 1: Contract & Parties ──
  int? _selectedContractTypeId;
  String _writerType = 'guardian'; // guardian, documentation, external
  int? _selectedGuardianId;
  int? _selectedWriterId; // For documentation writer
  int? _selectedOtherWriterId; // For external writer

  final _firstPartyController = TextEditingController();
  final _secondPartyController = TextEditingController();
  final _documentHijriDateController = TextEditingController();
  final _documentGregorianDateController = TextEditingController();
  final _notesController = TextEditingController();

  // Return-specific (رجعة)
  final _divorceContractNumberController = TextEditingController();
  final _returnDateController = TextEditingController();

  // Sale-specific (مبيع)
  final _salePriceController = TextEditingController();
  final _saleAreaController = TextEditingController();
  final _deedNumberController = TextEditingController();
  final _propertyLocationController = TextEditingController();
  final _propertyBoundariesController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  // Disposition-specific (تصرف)
  final _dispositionSubjectController = TextEditingController();

  // Subtypes
  String? _selectedSubtype1;
  String? _selectedSubtype2;

  // Sale/Disposition Tax Fields
  final _taxAmountController = TextEditingController(text: '0');
  final _taxReceiptNumberController = TextEditingController();
  final _zakatAmountController = TextEditingController(text: '0');
  final _zakatReceiptNumberController = TextEditingController();

  // ── Section 2: Documentation Record Data (قلم التوثيق) ──
  int? _selectedDocRecordBookId; // For documentation record book selection
  final _docHijriDateController = TextEditingController();
  final _docGregorianDateController = TextEditingController();
  final _docEntryNumberController = TextEditingController();
  final _docPageNumberController = TextEditingController();
  final _docRecordBookNumberController = TextEditingController();
  final _docBoxNumberController = TextEditingController();
  final _docDocumentNumberController = TextEditingController();
  final _receiptNumberController = TextEditingController();
  final _feeAmountController = TextEditingController(text: '0');
  final _penaltyAmountController = TextEditingController(text: '0');
  final _supportAmountController = TextEditingController(text: '0');
  final _sustainabilityAmountController = TextEditingController(text: '200');
  final _totalAmountController = TextEditingController(text: '0');

  bool _isExempted = false;
  String? _exemptionType;
  final _exemptionReasonController = TextEditingController();
  bool _hasAuthenticationFee = false;
  bool _hasTransferFee = false;
  bool _hasOtherFee = false;

  // ── Section 3: Guardian Record Data (سجل الأمين) ──
  final _guardianRecordBookNumberController = TextEditingController();
  final _guardianPageNumberController = TextEditingController();
  final _guardianEntryNumberController = TextEditingController();

  @override
  void dispose() {
    _firstPartyController.dispose();
    _secondPartyController.dispose();
    _documentHijriDateController.dispose();
    _documentGregorianDateController.dispose();
    _notesController.dispose();
    _divorceContractNumberController.dispose();
    _returnDateController.dispose();
    _salePriceController.dispose();
    _saleAreaController.dispose();
    _deedNumberController.dispose();
    _propertyLocationController.dispose();
    _propertyBoundariesController.dispose();
    _itemDescriptionController.dispose();
    _dispositionSubjectController.dispose();
    _docHijriDateController.dispose();
    _docGregorianDateController.dispose();
    _docEntryNumberController.dispose();
    _docPageNumberController.dispose();
    _docRecordBookNumberController.dispose();
    _docBoxNumberController.dispose();
    _docDocumentNumberController.dispose();
    _receiptNumberController.dispose();
    _feeAmountController.dispose();
    _penaltyAmountController.dispose();
    _supportAmountController.dispose();
    _sustainabilityAmountController.dispose();
    _totalAmountController.dispose();
    _exemptionReasonController.dispose();
    _guardianRecordBookNumberController.dispose();
    _guardianPageNumberController.dispose();
    _guardianEntryNumberController.dispose();
    _taxAmountController.dispose();
    _taxReceiptNumberController.dispose();
    _zakatAmountController.dispose();
    _zakatReceiptNumberController.dispose();
    super.dispose();
  }

  /// Calculate fees based on contract type and sale price (mirrors RegistryEntryForm::calculateFees)
  void _calculateFees() {
    if (_selectedContractTypeId == null) return;

    final nonFinancial = [1, 7, 8, 4];
    final financial = [10, 5, 6];
    double baseFee = 0;
    double penalty = 0;

    if (nonFinancial.contains(_selectedContractTypeId)) {
      baseFee = 400;
    } else if (financial.contains(_selectedContractTypeId)) {
      final salePrice = double.tryParse(_salePriceController.text) ?? 0;
      baseFee = salePrice > 0 ? salePrice * 0.002 : 400;
    } else {
      baseFee = 2000;
    }

    // Additional fees
    double additionalFees = 0;
    if (_hasAuthenticationFee) additionalFees += 400;
    if (_hasTransferFee) additionalFees += 400;
    if (_hasOtherFee) additionalFees += 400;
    if (_writerType == 'documentation') additionalFees += 400;

    final totalFee = baseFee + penalty;
    final support = totalFee * 0.25;
    final sustainability =
        double.tryParse(_sustainabilityAmountController.text) ?? 200;
    final total = totalFee + support + sustainability;

    setState(() {
      _feeAmountController.text = (baseFee + additionalFees).toStringAsFixed(0);
      _penaltyAmountController.text = penalty.toStringAsFixed(0);
      _supportAmountController.text = support.toStringAsFixed(0);
      _totalAmountController.text = total.toStringAsFixed(0);
    });
  }

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
      'first_party_name': _firstPartyController.text,
      'second_party_name': _secondPartyController.text,
      'writer_type': _writerType,
      'document_hijri_date': _documentHijriDateController.text,
      'document_gregorian_date': _documentGregorianDateController.text,
      'transaction_date': _documentGregorianDateController.text,
      'notes': _notesController.text,
      'status': 'draft',
    };

    // Guardian ID
    if (_writerType == 'guardian' && _selectedGuardianId != null) {
      data['guardian_id'] = _selectedGuardianId;
    }

    // Contract-type specific fields
    if (_selectedContractTypeId == 8) {
      data['divorce_contract_number'] = _divorceContractNumberController.text;
      data['return_date'] = _returnDateController.text;
    }
    if (_selectedContractTypeId == 10 || _selectedContractTypeId == 5) {
      data['subtype_1'] = _selectedSubtype1;
      data['subtype_2'] = _selectedSubtype2;
    }
    if (_selectedContractTypeId == 10) {
      data['sale_price'] = double.tryParse(_salePriceController.text) ?? 0;
      data['sale_area'] = _saleAreaController.text;
      data['deed_number'] = _deedNumberController.text;
      data['property_location'] = _propertyLocationController.text;
      data['property_boundaries'] = _propertyBoundariesController.text;
      data['item_description'] = _itemDescriptionController.text;
    }
    if (_selectedContractTypeId == 5) {
      data['disposition_subject'] = _dispositionSubjectController.text;
    }

    // Documentation Record data
    data['doc_hijri_date'] = _docHijriDateController.text;
    data['doc_gregorian_date'] = _docGregorianDateController.text;
    data['doc_entry_number'] = int.tryParse(_docEntryNumberController.text);
    data['doc_page_number'] = int.tryParse(_docPageNumberController.text);
    data['doc_record_book_number'] = int.tryParse(
      _docRecordBookNumberController.text,
    );
    data['doc_box_number'] = int.tryParse(_docBoxNumberController.text);
    data['doc_document_number'] = int.tryParse(
      _docDocumentNumberController.text,
    );
    data['receipt_number'] = _receiptNumberController.text;

    // Fees
    data['fee_amount'] = double.tryParse(_feeAmountController.text) ?? 0;
    data['penalty_amount'] =
        double.tryParse(_penaltyAmountController.text) ?? 0;
    data['support_amount'] =
        double.tryParse(_supportAmountController.text) ?? 0;
    data['sustainability_amount'] =
        double.tryParse(_sustainabilityAmountController.text) ?? 200;
    data['total_amount'] = double.tryParse(_totalAmountController.text) ?? 0;
    data['is_exempted'] = _isExempted;
    data['exemption_type'] = _exemptionType;
    data['exemption_reason'] = _exemptionReasonController.text;
    data['has_authentication_fee'] = _hasAuthenticationFee;
    data['has_transfer_fee'] = _hasTransferFee;
    data['has_other_fee'] = _hasOtherFee;

    // Guardian Record data
    if (_writerType == 'guardian') {
      data['guardian_page_number'] = int.tryParse(
        _guardianPageNumberController.text,
      );
      data['guardian_entry_number'] = int.tryParse(
        _guardianEntryNumberController.text,
      );
      data['guardian_record_book_number'] = int.tryParse(
        _guardianRecordBookNumberController.text,
      );
      // Ensure guardian_id is set
      if (_selectedGuardianId != null) {
        data['guardian_id'] = _selectedGuardianId;
      }
    } else if (_writerType == 'documentation') {
      if (_selectedWriterId != null) {
        data['writer_id'] = _selectedWriterId;
      }
    } else if (_writerType == 'external') {
      if (_selectedOtherWriterId != null) {
        data['other_writer_id'] = _selectedOtherWriterId;
      }
    }

    // Tax & Zakat
    if (_selectedContractTypeId == 10 || _selectedContractTypeId == 5) {
      data['tax_amount'] = double.tryParse(_taxAmountController.text) ?? 0;
      data['tax_receipt_number'] = _taxReceiptNumberController.text;
    }
    if (_selectedContractTypeId == 10) {
      data['zakat_amount'] = double.tryParse(_zakatAmountController.text) ?? 0;
      data['zakat_receipt_number'] = _zakatReceiptNumberController.text;
    }

    // Documentation Record Book ID (CRITICAL)
    if (_selectedDocRecordBookId != null) {
      data['documentation_record_book_id'] = _selectedDocRecordBookId;
      // Also send record_book_id as a fallback/alias if needed by backend,
      // but documentation_record_book_id is specific.
      // The backend might expect 'record_book_id' for the main record book relation.
      // In V5, registry_entries table has 'documentation_record_book_id'.
    }

    // Remove null values
    data.removeWhere((key, value) => value == null || value == '');

    // Ensure record_book_id is set (required by backend)
    // The backend store method expects 'record_book_id'
    // We'll need to get this from the guardian selection or from guardianRecordBookNumber
    // For now if admin, we set it based on guardian context

    final success = await ref.read(addEntryProvider.notifier).submitEntry(data);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ القيد بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
      // Refresh pending entries
      ref
          .read(adminPendingEntriesProvider.notifier)
          .fetchEntries(refresh: true);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEntryProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'إضافة قيد جديد',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة قيد جديد',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        actions: [
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
              icon: const Icon(Icons.save, color: Colors.white),
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
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          type: StepperType.vertical,
          physics: const ClampingScrollPhysics(),
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: details.onStepContinue,
                    child: Text(
                      _currentStep == 2 ? 'حفظ القيد' : 'التالي',
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text(
                        'السابق',
                        style: TextStyle(fontFamily: 'Tajawal'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text(
                'بيانات المحرر والأطراف',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _selectedContractTypeId != null
                    ? state.contractTypes
                              .firstWhere(
                                (c) => c['id'] == _selectedContractTypeId,
                                orElse: () => {'name': ''},
                              )['name']
                              ?.toString() ??
                          ''
                    : 'اختر نوع العقد',
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              content: _buildSection1(state),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text(
                'بيانات القيد في قلم التوثيق',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'الرسوم والأرقام الرسمية',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
              content: _buildSection2(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text(
                'بيانات سجل الأمين',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _writerType == 'guardian'
                    ? 'مطلوب'
                    : 'غير مطلوب (الكاتب ليس أميناً)',
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              content: _buildSection3(state),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════ Section 1: Contract & Parties ═══════════
  Widget _buildSection1(AddEntryState state) {
    final labels =
        _contractPartyLabels[_selectedContractTypeId] ??
        {'first': 'الطرف الأول', 'second': 'الطرف الثاني'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Error message
        if (state.error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Text(
              state.error!,
              style: const TextStyle(
                color: AppColors.error,
                fontFamily: 'Tajawal',
              ),
            ),
          ),

        // ── Contract Type Selection ──
        _sectionLabel('نوع العقد *'),
        const SizedBox(height: 8),
        SearchableDropdown<Map<String, dynamic>>(
          items: state.contractTypes,
          label: 'نوع العقد *',
          hint: 'اختر نوع العقد',
          value: _selectedContractTypeId != null
              ? state.contractTypes.firstWhere(
                  (element) => element['id'] == _selectedContractTypeId,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (item) => item['name']?.toString() ?? '',
          onChanged: (item) {
            if (item == null) return;
            final id = item['id'] is int
                ? item['id'] as int
                : int.tryParse(item['id'].toString()) ?? 0;

            setState(() {
              _selectedContractTypeId = id;
              _selectedSubtype1 = null;
              _selectedSubtype2 = null;
            });
            ref.read(addEntryProvider.notifier).loadSubtypes(id);
            ref
                .read(addEntryProvider.notifier)
                .loadDocumentationRecordBooks(id);
            _calculateFees();
          },
          validator: (item) => item == null || item.isEmpty ? 'مطلوب' : null,
        ),

        const Divider(height: 32),

        // ── Writer Type ──
        _sectionLabel('نوع الكاتب *'),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'guardian',
              label: Text(
                'أمين شرعي',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              ),
            ),
            ButtonSegment(
              value: 'documentation',
              label: Text(
                'قلم التوثيق',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              ),
            ),
            ButtonSegment(
              value: 'external',
              label: Text(
                'آخرون',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              ),
            ),
          ],
          selected: {_writerType},
          onSelectionChanged: (sel) {
            setState(() => _writerType = sel.first);
            _calculateFees();
          },
        ),

        // ── Writer Selector ──
        if (_writerType == 'guardian') ...[
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          SearchableDropdown<Map<String, dynamic>>(
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
              if (item != null) {
                setState(() => _selectedGuardianId = item['id'] as int);
              }
            },
            validator: (item) =>
                _writerType == 'guardian' && (item == null || item.isEmpty)
                ? 'مطلوب'
                : null,
          ),
        ] else if (_writerType == 'documentation') ...[
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          SearchableDropdown<Map<String, dynamic>>(
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
          ),
        ] else if (_writerType == 'external') ...[
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          SearchableDropdown<Map<String, dynamic>>(
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
              if (item != null) {
                setState(() => _selectedOtherWriterId = item['id'] as int);
              }
            },
            validator: (item) =>
                _writerType == 'external' && (item == null || item.isEmpty)
                ? 'مطلوب'
                : null,
          ),
        ],

        const Divider(height: 32),

        // ── Party Names ──
        _sectionLabel(labels['first']!),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _firstPartyController,
          label: labels['first']!,
          required: true,
        ),
        const SizedBox(height: 16),
        _sectionLabel(labels['second']!),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _secondPartyController,
          label: labels['second']!,
          required: true,
        ),

        // ── Contract-type Specific Fields ──
        if (_selectedContractTypeId == 8) ..._buildReturnFields(),
        if (_selectedContractTypeId == 10) ..._buildSaleFields(state),
        if (_selectedContractTypeId == 5) ..._buildDispositionFields(state),

        const Divider(height: 32),

        // ── Dates ──
        _sectionLabel('تاريخ المحرر'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildHijriDateField(
                controller: _documentHijriDateController,
                label: 'التاريخ الهجري',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                controller: _documentGregorianDateController,
                label: 'التاريخ الميلادي',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        _buildTextField(
          controller: _notesController,
          label: 'ملاحظات',
          maxLines: 3,
        ),
      ],
    );
  }

  // ── Return-specific fields (رجعة) ──
  List<Widget> _buildReturnFields() {
    return [
      const SizedBox(height: 16),
      _sectionLabel('بيانات الرجعة'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _divorceContractNumberController,
        label: 'رقم عقد الطلاق',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      _buildDateField(controller: _returnDateController, label: 'تاريخ الرجعة'),
    ];
  }

  // ── Sale-specific fields (مبيع) ──
  List<Widget> _buildSaleFields(AddEntryState state) {
    return [
      const SizedBox(height: 16),
      _sectionLabel('بيانات المبيع'),
      const SizedBox(height: 8),

      // Subtypes
      if (state.subtypes1.isNotEmpty) ...[
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes1,
          label: 'نوع المبيع',
          hint: 'اختر نوع المبيع',
          value: _selectedSubtype1 != null
              ? state.subtypes1.firstWhere(
                  (s) =>
                      (s['code']?.toString() ?? s['name']?.toString()) ==
                      _selectedSubtype1,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (item) => item['name']?.toString() ?? '',
          onChanged: (item) {
            if (item == null) return;
            final code = item['code']?.toString() ?? item['name']?.toString();
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
        const SizedBox(height: 16),
      ],

      if (state.subtypes2.isNotEmpty) ...[
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes2,
          label: 'النوع الفرعي',
          hint: 'اختر النوع الفرعي',
          value: _selectedSubtype2 != null
              ? state.subtypes2.firstWhere(
                  (s) =>
                      (s['code']?.toString() ?? s['name']?.toString()) ==
                      _selectedSubtype2,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (item) => item['name']?.toString() ?? '',
          onChanged: (item) {
            if (item == null) return;
            final code = item['code']?.toString() ?? item['name']?.toString();
            setState(() => _selectedSubtype2 = code);
          },
        ),
        const SizedBox(height: 16),
      ],

      _buildTextField(
        controller: _salePriceController,
        label: 'ثمن المبيع (ر.ي)',
        keyboardType: TextInputType.number,
        onChanged: (_) => _calculateFees(),
      ),
      const SizedBox(height: 16),
      _buildTextField(controller: _saleAreaController, label: 'المساحة'),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _deedNumberController,
        label: 'رقم الصك/الوثيقة',
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _propertyLocationController,
        label: 'موقع العقار',
        maxLines: 2,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _propertyBoundariesController,
        label: 'الحدود',
        maxLines: 2,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _itemDescriptionController,
        label: 'وصف المبيع (للمنقول)',
        maxLines: 2,
      ),
    ];
  }

  // ── Disposition-specific fields (تصرف) ──
  List<Widget> _buildDispositionFields(AddEntryState state) {
    return [
      const SizedBox(height: 16),
      _sectionLabel('بيانات التصرف'),
      const SizedBox(height: 8),

      if (state.subtypes1.isNotEmpty) ...[
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes1,
          label: 'نوع التصرف',
          hint: 'اختر نوع التصرف',
          value: _selectedSubtype1 != null
              ? state.subtypes1.firstWhere(
                  (s) =>
                      (s['code']?.toString() ?? s['name']?.toString()) ==
                      _selectedSubtype1,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (item) => item['name']?.toString() ?? '',
          onChanged: (item) {
            if (item == null) return;
            final code = item['code']?.toString() ?? item['name']?.toString();
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
        const SizedBox(height: 16),
      ],

      _buildTextField(
        controller: _dispositionSubjectController,
        label: 'موضوع التصرف',
        maxLines: 3,
      ),
    ];
  }

  // ═══════════ Section 2: Documentation Record ═══════════
  Widget _buildSection2() {
    final state = ref.watch(addEntryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Documentation Record Book Selector
        // Documentation Record Book Selector
        _sectionLabel('سجل التوثيق *'),
        const SizedBox(height: 8),
        SearchableDropdown<RecordBook>(
          items: state.documentationRecordBooks,
          label: 'سجل التوثيق *',
          hint: 'اختر سجل التوثيق',
          value: _selectedDocRecordBookId != null
              ? state.documentationRecordBooks.firstWhere(
                  (b) => b.id == _selectedDocRecordBookId,
                  orElse: () => RecordBook(
                    id: -1,
                    bookNumber: 0,
                    name: 'غير محدد',
                    category: '',
                    hijriYear: 1400,
                    totalPages: 0,
                    constraintsPerPage: 0,
                    startConstraintNumber: 0,
                    endConstraintNumber: 0,
                    createdBy: 0,
                    status: '',
                    isActive: false,
                  ),
                )
              : null,
          itemLabelBuilder: (b) =>
              '${b.bookNumber} - ${b.hijriYear} (ص: ${b.currentPageNumber})',
          onChanged: (book) {
            if (book != null && book.id != -1) {
              setState(() => _selectedDocRecordBookId = book.id);
            }
          },
          validator: (book) => book == null || book.id == -1 ? 'مطلوب' : null,
        ),
        const SizedBox(height: 16),

        // Documentation Dates
        _sectionLabel('تاريخ التوثيق'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildHijriDateField(
                controller: _docHijriDateController,
                label: 'التاريخ الهجري',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                controller: _docGregorianDateController,
                label: 'التاريخ الميلادي',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _sectionLabel('أرقام القيد'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _docEntryNumberController,
                label: 'رقم القيد',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _docPageNumberController,
                label: 'رقم الصفحة',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _docRecordBookNumberController,
                label: 'رقم السجل',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _docBoxNumberController,
                label: 'رقم الصندوق',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _docDocumentNumberController,
          label: 'رقم الوثيقة',
          keyboardType: TextInputType.number,
        ),

        const Divider(height: 32),

        // Tax Fields (Sale & Disposition)
        if (_selectedContractTypeId == 10 || _selectedContractTypeId == 5) ...[
          _sectionLabel('ضريبة التصرفات العقارية'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _taxAmountController,
                  label: 'مبلغ الضريبة',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _taxReceiptNumberController,
                  label: 'رقم سند السداد',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Zakat Fields (Sale Only)
        if (_selectedContractTypeId == 10) ...[
          _sectionLabel('الزكاة'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _zakatAmountController,
                  label: 'مبلغ الزكاة',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _zakatReceiptNumberController,
                  label: 'رقم سند السداد',
                ),
              ),
            ],
          ),
          const Divider(height: 32),
        ],

        // ── Fees ──
        _sectionLabel('الرسوم'),
        const SizedBox(height: 8),
        // ... Fees fields ...
        _buildTextField(
          controller: _receiptNumberController,
          label: 'رقم سند القبض',
        ),
        const SizedBox(height: 16),

        // Fee Details
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildFeeRow(
                'الرسوم الأساسية',
                _feeAmountController,
                readOnly: true,
              ),
              const SizedBox(height: 8),
              _buildFeeRow('الغرامة', _penaltyAmountController, readOnly: true),
              const SizedBox(height: 8),
              _buildFeeRow(
                'دعم القضاء (25%)',
                _supportAmountController,
                readOnly: true,
              ),
              const SizedBox(height: 8),
              _buildFeeRow('صندوق الاستدامة', _sustainabilityAmountController),
              const Divider(),
              _buildFeeRow(
                'الإجمالي',
                _totalAmountController,
                readOnly: true,
                isTotal: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Exemptions & Additional Fees
        CheckboxListTile(
          value: _hasAuthenticationFee,
          title: const Text(
            'رسوم المصادقة (+400)',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          onChanged: (v) {
            setState(() => _hasAuthenticationFee = v ?? false);
            _calculateFees();
          },
        ),
        CheckboxListTile(
          value: _hasTransferFee,
          title: const Text(
            'رسوم الانتقال (+400)',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          onChanged: (v) {
            setState(() => _hasTransferFee = v ?? false);
            _calculateFees();
          },
        ),
        CheckboxListTile(
          value: _hasOtherFee,
          title: const Text(
            'رسوم أخرى (+400)',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          onChanged: (v) {
            setState(() => _hasOtherFee = v ?? false);
            _calculateFees();
          },
        ),

        const Divider(),
        CheckboxListTile(
          value: _isExempted,
          title: const Text(
            'إعفاء من الرسوم',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          onChanged: (v) => setState(() => _isExempted = v ?? false),
        ),
        if (_isExempted) ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _exemptionType,
            decoration: _inputDecoration('نوع الإعفاء'),
            items: const [
              DropdownMenuItem(
                value: 'disability',
                child: Text('عجز', style: TextStyle(fontFamily: 'Tajawal')),
              ),
              DropdownMenuItem(
                value: 'poverty',
                child: Text('فكر', style: TextStyle(fontFamily: 'Tajawal')),
              ), // فقر (typo in V4?) assuming poverty
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
          _buildTextField(
            controller: _exemptionReasonController,
            label: 'سبب الإعفاء',
          ),
        ],
      ],
    );
  }

  Widget _buildFeeRow(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: readOnly,
                fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
              ),
              onChanged: (_) => _calculateFees(),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════ Section 3: Guardian Record ═══════════
  Widget _buildSection3(AddEntryState state) {
    if (_writerType != 'guardian') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'هذا القسم مطلوب فقط عندما يكون الكاتب أميناً شرعياً',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('بيانات القيد في سجل الأمين'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _guardianRecordBookNumberController,
          label: 'رقم السجل',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _guardianPageNumberController,
                label: 'رقم الصفحة',
                keyboardType: TextInputType.number,
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _guardianEntryNumberController,
                label: 'رقم القيد',
                keyboardType: TextInputType.number,
                required: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════ Helper Widgets ═══════════

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
        color: AppColors.primary,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    bool required = false,
    bool readOnly = false,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.grey.shade50,
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
          : null,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          controller.text =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        }
      },
    );
  }

  Widget _buildHijriDateField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      onTap: () async {
        final HijriCalendar? selectedDate = await showHijriDatePicker(
          context: context,
          initialDate: HijriCalendar.now(),
          lastDate: HijriCalendar()
            ..hYear = 1500
            ..hMonth = 12
            ..hDay = 30,
          firstDate: HijriCalendar()
            ..hYear = 1300
            ..hMonth = 1
            ..hDay = 1,
          initialDatePickerMode: DatePickerMode.day,
        );

        if (selectedDate != null) {
          controller.text = selectedDate.toString(); // Returns dd/mm/yyyy
        }
      },
    );
  }
}
