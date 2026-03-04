import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../admin/presentation/providers/add_entry_provider.dart';
import '../../../../features/system/data/models/registry_entry_sections.dart';
import '../widgets/parties_section.dart';
import '../widgets/documentation_section.dart';
import '../widgets/guardian_section.dart';
import '../widgets/fees_summary_card.dart';
import '../widgets/form_section_card.dart';
import '../widgets/dynamic_field_builder.dart';

class CompactRegistryEntryScreen extends ConsumerStatefulWidget {
  final RegistryEntrySections? initialData;

  const CompactRegistryEntryScreen({super.key, this.initialData});

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
  final _guardianHijriDateCtrl = TextEditingController();
  final _guardianGregorianDateCtrl = TextEditingController();
  final _taxAmountCtrl = TextEditingController();
  final _taxReceiptNumberCtrl = TextEditingController();
  final _zakatAmountCtrl = TextEditingController();
  final _zakatReceiptNumberCtrl = TextEditingController();
  final _exemptionReasonCtrl = TextEditingController();
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

    _initializeData();

    // Monitor connectivity
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (mounted) setState(() => _isOnline = hasConnection);
    });
    _documentHijriDateCtrl.addListener(_syncGuardianDateWithDocument);
    _docHijriDateCtrl.addListener(_syncGuardianDateWithDocumentation);
  }

  void _syncGuardianDateWithDocument() {
    // Sync only if writer is guardian
    if (_writerType == 'guardian' && _documentHijriDateCtrl.text.isNotEmpty) {
      _guardianHijriDateCtrl.text = _documentHijriDateCtrl.text;
      _guardianGregorianDateCtrl.text = _documentGregorianDateCtrl.text;
    }
  }

  void _syncGuardianDateWithDocumentation() {
    // If documentation date changes and writer is documentation, you might want to sync,
    // but the guardian date is mainly used for guardian. If the user wants to sync when documentation date changes:
    if (_docHijriDateCtrl.text.isNotEmpty) {
      _guardianHijriDateCtrl.text = _docHijriDateCtrl.text;
      _guardianGregorianDateCtrl.text = _docGregorianDateCtrl.text;
    }
  }

  void _initializeData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _selectedContractTypeId = data.basicInfo.contractTypeId;
      _firstPartyCtrl.text = data.basicInfo.firstPartyName;
      _secondPartyCtrl.text = data.basicInfo.secondPartyName;
      _documentHijriDateCtrl.text = data.documentInfo.documentHijriDate ?? '';
      _documentGregorianDateCtrl.text =
          data.documentInfo.documentGregorianDate ?? '';

      _writerType = data.writerInfo.writerType ?? 'guardian';

      if (_writerType == 'guardian') {
        _selectedGuardianId = data.writerInfo.writerId;
      } else if (_writerType == 'documentation') {
        _selectedWriterId = data.writerInfo.writerId;
      } else if (_writerType == 'external') {
        _selectedOtherWriterId =
            data.writerInfo.otherWriterId ?? data.writerInfo.writerId;
      }

      // Financial — جميع الحقول المالية
      _feeAmountCtrl.text = data.financialInfo.feeAmount?.toString() ?? '0';
      _penaltyAmountCtrl.text =
          data.financialInfo.penaltyAmount?.toString() ?? '0';
      _supportAmountCtrl.text =
          data.financialInfo.supportAmount?.toString() ?? '0';
      _sustainabilityAmountCtrl.text =
          data.financialInfo.sustainabilityAmount?.toString() ?? '200';
      _totalAmountCtrl.text = data.financialInfo.totalAmount.toString();
      _receiptNumberCtrl.text = data.financialInfo.receiptNumber ?? '';
      if (data.financialInfo.exemptionType != null) {
        _isExempted = true;
        _exemptionReasonCtrl.text = data.financialInfo.exemptionReason ?? '';
      }

      // الضريبة والزكاة — من بيانات العقد الفرعي (contract_details)
      if (data.formData != null) {
        _taxAmountCtrl.text = data.formData!['tax_amount']?.toString() ?? '';
        _taxReceiptNumberCtrl.text =
            data.formData!['tax_receipt_number']?.toString() ?? '';
        _zakatAmountCtrl.text =
            data.formData!['zakat_amount']?.toString() ?? '';
        _zakatReceiptNumberCtrl.text =
            data.formData!['zakat_receipt_number']?.toString() ?? '';
      }

      // رسوم المصادقة والانتقال والأخرى — من المبالغ أو الأعلام
      _hasAuthenticationFee =
          data.financialInfo.hasAuthenticationFee ||
          (data.financialInfo.authenticationFeeAmount != null &&
              data.financialInfo.authenticationFeeAmount! > 0);
      _hasTransferFee =
          data.financialInfo.hasTransferFee ||
          (data.financialInfo.transferFeeAmount != null &&
              data.financialInfo.transferFeeAmount! > 0);
      _hasOtherFee =
          data.financialInfo.hasOtherFee ||
          (data.financialInfo.otherFeeAmount != null &&
              data.financialInfo.otherFeeAmount! > 0);

      // Documentation Book
      _selectedDocRecordBookId = data.documentInfo.docRecordBookId;
      _docRecordBookNumberCtrl.text =
          data.documentInfo.docRecordBookNumber?.toString() ?? '';
      _docPageNumberCtrl.text =
          data.documentInfo.docPageNumber?.toString() ?? '';
      _docEntryNumberCtrl.text =
          data.documentInfo.docEntryNumber?.toString() ?? '';
      _docHijriDateCtrl.text = data.documentInfo.docHijriDate ?? '';
      _docGregorianDateCtrl.text = data.documentInfo.docGregorianDate ?? '';

      // Guardian Book
      _guardianRecordBookId = data.guardianInfo.guardianRecordBookId;
      _guardianRecordBookNumberCtrl.text =
          data.guardianInfo.guardianRecordBookNumber?.toString() ?? '';
      _guardianPageNumberCtrl.text =
          data.guardianInfo.guardianPageNumber?.toString() ?? '';
      _guardianEntryNumberCtrl.text =
          data.guardianInfo.guardianEntryNumber?.toString() ?? '';
      _guardianHijriDateCtrl.text = data.guardianInfo.guardianHijriDate ?? '';
      _guardianGregorianDateCtrl.text =
          data.guardianInfo.guardianGregorianDate ?? '';

      // Subtypes
      if (data.basicInfo.subtype1 != null) {
        _selectedSubtype1 = data.basicInfo.subtype1.toString();
      }
      if (data.basicInfo.subtype2 != null) {
        _selectedSubtype2 = data.basicInfo.subtype2.toString();
      }

      // Load specific dependencies (needs notifier)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_selectedContractTypeId != null) {
          final notifier = ref.read(addEntryProvider.notifier);

          // ① تعيين formData أولاً — حتى تُحفظ عند تحميل الحقول
          if (data.formData != null && data.formData!.isNotEmpty) {
            notifier.setFormData(data.formData!);
            // إنشاء controllers للحقول الديناميكية
            data.formData!.forEach((key, value) {
              _dynamicControllers[key] = TextEditingController(
                text: value?.toString() ?? '',
              );
            });
          }

          // ② تحميل البيانات المرتبطة بنوع العقد
          notifier.loadDocumentationRecordBooks(_selectedContractTypeId!);
          await notifier.loadSubtypes(_selectedContractTypeId!);

          // ②.١ تحميل الأنواع الفرعية الثانوية إذا كان هناك نوع فرعي أول محدد
          if (_selectedSubtype1 != null) {
            await notifier.loadSubtypes(
              _selectedContractTypeId!,
              parentCode: _selectedSubtype1,
            );
          }

          // ③ تحميل الحقول الديناميكية مع الأنواع الفرعية — formData ستُحفظ لأن loadFormFields يحافظ عليها
          await notifier.loadFormFields(
            _selectedContractTypeId!,
            subtype1: _selectedSubtype1,
            subtype2: _selectedSubtype2,
          );

          // ④ تحميل سجلات الأمين إن كان الكاتب أمين
          if (_writerType == 'guardian' && _selectedGuardianId != null) {
            notifier.loadGuardianRecordBooks(
              _selectedContractTypeId!,
              _selectedGuardianId!,
            );
          }

          // ⑤ إعادة بناء الواجهة بعد اكتمال التحميل
          if (mounted) setState(() {});
        }
      });
    } else {
      // Set default dates
      final todayHijri = HijriCalendar.now();
      final hijriFormatted =
          '${todayHijri.hYear}-${todayHijri.hMonth.toString().padLeft(2, '0')}-${todayHijri.hDay.toString().padLeft(2, '0')}';
      final gregFormatted = DateTime.now().toString().split(' ')[0];
      _documentHijriDateCtrl.text = hijriFormatted;
      _documentGregorianDateCtrl.text = gregFormatted;
      _docHijriDateCtrl.text = hijriFormatted;
      _docGregorianDateCtrl.text = gregFormatted;
      _guardianHijriDateCtrl.text = hijriFormatted;
      _guardianGregorianDateCtrl.text = gregFormatted;
    }
  }

  @override
  void dispose() {
    _documentHijriDateCtrl.removeListener(_syncGuardianDateWithDocument);
    _docHijriDateCtrl.removeListener(_syncGuardianDateWithDocumentation);
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
    _guardianHijriDateCtrl.dispose();
    _guardianGregorianDateCtrl.dispose();
    _taxAmountCtrl.dispose();
    _taxReceiptNumberCtrl.dispose();
    _zakatAmountCtrl.dispose();
    _zakatReceiptNumberCtrl.dispose();
    _exemptionReasonCtrl.dispose();
    for (final c in _dynamicControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Fee Calculation ──
  /// حساب الرسوم والغرامات تلقائياً
  /// مطابق لـ FeeCalculator.php في الباكند
  void _calculateFees() {
    if (_selectedContractTypeId == null) return;

    if (_isExempted) {
      setState(() {
        _feeAmountCtrl.text = '0';
        _penaltyAmountCtrl.text = '0';
        _supportAmountCtrl.text = '0';
        _sustainabilityAmountCtrl.text = '0';
        _totalAmountCtrl.text = '0';
      });
      return;
    }

    final contractId = _selectedContractTypeId!;
    const nonFinancialTypes = [1, 7, 8, 4]; // زواج، طلاق، رجعة، وكالة
    const financialTypes = [10, 5, 6]; // مبيع، تصرف، قسمة

    // ─── 1. حساب الرسم الأساسي ─────────────────
    double baseFee = 0;

    if (nonFinancialTypes.contains(contractId)) {
      baseFee = 400; // رسم ثابت
    } else if (financialTypes.contains(contractId)) {
      // رسم نسبي 0.20% من القيمة
      final formData = ref.read(addEntryProvider).formData;
      final dynamicPrice =
          formData['sale_price'] ?? _dynamicControllers['sale_price']?.text;
      double price = 0;
      if (dynamicPrice != null) {
        price = double.tryParse(dynamicPrice.toString()) ?? 0;
      }
      baseFee = price > 0 ? (price * 0.002).clamp(400, double.infinity) : 400;
    } else {
      baseFee = 2000; // توثيق عادي
    }

    // ─── 2. حساب أيام التأخير ──────────────────
    int delayDays = 0;
    double penalty = 0;

    // تاريخ التوثيق (الميلادي)
    final docGregorianStr = _docGregorianDateCtrl.text;
    // تاريخ المحرر (الميلادي)
    final documentGregorianStr = _documentGregorianDateCtrl.text;

    if (docGregorianStr.isNotEmpty && documentGregorianStr.isNotEmpty) {
      try {
        final docDate = DateTime.parse(docGregorianStr);
        final documentDate = DateTime.parse(documentGregorianStr);
        if (docDate.isAfter(documentDate)) {
          delayDays = docDate.difference(documentDate).inDays;
        }
      } catch (_) {}
    }

    // ─── 3. حساب الغرامة بناءً على التأخير ─────
    // مطابق لـ FeeCalculator::calculatePenalty()
    if (delayDays > 0) {
      // زواج/طلاق/رجعة: غرامة 100% بعد 10 أيام
      if ([1, 7, 8].contains(contractId)) {
        if (delayDays > 10) penalty = baseFee * 1.00;
      }
      // وكالة: غرامة 100% بعد 30 يوم
      else if (contractId == 4) {
        if (delayDays > 30) penalty = baseFee * 1.00;
      }
      // تصرف: غرامة 100% بعد 30 يوم
      else if (contractId == 5) {
        if (delayDays > 30) penalty = baseFee * 1.00;
      }
      // قسمة: غرامة 100% من 61 يوم وأكثر
      else if (contractId == 6) {
        if (delayDays >= 61) penalty = baseFee * 1.00;
      }
      // مبيع: غرامة تدريجية
      else if (contractId == 10) {
        if (delayDays >= 61 && delayDays <= 120) {
          penalty = baseFee * 0.05; // 5%
        } else if (delayDays >= 121 && delayDays <= 180) {
          penalty = baseFee * 0.07; // 7%
        } else if (delayDays >= 181) {
          penalty = baseFee * 0.10; // 10%
        }
      }
    }

    // ─── 4. الرسوم الإضافية (400 لكل واحدة) ────
    double extra = 0;
    if (_hasAuthenticationFee) extra += 400;
    if (_hasTransferFee) extra += 400;
    if (_hasOtherFee) extra += 400;
    if (_writerType == 'documentation') extra += 400;

    // ─── 5. الدعم (25% من الرسم + الغرامة) ─────
    double totalFee = baseFee + penalty;
    double support = totalFee * 0.25;

    // ─── 6. تعيين القيم ─────────────────────────
    double sustainability =
        double.tryParse(_sustainabilityAmountCtrl.text) ?? 200;

    setState(() {
      _feeAmountCtrl.text = (baseFee + extra).toStringAsFixed(0);
      _penaltyAmountCtrl.text = penalty.toStringAsFixed(0);
      _supportAmountCtrl.text = support.toStringAsFixed(0);
      _totalAmountCtrl.text = (totalFee + extra + support + sustainability)
          .toStringAsFixed(0);
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

    // مزامنة بيانات الحقول الديناميكية من controllers إلى formData قبل الإرسال
    for (final entry in _dynamicControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        ref
            .read(addEntryProvider.notifier)
            .updateFormData(entry.key, entry.value.text);
      }
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
      'exemption_reason': _isExempted ? _exemptionReasonCtrl.text : null,
      'has_authentication_fee': _hasAuthenticationFee,
      'has_transfer_fee': _hasTransferFee,
      'has_other_fee': _hasOtherFee,
      'tax_amount': double.tryParse(_taxAmountCtrl.text),
      'tax_receipt_number': _taxReceiptNumberCtrl.text,
      'zakat_amount': double.tryParse(_zakatAmountCtrl.text),
      'zakat_receipt_number': _zakatReceiptNumberCtrl.text,
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
      data['guardian_hijri_date'] = _guardianHijriDateCtrl.text;
      data['guardian_gregorian_date'] = _guardianGregorianDateCtrl.text;
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

    final success = widget.initialData != null
        ? await ref
              .read(addEntryProvider.notifier)
              .updateEntry(widget.initialData!.id, data)
        : await ref.read(addEntryProvider.notifier).submitEntry(data);

    if (success && mounted && !_isOnline) {
      // Only show offline local save message here since it doesn't come from API state
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'تم الحفظ محلياً - سيُرفع عند الاتصال',
                style: TextStyle(fontFamily: 'Tajawal'),
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

    ref.listen(addEntryProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error!,
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      if (next.successMessage != null &&
          next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    next.successMessage!,
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
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
        Navigator.pop(context); // Go back on success
      }
    });

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

                      // ══════════════════════════════════════
                      // القسم الأول: نوع المحرر وبيانات الكاتب
                      // ══════════════════════════════════════
                      FormSectionCard(
                        title: 'نوع المحرر وبيانات الكاتب',
                        icon: Icons.edit_document,
                        accentColor: AppColors.primary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PartiesSection(
                              contractTypes: state.contractTypes,
                              selectedContractTypeId: _selectedContractTypeId,
                              onContractTypeSelected: _onContractTypeSelected,
                              writerType: _writerType,
                              selectedGuardianId: _selectedGuardianId,
                              selectedWriterId: _selectedWriterId,
                              selectedOtherWriterId: _selectedOtherWriterId,
                              firstPartyController: _firstPartyCtrl,
                              secondPartyController: _secondPartyCtrl,
                              documentHijriDateController:
                                  _documentHijriDateCtrl,
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
                              onGuardianChanged: (v) {
                                setState(() => _selectedGuardianId = v);
                                // Load guardian record books when guardian selected
                                if (v != null &&
                                    _selectedContractTypeId != null) {
                                  ref
                                      .read(addEntryProvider.notifier)
                                      .loadGuardianRecordBooks(
                                        _selectedContractTypeId!,
                                        v,
                                      );
                                }
                              },
                              onWriterChanged: (v) =>
                                  setState(() => _selectedWriterId = v),
                              onOtherWriterChanged: (v) =>
                                  setState(() => _selectedOtherWriterId = v),
                              onFeesRecalculate: _calculateFees,
                            ),

                            // Guardian Record (inside Section 1 if writer is guardian)
                            if (_writerType == 'guardian') ...[
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              GuardianSection(
                                guardianRecordBookId: _guardianRecordBookId,
                                guardianRecordBooks: state.guardianRecordBooks,
                                recordBookNumberCtrl:
                                    _guardianRecordBookNumberCtrl,
                                pageNumberCtrl: _guardianPageNumberCtrl,
                                entryNumberCtrl: _guardianEntryNumberCtrl,
                                hijriDateCtrl: _guardianHijriDateCtrl,
                                gregorianDateCtrl: _guardianGregorianDateCtrl,
                                onRecordBookIdChanged: (v) =>
                                    setState(() => _guardianRecordBookId = v),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ══════════════════════════════════════
                      // القسم الثاني: بيانات القيد/العقد
                      // ══════════════════════════════════════
                      if (_selectedContractTypeId != null) ...[
                        // Auto-documentation notice
                        if (_writerType == 'guardian' &&
                            _selectedGuardianId != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'بما أن القيد مقيد في سجل الأمين مسبقاً، يرجى استكمال بيانات التوثيق والرسوم المالية أدناه لإتمام المرحلة.',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        FormSectionCard(
                          title: 'بيانات القيد والعقد',
                          icon: Icons.people_alt,
                          accentColor: AppColors.accent,
                          child: _buildContractDataSection(state),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ══════════════════════════════════════
                      // القسم الثالث: بيانات قلم التوثيق
                      // ══════════════════════════════════════
                      FormSectionCard(
                        title: 'بيانات قلم التوثيق',
                        icon: Icons.account_balance,
                        accentColor: AppColors.success,
                        child: DocumentationSection(
                          selectedContractTypeId: _selectedContractTypeId,
                          selectedDocRecordBookId: _selectedDocRecordBookId,
                          filteredRecordBooks: state.documentationRecordBooks,
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
                          taxAmountCtrl: _taxAmountCtrl,
                          taxReceiptNumberCtrl: _taxReceiptNumberCtrl,
                          zakatAmountCtrl: _zakatAmountCtrl,
                          zakatReceiptNumberCtrl: _zakatReceiptNumberCtrl,
                          exemptionReasonCtrl: _exemptionReasonCtrl,
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

  // ── القسم الثاني: بيانات القيد والعقد ──
  Widget _buildContractDataSection(AddEntryState state) {
    final labels =
        contractPartyLabels[_selectedContractTypeId] ??
        {'first': 'الطرف الأول', 'second': 'الطرف الثاني'};

    final isDivision = _selectedContractTypeId == 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Party fields
        if (isDivision) ...[
          TextFormField(
            controller: _firstPartyCtrl,
            decoration: const InputDecoration(
              labelText: 'اسم المؤرث',
              prefixIcon: Icon(Icons.person, size: 20),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _secondPartyCtrl,
            decoration: const InputDecoration(
              labelText: 'أسماء الورثة (مفصولين بفاصلة)',
              prefixIcon: Icon(Icons.people, size: 20),
            ),
            maxLines: 2,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstPartyCtrl,
                  decoration: InputDecoration(
                    labelText: labels['first'],
                    prefixIcon: const Icon(Icons.person, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _secondPartyCtrl,
                  decoration: InputDecoration(
                    labelText: labels['second'],
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),

        // Contract-specific fields (e.g. return/divorce)
        if (_selectedContractTypeId == 8) ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _divorceContractNumberCtrl,
                  decoration: const InputDecoration(
                    labelText: 'رقم عقد الطلاق',
                    prefixIcon: Icon(Icons.numbers, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _returnDateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الرجعة',
                    prefixIcon: Icon(Icons.calendar_today, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Dynamic fields
        DynamicFieldBuilder(
          fields: state.filteredFields,
          isLoading: state.isLoadingFields,
          controllers: _dynamicControllers,
          initialValues: state.formData,
          onFieldChanged: (entry) {
            ref
                .read(addEntryProvider.notifier)
                .updateFormData(entry.key, entry.value);
            if (entry.key == 'sale_price') {
              Future.delayed(Duration.zero, _calculateFees);
            }
          },
        ),
      ],
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
    final isEdit = widget.initialData != null;
    final titleText = isEdit
        ? 'تعديل القيد رقم (${widget.initialData!.id})'
        : 'إضافة قيد جديد';

    return AppBar(
      title: Text(titleText),
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
