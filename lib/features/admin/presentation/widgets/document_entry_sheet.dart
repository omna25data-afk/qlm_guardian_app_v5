import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../system/data/models/registry_entry_sections.dart';
import '../../../records/data/models/record_book.dart';
import '../../data/repositories/admin_repository.dart';

/// نموذج توثيق القيد — يعرض كـ BottomSheet
/// يطبق نفس منطق حساب الرسوم والغرامات من Filament RegistryEntryForm::calculateFees()
class DocumentEntrySheet extends ConsumerStatefulWidget {
  final RegistryEntrySections entry;
  final VoidCallback? onSuccess;

  const DocumentEntrySheet({super.key, required this.entry, this.onSuccess});

  @override
  ConsumerState<DocumentEntrySheet> createState() => _DocumentEntrySheetState();
}

class _DocumentEntrySheetState extends ConsumerState<DocumentEntrySheet> {
  final _formKey = GlobalKey<FormState>();

  // بيانات سجل التوثيق
  final _docEntryNumberCtrl = TextEditingController();
  final _docPageNumberCtrl = TextEditingController();
  final _docRecordBookNumberCtrl = TextEditingController();
  final _docBoxNumberCtrl = TextEditingController();
  final _docDocumentNumberCtrl = TextEditingController();
  final _docHijriDateCtrl = TextEditingController();

  // الرسوم والمالية
  final _feeAmountCtrl = TextEditingController(text: '0');
  final _delayDaysCtrl = TextEditingController(text: '0');
  final _penaltyAmountCtrl = TextEditingController(text: '0');
  final _supportAmountCtrl = TextEditingController(text: '0');
  final _sustainabilityAmountCtrl = TextEditingController(text: '200');
  final _receiptNumberCtrl = TextEditingController();
  final _totalAmountCtrl = TextEditingController(text: '0');

  // الرسوم الإضافية
  bool _hasAuthenticationFee = false;
  bool _hasTransferFee = false;
  bool _hasOtherFee = false;

  // الإعفاء
  bool _isExempted = false;
  String? _exemptionType;
  final _exemptionReasonCtrl = TextEditingController();

  int? _selectedDocRecordBookId;
  List<RecordBook> _recordBooks = [];
  bool _isLoading = false;
  bool _isLoadingBooks = true;

  // أنواع العقود
  static const _nonFinancialTypes = [1, 7, 8, 4]; // زواج، طلاق، رجعة، وكالة
  static const _financialTypes = [10, 5, 6]; // مبيع، تصرف، قسمة

  @override
  void initState() {
    super.initState();
    // تاريخ اليوم الهجري كافتراضي
    final todayHijri = HijriCalendar.now();
    _docHijriDateCtrl.text =
        '${todayHijri.hYear}-${todayHijri.hMonth.toString().padLeft(2, '0')}-${todayHijri.hDay.toString().padLeft(2, '0')}';

    _loadRecordBooks();

    // حساب الرسوم الأولي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateFees();
    });
  }

  Future<void> _loadRecordBooks() async {
    try {
      final repo = getIt<AdminRepository>();
      final books = await repo.getRecordBooks(
        contractTypeId: widget.entry.basicInfo.contractTypeId,
        category: 'documentation_final',
        status: 'open',
      );
      if (mounted) {
        setState(() {
          _recordBooks = books;
          _isLoadingBooks = false;
          // اختيار أول سجل تلقائياً
          if (books.isNotEmpty) {
            _selectedDocRecordBookId = books.first.id;
            _docRecordBookNumberCtrl.text =
                books.first.bookNumber?.toString() ?? '';
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingBooks = false);
    }
  }

  /// ═══════════ حساب الرسوم والغرامات تلقائياً ═══════════
  /// نفس منطق RegistryEntryForm::calculateFees() من Filament
  void _calculateFees() {
    final contractTypeId = widget.entry.basicInfo.contractTypeId ?? 0;
    if (contractTypeId == 0) return;

    final isFinancial = _financialTypes.contains(contractTypeId);

    // ─── الرسم الأساسي ─────────────────────────
    double baseFee = 0;

    if (_nonFinancialTypes.contains(contractTypeId)) {
      // رسم ثابت 400 ريال (زواج/طلاق/رجعة/وكالة)
      baseFee = 400;
    } else if (isFinancial) {
      // رسم نسبي 0.20% من قيمة المحرر
      final salePrice =
          double.tryParse(
            widget.entry.formData?['sale_price']?.toString() ?? '0',
          ) ??
          0;
      baseFee = salePrice > 0 ? salePrice * 0.002 : 400;
    } else {
      // توثيق محرر عادي
      baseFee = 2000;
    }

    // ─── حساب أيام التأخير ─────────────────────
    int delayDays = 0;
    double penalty = 0;

    // تاريخ المحرر (المرجع)
    final documentDateStr =
        widget.entry.documentInfo.documentGregorianDate ??
        widget.entry.documentInfo.docGregorianDate;

    if (documentDateStr != null && documentDateStr.isNotEmpty) {
      try {
        final docDate = DateTime.now(); // تاريخ التوثيق = اليوم
        final referenceDate = DateTime.parse(documentDateStr);
        if (docDate.isAfter(referenceDate)) {
          delayDays = docDate.difference(referenceDate).inDays;
        }
      } catch (_) {}
    }

    // ─── حساب الغرامة بناءً على التأخير ─────────
    // مطابق لـ FeeCalculator.php
    if (delayDays > 0) {
      // زواج/طلاق/رجعة: غرامة 100% بعد 10 أيام
      if ([1, 7, 8].contains(contractTypeId)) {
        if (delayDays > 10) {
          penalty = baseFee * 1.00;
        }
      }
      // وكالة: غرامة 100% بعد 30 يوم
      else if (contractTypeId == 4) {
        if (delayDays > 30) {
          penalty = baseFee * 1.00;
        }
      }
      // تصرف: غرامة 100% بعد 30 يوم
      else if (contractTypeId == 5) {
        if (delayDays > 30) {
          penalty = baseFee * 1.00;
        }
      }
      // قسمة: غرامة 100% من 61 يوم وأكثر
      else if (contractTypeId == 6) {
        if (delayDays >= 61) {
          penalty = baseFee * 1.00;
        }
      }
      // مبيع: غرامة تدريجية
      else if (contractTypeId == 10) {
        if (delayDays >= 61 && delayDays <= 120) {
          penalty = baseFee * 0.05; // 5%
        } else if (delayDays >= 121 && delayDays <= 180) {
          penalty = baseFee * 0.07; // 7%
        } else if (delayDays >= 181) {
          penalty = baseFee * 0.10; // 10%
        }
      }
    }

    // ─── الرسوم الإضافية (400 ريال لكل واحدة) ───
    double additionalFees = 0;
    if (_hasAuthenticationFee) additionalFees += 400;
    if (_hasTransferFee) additionalFees += 400;
    if (_hasOtherFee) additionalFees += 400;

    // إذا كان الكاتب "قلم التوثيق" يُضاف 400 ريال
    if (widget.entry.writerInfo.writerType == 'documentation') {
      additionalFees += 400;
    }

    // ─── الدعم (25% من الرسم + الغرامة) ──────────
    final totalFee = baseFee + penalty;
    final support = totalFee * 0.25;

    // ─── تعيين القيم ─────────────────────────────
    final sustainability =
        double.tryParse(_sustainabilityAmountCtrl.text) ?? 200;
    final totalAmount = totalFee + additionalFees + support + sustainability;

    setState(() {
      _delayDaysCtrl.text = delayDays.toString();
      _feeAmountCtrl.text = (baseFee + additionalFees).toStringAsFixed(0);
      _penaltyAmountCtrl.text = penalty.toStringAsFixed(0);
      _supportAmountCtrl.text = support.toStringAsFixed(0);
      _totalAmountCtrl.text = totalAmount.toStringAsFixed(0);
    });
  }

  double get _totalAmount {
    final fee = double.tryParse(_feeAmountCtrl.text) ?? 0;
    final penalty = double.tryParse(_penaltyAmountCtrl.text) ?? 0;
    final support = double.tryParse(_supportAmountCtrl.text) ?? 0;
    final sustainability = double.tryParse(_sustainabilityAmountCtrl.text) ?? 0;
    return fee + penalty + support + sustainability;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = getIt<AdminRepository>();
      final data = <String, dynamic>{
        'doc_entry_number': int.parse(_docEntryNumberCtrl.text),
        'doc_page_number': int.tryParse(_docPageNumberCtrl.text),
        'doc_record_book_number': int.tryParse(_docRecordBookNumberCtrl.text),
        'doc_box_number': int.tryParse(_docBoxNumberCtrl.text),
        'doc_document_number': int.tryParse(_docDocumentNumberCtrl.text),
        'doc_date_hijri': _docHijriDateCtrl.text,
        'doc_hijri_date': _docHijriDateCtrl.text,
        'doc_record_book_id': _selectedDocRecordBookId,
        'fee_amount': double.tryParse(_feeAmountCtrl.text) ?? 0,
        'delay_days': int.tryParse(_delayDaysCtrl.text) ?? 0,
        'penalty_amount': double.tryParse(_penaltyAmountCtrl.text) ?? 0,
        'support_amount': double.tryParse(_supportAmountCtrl.text) ?? 0,
        'sustainability_amount':
            double.tryParse(_sustainabilityAmountCtrl.text) ?? 0,
        'total_amount': _totalAmount,
        'receipt_number': _receiptNumberCtrl.text,
        'has_authentication_fee': _hasAuthenticationFee,
        'has_transfer_fee': _hasTransferFee,
        'has_other_fee': _hasOtherFee,
        'is_exempted': _isExempted,
        'exemption_type': _exemptionType,
        'exemption_reason': _exemptionReasonCtrl.text,
      };

      // إزالة القيم الفارغة
      data.removeWhere(
        (key, value) =>
            value == null ||
            (value is String && value.isEmpty) ||
            value == false,
      );

      await repo.documentEntry(widget.entry.id, data);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم توثيق القيد بنجاح ✅',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _docEntryNumberCtrl.dispose();
    _docPageNumberCtrl.dispose();
    _docRecordBookNumberCtrl.dispose();
    _docBoxNumberCtrl.dispose();
    _docDocumentNumberCtrl.dispose();
    _docHijriDateCtrl.dispose();
    _feeAmountCtrl.dispose();
    _delayDaysCtrl.dispose();
    _penaltyAmountCtrl.dispose();
    _supportAmountCtrl.dispose();
    _sustainabilityAmountCtrl.dispose();
    _receiptNumberCtrl.dispose();
    _totalAmountCtrl.dispose();
    _exemptionReasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contractTypeId = widget.entry.basicInfo.contractTypeId ?? 0;
    final isFinancial = _financialTypes.contains(contractTypeId);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            _buildHeader(),
            const Divider(height: 1),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── بيانات سجل التوثيق ────────────────
                    _buildSectionTitle(
                      'بيانات سجل التوثيق',
                      Icons.account_balance,
                    ),
                    const SizedBox(height: 12),
                    _buildDocumentationFields(),

                    const SizedBox(height: 24),

                    // ─── الإعفاء ───────────────────────────
                    _buildSectionTitle('حالة الإعفاء', Icons.check_circle),
                    const SizedBox(height: 8),
                    _buildExemptionFields(),

                    const SizedBox(height: 24),

                    // ─── الرسوم الإضافية ────────────────────
                    _buildSectionTitle('رسوم إضافية', Icons.add_circle),
                    const SizedBox(height: 8),
                    _buildAdditionalFeesFields(),

                    const SizedBox(height: 24),

                    // ─── الرسوم والمالية ────────────────────
                    _buildSectionTitle(
                      'الرسوم والمالية',
                      Icons.payments_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialFields(isFinancial),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_outlined,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'توثيق القيد',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${widget.entry.basicInfo.contractType?.name ?? ""} — ${widget.entry.basicInfo.firstPartyName} / ${widget.entry.basicInfo.secondPartyName}',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── بيانات سجل التوثيق ──────────────────────────────────
  Widget _buildDocumentationFields() {
    return Column(
      children: [
        // سجل التوثيق
        _isLoadingBooks
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : DropdownButtonFormField<int>(
                value: _selectedDocRecordBookId,
                decoration: _inputDecoration('سجل التوثيق'),
                items: _recordBooks
                    .map(
                      (b) => DropdownMenuItem(
                        value: b.id,
                        child: Text(
                          '${b.name} (${b.bookNumber})',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedDocRecordBookId = v;
                    final book = _recordBooks
                        .where((b) => b.id == v)
                        .firstOrNull;
                    _docRecordBookNumberCtrl.text =
                        book?.bookNumber?.toString() ?? '';
                  });
                },
              ),
        const SizedBox(height: 12),

        // تاريخ التوثيق
        TextFormField(
          controller: _docHijriDateCtrl,
          decoration: _inputDecoration('تاريخ التوثيق (هجري)'),
          onChanged: (_) => _calculateFees(),
        ),
        const SizedBox(height: 12),

        // رقم القيد + رقم الصفحة
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _docEntryNumberCtrl,
                decoration: _inputDecoration('رقم القيد *'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'مطلوب' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _docPageNumberCtrl,
                decoration: _inputDecoration('رقم الصفحة'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // رقم السجل + رقم البوكس
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _docRecordBookNumberCtrl,
                decoration: _inputDecoration('رقم السجل'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _docBoxNumberCtrl,
                decoration: _inputDecoration('رقم البوكس'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // رقم الوثيقة داخل البوكس
        TextFormField(
          controller: _docDocumentNumberCtrl,
          decoration: _inputDecoration('رقم الوثيقة داخل البوكس'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ─── الإعفاء ──────────────────────────────────────────────
  Widget _buildExemptionFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildToggleOption(
                label: 'غير معفي',
                icon: Icons.currency_exchange,
                isSelected: !_isExempted,
                color: AppColors.primary,
                onTap: () {
                  setState(() {
                    _isExempted = false;
                    _exemptionType = null;
                    _exemptionReasonCtrl.clear();
                  });
                  _calculateFees();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleOption(
                label: 'معفي',
                icon: Icons.check_circle,
                isSelected: _isExempted,
                color: AppColors.success,
                onTap: () {
                  setState(() => _isExempted = true);
                  _calculateFees();
                },
              ),
            ),
          ],
        ),
        if (_isExempted) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _exemptionType,
            decoration: _inputDecoration('نوع الإعفاء'),
            items: const [
              DropdownMenuItem(value: 'full', child: Text('إعفاء كامل')),
              DropdownMenuItem(value: 'partial', child: Text('إعفاء جزئي')),
              DropdownMenuItem(
                value: 'penalty_only',
                child: Text('إعفاء من الغرامة فقط'),
              ),
            ],
            onChanged: (v) {
              setState(() => _exemptionType = v);
              _calculateFees();
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _exemptionReasonCtrl,
            decoration: _inputDecoration('سبب الإعفاء'),
          ),
        ],
      ],
    );
  }

  // ─── الرسوم الإضافية ────────────────────────────────────
  Widget _buildAdditionalFeesFields() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildCheckChip(
          label: 'رسوم مصادقة (400 ر.ي)',
          value: _hasAuthenticationFee,
          onChanged: (v) {
            setState(() => _hasAuthenticationFee = v!);
            _calculateFees();
          },
        ),
        _buildCheckChip(
          label: 'رسوم انتقال (400 ر.ي)',
          value: _hasTransferFee,
          onChanged: (v) {
            setState(() => _hasTransferFee = v!);
            _calculateFees();
          },
        ),
        _buildCheckChip(
          label: 'أخرى (400 ر.ي)',
          value: _hasOtherFee,
          onChanged: (v) {
            setState(() => _hasOtherFee = v!);
            _calculateFees();
          },
        ),
      ],
    );
  }

  // ─── الرسوم والمالية ────────────────────────────────────
  Widget _buildFinancialFields(bool isFinancial) {
    return Column(
      children: [
        // الرسم + أيام التأخير
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _feeAmountCtrl,
                decoration: _inputDecoration('رسوم (ر.ي)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _recalcTotal(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _delayDaysCtrl,
                decoration: _inputDecoration('أيام التأخير'),
                keyboardType: TextInputType.number,
                readOnly: true,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // الغرامة + الدعم
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _penaltyAmountCtrl,
                decoration: _inputDecoration('غرامة تأخير (ر.ي)').copyWith(
                  fillColor: (double.tryParse(_penaltyAmountCtrl.text) ?? 0) > 0
                      ? Colors.red[50]
                      : Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _recalcTotal(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _supportAmountCtrl,
                decoration: _inputDecoration('دعم (ر.ي)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _recalcTotal(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // الاستدامة + رقم السند
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _sustainabilityAmountCtrl,
                decoration: _inputDecoration('استدامة (ر.ي)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _recalcTotal(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _receiptNumberCtrl,
                decoration: _inputDecoration('رقم السند'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        // الإجمالي
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.success.withValues(alpha: 0.05),
                AppColors.success.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, color: AppColors.success, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'الإجمالي',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                '${_totalAmount.toStringAsFixed(0)} ر.ي',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),

        // ملخص أيام التأخير والغرامة
        if ((int.tryParse(_delayDaysCtrl.text) ?? 0) > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تأخير ${_delayDaysCtrl.text} يوم — غرامة: ${_penaltyAmountCtrl.text} ر.ي',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─── Submit Button ──────────────────────────────────────
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _submit,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.verified, size: 20),
          label: Text(
            _isLoading ? 'جارٍ التوثيق...' : 'توثيق القيد',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  // ─── Helper: إعادة حساب الإجمالي يدوياً ────────────────
  void _recalcTotal() {
    setState(() {
      _totalAmountCtrl.text = _totalAmount.toStringAsFixed(0);
    });
  }

  // ─── Helper: عنوان القسم ────────────────────────────────
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // ─── Helper: Toggle Option ──────────────────────────────
  Widget _buildToggleOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helper: Check Chip ─────────────────────────────────
  Widget _buildCheckChip({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: value
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: value ? AppColors.primary : Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: value ? AppColors.primary : Colors.grey[600],
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helper: Input Decoration ───────────────────────────
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }
}
