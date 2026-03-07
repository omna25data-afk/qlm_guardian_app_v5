import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../admin/presentation/providers/add_entry_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../system/data/models/registry_entry_sections.dart';
import '../../../registry/presentation/providers/entries_provider.dart';
import '../widgets/contract_type_selector.dart';
import '../widgets/guardian_section.dart';
import '../widgets/form_section_card.dart';
// contract_static_fields_widget removed — dynamic fields used instead

/// Contract type party labels (same as PartiesSection)
const Map<int, Map<String, String>> _contractPartyLabels = {
  1: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'},
  7: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'},
  8: {'first': 'اسم الزوج المراجع', 'second': 'اسم الزوجة'},
  4: {'first': 'اسم الموكل', 'second': 'اسم الوكيل'},
  5: {'first': 'اسم المتصرف', 'second': 'اسم المتصرف إليه'},
  6: {'first': 'اسم المؤرث', 'second': 'أسماء الورثة'},
  10: {'first': 'اسم البائع', 'second': 'اسم المشتري'},
};

/// نموذج إضافة قيد الأمين الشرعي
/// يحتوي فقط على: نوع العقد، بيانات الأطراف، تاريخ المحرر، سجل الأمين، والحقول الديناميكية.
/// لا يحتوي على: بيانات قلم التوثيق، الرسوم المالية، الضريبة، الزكاة.
class GuardianEntryScreen extends ConsumerStatefulWidget {
  final RegistryEntrySections?
  entry; // null = create mode, non-null = edit mode

  const GuardianEntryScreen({super.key, this.entry});

  bool get isEditMode => entry != null;

  @override
  ConsumerState<GuardianEntryScreen> createState() =>
      _GuardianEntryScreenState();
}

class _GuardianEntryScreenState extends ConsumerState<GuardianEntryScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // ── State ──
  int? _selectedContractTypeId;
  String? _selectedSubtype1;
  String? _selectedSubtype2;
  int? _guardianRecordBookId;
  bool _isOnline = true;
  Timer? _duplicateCheckTimer;

  // ── Controllers ──
  final _firstPartyCtrl = TextEditingController();
  final _secondPartyCtrl = TextEditingController();
  final _documentHijriDateCtrl = TextEditingController();
  final _documentGregorianDateCtrl = TextEditingController();
  final _divorceContractNumberCtrl = TextEditingController();
  final _returnDateCtrl = TextEditingController();
  final _guardianRecordBookNumberCtrl = TextEditingController();
  final _guardianPageNumberCtrl = TextEditingController();
  final _guardianEntryNumberCtrl = TextEditingController();
  final _guardianHijriDateCtrl = TextEditingController();
  final _guardianGregorianDateCtrl = TextEditingController();

  // Delivery controllers
  String _deliveryStatus = 'kept';
  final _deliveryHijriDateCtrl = TextEditingController();
  final _deliveryGregorianDateCtrl = TextEditingController();
  final _recipientNameCtrl = TextEditingController();
  String?
  _deliveryProofPath; // In a full implementation, you'd allow picking an image

  final Map<String, TextEditingController> _dynamicControllers = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Check connectivity
    Connectivity().checkConnectivity().then((result) {
      if (mounted) {
        setState(() {
          _isOnline = result.any((r) => r != ConnectivityResult.none);
        });
      }
    });

    if (widget.isEditMode) {
      // إعادة تعيين الـ provider لضمان state نظيف قبل التعديل
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(addEntryProvider);
        _populateForEdit();
      });
    } else {
      // Set default dates for new entries
      final todayHijri = HijriCalendar.now();
      final hijriFormatted =
          '${todayHijri.hYear}-${todayHijri.hMonth.toString().padLeft(2, '0')}-${todayHijri.hDay.toString().padLeft(2, '0')}';
      final gregFormatted = DateTime.now().toString().split(' ')[0];
      _documentHijriDateCtrl.text = hijriFormatted;
      _documentGregorianDateCtrl.text = gregFormatted;
      _guardianHijriDateCtrl.text = hijriFormatted;
      _guardianGregorianDateCtrl.text = gregFormatted;
    }

    // Sync guardian date with document date
    _documentHijriDateCtrl.addListener(_syncGuardianDate);

    // Duplicate Check Listeners
    _guardianEntryNumberCtrl.addListener(_checkDuplicateIfNeeded);
    _documentHijriDateCtrl.addListener(_checkDuplicateIfNeeded);
    _guardianHijriDateCtrl.addListener(_checkDuplicateIfNeeded);
    _guardianPageNumberCtrl.addListener(_checkDuplicateIfNeeded);
    _guardianRecordBookNumberCtrl.addListener(_checkDuplicateIfNeeded);

    // مراقبة تحميل الحقول الديناميكية لملئها
    _listenAndPopulateDynamic();
  }

  void _listenAndPopulateDynamic() {
    ref.listenManual(addEntryProvider, (previous, next) {
      if (widget.isEditMode &&
          next.filteredFields.isNotEmpty &&
          (previous?.filteredFields.isEmpty ?? true)) {
        // ملء formData في الـ provider من contract_details بعد تحميل الحقول
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _populateFormDataForEdit();
        });
      }
    });
  }

  /// ملء formData في الـ provider من بيانات القيد عند التعديل
  void _populateFormDataForEdit() {
    final entryFormData = widget.entry?.formData;
    if (entryFormData == null || entryFormData.isEmpty) return;

    final notifier = ref.read(addEntryProvider.notifier);
    notifier.setFormData(Map<String, dynamic>.from(entryFormData));
  }

  /// Pre-populate all form fields from the existing entry
  void _populateForEdit() {
    final entry = widget.entry!;

    // Contract type
    _selectedContractTypeId = entry.basicInfo.contractTypeId;
    _selectedSubtype1 = entry.basicInfo.subtype1?.toString();
    _selectedSubtype2 = entry.basicInfo.subtype2?.toString();

    // Party names
    _firstPartyCtrl.text = entry.basicInfo.firstPartyName;
    _secondPartyCtrl.text = entry.basicInfo.secondPartyName;

    // Document dates
    _documentHijriDateCtrl.text = entry.documentInfo.documentHijriDate ?? '';
    _documentGregorianDateCtrl.text =
        entry.documentInfo.documentGregorianDate ?? '';

    // Guardian record book
    _guardianRecordBookId = entry.guardianInfo.guardianRecordBookId;
    _guardianRecordBookNumberCtrl.text =
        entry.guardianInfo.guardianRecordBookNumber?.toString() ?? '';
    _guardianPageNumberCtrl.text =
        entry.guardianInfo.guardianPageNumber?.toString() ?? '';
    _guardianEntryNumberCtrl.text =
        entry.guardianInfo.guardianEntryNumber?.toString() ?? '';
    _guardianHijriDateCtrl.text = entry.guardianInfo.guardianHijriDate ?? '';
    _guardianGregorianDateCtrl.text =
        entry.guardianInfo.guardianGregorianDate ?? '';

    // Load dynamic fields for this contract type
    if (_selectedContractTypeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(addEntryProvider.notifier);

        // ① تعيين formData أولاً (قبل loadFormFields لمنع مسحها)
        if (entry.formData != null && entry.formData!.isNotEmpty) {
          notifier.setFormData(entry.formData!);
        }

        // ② تنظيف الـ controllers القديمة من أي تعديل سابق
        for (final c in _dynamicControllers.values) {
          c.dispose();
        }
        _dynamicControllers.clear();

        // ③ تحميل الحقول والدفاتر والأنواع الفرعية
        notifier.loadFormFields(
          _selectedContractTypeId!,
          subtype1: _selectedSubtype1,
          subtype2: _selectedSubtype2,
        );
        notifier.loadGuardianRecordBooks(
          _selectedContractTypeId!,
          _guardianId ?? 0,
        );
        notifier.loadSubtypes(_selectedContractTypeId!);

        // ④ تطبيق تصفية الحقول بحسب الأنواع المحددة مسبقًا
        notifier.filterFields(
          subtype1: _selectedSubtype1,
          subtype2: _selectedSubtype2,
        );
      });
    }
  }

  void _syncGuardianDate() {
    _guardianHijriDateCtrl.text = _documentHijriDateCtrl.text;
    _guardianGregorianDateCtrl.text = _documentGregorianDateCtrl.text;
  }

  void _checkDuplicateIfNeeded() {
    if (widget.isEditMode) return; // Don't check on edit mode

    final contractTypeId = _selectedContractTypeId;
    final entryNumberText = _guardianEntryNumberCtrl.text;

    // Use guardian hijri date if available, otherwise fallback to document hijri date
    final hijriDate = _guardianHijriDateCtrl.text.isNotEmpty
        ? _guardianHijriDateCtrl.text
        : _documentHijriDateCtrl.text;

    if (contractTypeId == null ||
        entryNumberText.isEmpty ||
        hijriDate.isEmpty) {
      return;
    }

    final entryNumber = int.tryParse(entryNumberText);

    debugPrint(
      'Duplicate Check - ContractType: $contractTypeId, EntryNumText: $entryNumberText, HijriDate: $hijriDate, EntryNum: $entryNumber',
    );

    if (entryNumber == null) return;

    _duplicateCheckTimer?.cancel();
    _duplicateCheckTimer = Timer(const Duration(milliseconds: 800), () async {
      final guardianId = _guardianId;
      if (guardianId == null) return;

      if (!mounted) return;

      final notifier = ref.read(addEntryProvider.notifier);
      final result = await notifier.checkDuplicateEntry(
        contractTypeId: contractTypeId,
        writerType: 'guardian',
        entryNumber: entryNumber,
        transactionDate: hijriDate,
        guardianId: guardianId,
        recordCategory: 'guardian_recording',
      );

      debugPrint('Duplicate Check API Result: $result');

      if (!mounted) return;

      if (result['is_duplicate'] == true && result['entry'] != null) {
        _showDuplicateDialog(result['entry']);
      }
    });
  }

  void _showDuplicateDialog(Map<String, dynamic> duplicateData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            SizedBox(width: 8),
            Text(
              'تنبيه: قيد مسجل مسبقاً',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.warning,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'تم العثور على قيد مسجل مسبقاً بنفس نوع المحرر ورقم القيد. هل تريد جلب بياناته لتعديلها؟',
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _populateFromDuplicate(duplicateData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006400),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'نعم، جلب البيانات',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  void _populateFromDuplicate(Map<String, dynamic> data) {
    final entry = RegistryEntrySections.fromJson(data);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GuardianEntryScreen(entry: entry)),
    );
  }

  @override
  void dispose() {
    _duplicateCheckTimer?.cancel();
    _documentHijriDateCtrl.removeListener(_syncGuardianDate);
    _guardianRecordBookNumberCtrl.removeListener(_checkDuplicateIfNeeded);
    _guardianPageNumberCtrl.removeListener(_checkDuplicateIfNeeded);
    _guardianEntryNumberCtrl.removeListener(_checkDuplicateIfNeeded);
    _documentHijriDateCtrl.removeListener(_checkDuplicateIfNeeded);
    _guardianHijriDateCtrl.removeListener(_checkDuplicateIfNeeded);
    _fadeController.dispose();
    _firstPartyCtrl.dispose();
    _secondPartyCtrl.dispose();
    _documentHijriDateCtrl.dispose();
    _documentGregorianDateCtrl.dispose();
    _divorceContractNumberCtrl.dispose();
    _returnDateCtrl.dispose();
    _guardianRecordBookNumberCtrl.dispose();
    _guardianPageNumberCtrl.dispose();
    _guardianEntryNumberCtrl.dispose();
    _guardianHijriDateCtrl.dispose();
    _guardianGregorianDateCtrl.dispose();
    _deliveryHijriDateCtrl.dispose();
    _deliveryGregorianDateCtrl.dispose();
    _recipientNameCtrl.dispose();
    for (final c in _dynamicControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _guardianId {
    final user = ref.read(authProvider).user;
    return user?.legitimateGuardianId;
  }

  // ── Submit ──
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedContractTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار نوع العقد',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final guardianId = _guardianId;
    if (guardianId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لم يتم العثور على بيانات الأمين',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final data = <String, dynamic>{
      'contract_type_id': _selectedContractTypeId,
      'first_party_name': _firstPartyCtrl.text,
      'second_party_name': _secondPartyCtrl.text,
      'writer_type': 'guardian',
      'guardian_id': guardianId,
      'document_hijri_date': _documentHijriDateCtrl.text,
      'document_gregorian_date': _documentGregorianDateCtrl.text,
      // Guardian record book
      'guardian_record_book_id': _guardianRecordBookId,
      'guardian_record_book_number': int.tryParse(
        _guardianRecordBookNumberCtrl.text,
      ),
      'guardian_page_number': int.tryParse(_guardianPageNumberCtrl.text),
      'guardian_entry_number': int.tryParse(_guardianEntryNumberCtrl.text),
      'guardian_hijri_date': _guardianHijriDateCtrl.text,
      'guardian_gregorian_date': _guardianGregorianDateCtrl.text,
      // Delivery
      'delivery_status': _deliveryStatus,
    };

    if (_deliveryStatus == 'delivered') {
      data['delivery_hijri_date'] = _deliveryHijriDateCtrl.text;
      data['delivery_gregorian_date'] = _deliveryGregorianDateCtrl.text;
      data['recipient_name'] = _recipientNameCtrl.text;
      if (_deliveryProofPath != null) {
        data['delivery_proof_path'] = _deliveryProofPath;
      }
    }

    if (_selectedSubtype1 != null) data['subtype_1'] = _selectedSubtype1;
    if (_selectedSubtype2 != null) data['subtype_2'] = _selectedSubtype2;

    if (_selectedContractTypeId == 8) {
      data['divorce_contract_number'] = _divorceContractNumberCtrl.text;
      data['return_date'] = _returnDateCtrl.text;
    }

    // form_data يتم تجميعها تلقائياً من addEntryProvider.formData
    // لا حاجة لـ _dynamicControllers — البيانات تُدار عبر الـ provider مباشرة

    data.removeWhere((key, value) => value == null || value == '');

    final notifier = ref.read(addEntryProvider.notifier);

    try {
      final bool success;
      if (widget.isEditMode) {
        final entryId = widget.entry!.remoteId ?? widget.entry!.id;
        success = await notifier.updateEntry(entryId, data);
      } else {
        success = await notifier.submitEntry(data);
      }

      if (!mounted) return;

      if (success) {
        // Refresh entries list
        ref.invalidate(rawEntriesProvider);
        // النجاح يتم التعامل معه في ref.listen في build()
        // الذي يعرض SnackBar ويقوم بـ Navigator.pop مرة واحدة فقط
      } else {
        // عرض رسالة الخطأ من الـ provider
        final errorState = ref.read(addEntryProvider);
        if (errorState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorState.error!,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ غير متوقع: ${e.toString()}',
            style: const TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEntryProvider);

    // Listen for success/error messages from provider
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
        Navigator.pop(context);
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
                      // القسم الأول: نوع المحرر وبيانات السجل
                      // ══════════════════════════════════════
                      FormSectionCard(
                        title: 'نوع المحرر وبيانات السجل',
                        icon: Icons.edit_document,
                        accentColor: const Color(0xFF006400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Contract type selector
                            ContractTypeSelector(
                              contractTypes: state.contractTypes,
                              selectedId: _selectedContractTypeId,
                              onSelected: _onContractTypeSelected,
                            ),

                            // Subtypes
                            if (_selectedContractTypeId != null) ...[
                              const SizedBox(height: 16),
                              ..._buildSubtypes(state),
                            ],

                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),

                            // ── Record data (date) ──
                            _buildDocumentDateRow(),
                            const SizedBox(height: 24),

                            // ── بيانات القيد في سجل الأمين ──
                            const Text(
                              'بيانات القيد بالمرجع',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
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
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ══════════════════════════════════════
                      // القسم الثاني: بيانات الأطراف والمحرر (الحقول الثابتة + الديناميكية)
                      // ══════════════════════════════════════
                      if (_selectedContractTypeId != null) ...[
                        FormSectionCard(
                          title: 'بيانات الأطراف والمحرر',
                          icon: Icons.people,
                          accentColor: const Color(0xFF008000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Party fields
                              ..._buildPartyFields(),

                              // الحقول الديناميكية من FormFieldConfig
                              if (state.filteredFields.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                ..._buildDynamicFields(state),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ══════════════════════════════════════
                      // القسم الثالث: حالة التسليم
                      // ══════════════════════════════════════
                      FormSectionCard(
                        title: 'حالة التسليم',
                        icon: Icons.local_shipping,
                        accentColor: Colors.blueGrey,
                        child: _buildDeliverySection(state),
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

  // ── Contract type selected ──
  void _onContractTypeSelected(int typeId) {
    setState(() {
      _selectedContractTypeId = typeId;
      _selectedSubtype1 = null;
      _selectedSubtype2 = null;
      _guardianRecordBookId = null;
      _guardianRecordBookNumberCtrl.clear();
    });
    final notifier = ref.read(addEntryProvider.notifier);
    notifier.loadFormFields(typeId);
    notifier.loadSubtypes(typeId);

    // Auto-load guardian record books
    final guardianId = _guardianId;
    if (guardianId != null) {
      notifier.loadGuardianRecordBooks(typeId, guardianId);
    }
  }

  // ── Subtypes ──
  List<Widget> _buildSubtypes(AddEntryState state) {
    final widgets = <Widget>[];

    if (state.subtypes1.isNotEmpty) {
      widgets.add(
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes1,
          label: 'النوع الفرعي الأول',
          value: _selectedSubtype1 != null
              ? state.subtypes1.firstWhere(
                  (e) =>
                      e['code'] == _selectedSubtype1 ||
                      e['id'].toString() == _selectedSubtype1,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (i) => i['name'],
          onChanged: (v) {
            final code = v?['code']?.toString() ?? v?['id']?.toString();
            setState(() => _selectedSubtype1 = code);
            ref
                .read(addEntryProvider.notifier)
                .loadSubtypes(_selectedContractTypeId!, parentCode: code);
            ref
                .read(addEntryProvider.notifier)
                .filterFields(subtype1: code, subtype2: null);
          },
        ),
      );
      widgets.add(const SizedBox(height: 12));
    }

    if (state.subtypes2.isNotEmpty) {
      widgets.add(
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes2,
          label: 'النوع الفرعي الثانوي',
          value: _selectedSubtype2 != null
              ? state.subtypes2.firstWhere(
                  (e) =>
                      e['code'] == _selectedSubtype2 ||
                      e['id'].toString() == _selectedSubtype2,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (i) => i['name'],
          onChanged: (v) {
            final code = v?['code']?.toString() ?? v?['id']?.toString();
            setState(() => _selectedSubtype2 = code);
            ref
                .read(addEntryProvider.notifier)
                .filterFields(subtype1: _selectedSubtype1, subtype2: code);
          },
        ),
      );
      widgets.add(const SizedBox(height: 12));
    }

    return widgets;
  }

  // ── Document date row ──
  Widget _buildDocumentDateRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _documentHijriDateCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'تاريخ المحرر (هـ)',
              hintText: 'هـ',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: Icon(Icons.calendar_month, size: 20),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onTap: () => _selectHijriDate(
              context,
              _documentHijriDateCtrl,
              _documentGregorianDateCtrl,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _documentGregorianDateCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'تاريخ المحرر (م)',
              hintText: 'م',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: Icon(Icons.date_range, size: 20),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
      ],
    );
  }

  // ── Party fields ──
  List<Widget> _buildPartyFields() {
    final labels =
        _contractPartyLabels[_selectedContractTypeId] ??
        {'first': 'الطرف الأول', 'second': 'الطرف الثاني'};
    final isDivision = _selectedContractTypeId == 6;

    if (isDivision) {
      return [
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
      ];
    }

    return [
      TextFormField(
        controller: _firstPartyCtrl,
        decoration: InputDecoration(
          labelText: labels['first'],
          prefixIcon: const Icon(Icons.person, size: 20),
        ),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _secondPartyCtrl,
        decoration: InputDecoration(
          labelText: labels['second'],
          prefixIcon: const Icon(Icons.person_outline, size: 20),
        ),
      ),
    ];
  }

  // ── بناء الحقول الديناميكية من FormFieldConfig ──
  List<Widget> _buildDynamicFields(AddEntryState state) {
    final notifier = ref.read(addEntryProvider.notifier);
    return state.filteredFields.map((field) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildDynamicField(field, state.formData, notifier),
      );
    }).toList();
  }

  Widget _buildDynamicField(
    Map<String, dynamic> field,
    Map<String, dynamic> formData,
    AddEntryNotifier notifier,
  ) {
    final type = field['type'];
    final name = field['name'];
    final label = field['label'];
    final required = field['required'] == true;
    final options = field['options'] as List<dynamic>?;

    switch (type) {
      case 'textarea':
        return _buildDynamicTextField(
          label: label,
          maxLines: 3,
          required: required,
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, v),
        );
      case 'number':
        return _buildDynamicTextField(
          label: label,
          keyboardType: TextInputType.number,
          required: required,
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, num.tryParse(v)),
        );
      case 'select':
        return DropdownButtonFormField<String>(
          initialValue: formData[name]?.toString(),
          decoration: InputDecoration(
            labelText: '$label${required ? ' *' : ''}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items:
              options
                  ?.map(
                    (o) => DropdownMenuItem(
                      value: o.toString(),
                      child: Text(o.toString()),
                    ),
                  )
                  .toList() ??
              [],
          onChanged: (v) => notifier.updateFormData(name, v),
        );
      case 'date':
        return _buildDynamicTextField(
          label: label,
          required: required,
          hint: 'YYYY-MM-DD',
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, v),
        );
      default:
        return _buildDynamicTextField(
          label: label,
          required: required,
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, v),
        );
    }
  }

  Widget _buildDynamicTextField({
    required String label,
    bool required = false,
    String? initialValue,
    String? hint,
    ValueChanged<String>? onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: '$label${required ? ' *' : ''}',
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
          : null,
      onChanged: onChanged,
    );
  }

  // ── Hijri date picker ──
  Future<void> _selectHijriDate(
    BuildContext context,
    TextEditingController hijriCtrl,
    TextEditingController gregCtrl,
  ) async {
    final picked = await showHijriDatePicker(
      context: context,
      initialDate: HijriCalendar.now(),
      firstDate: HijriCalendar()
        ..hYear = 1440
        ..hMonth = 1
        ..hDay = 1,
      lastDate: HijriCalendar()
        ..hYear = 1460
        ..hMonth = 12
        ..hDay = 29,
    );
    if (picked != null) {
      hijriCtrl.text =
          '${picked.hYear}-${picked.hMonth.toString().padLeft(2, '0')}-${picked.hDay.toString().padLeft(2, '0')}';
      final greg = picked.hijriToGregorian(
        picked.hYear,
        picked.hMonth,
        picked.hDay,
      );
      gregCtrl.text =
          '${greg.year}-${greg.month.toString().padLeft(2, '0')}-${greg.day.toString().padLeft(2, '0')}';
    }
  }

  // ── Delivery section ──
  Widget _buildDeliverySection(AddEntryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Toggle
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text(
                  'الوثيقة محفوظة لدى الأمين',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: const Text(
                  'لم يتم تسليمها لصاحب الشأن بعد',
                  style: TextStyle(fontSize: 12),
                ),
                value: 'kept',
                groupValue: _deliveryStatus,
                activeColor: const Color(0xFF006400),
                onChanged: (v) {
                  setState(() => _deliveryStatus = v!);
                },
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text(
                  'تم استلام الوثيقة من قبل صاحب الشأن',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                value: 'delivered',
                groupValue: _deliveryStatus,
                activeColor: AppColors.success,
                onChanged: (v) {
                  setState(() {
                    _deliveryStatus = v!;
                    // Set default dates if empty
                    if (_deliveryHijriDateCtrl.text.isEmpty) {
                      _deliveryHijriDateCtrl.text = _documentHijriDateCtrl.text;
                      _deliveryGregorianDateCtrl.text =
                          _documentGregorianDateCtrl.text;
                    }
                    if (_recipientNameCtrl.text.isEmpty) {
                      _recipientNameCtrl.text = _secondPartyCtrl.text.isEmpty
                          ? _firstPartyCtrl.text
                          : _secondPartyCtrl.text;
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // Show extra fields if 'delivered'
        if (_deliveryStatus == 'delivered') ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _deliveryHijriDateCtrl,
                  readOnly: true,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ التسليم (هـ)',
                    prefixIcon: Icon(Icons.calendar_month, size: 20),
                  ),
                  onTap: () => _selectHijriDate(
                    context,
                    _deliveryHijriDateCtrl,
                    _deliveryGregorianDateCtrl,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _deliveryGregorianDateCtrl,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ التسليم (م)',
                    prefixIcon: Icon(Icons.date_range, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _recipientNameCtrl,
            validator: (v) =>
                v == null || v.isEmpty ? 'اسم المستلم مطلوب' : null,
            decoration: const InputDecoration(
              labelText: 'اسم المستلم',
              prefixIcon: Icon(Icons.person, size: 20),
            ),
          ),
          const SizedBox(height: 12),
          // Delivery Proof File Picker
          InkWell(
            onTap: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                setState(() {
                  _deliveryProofPath = pickedFile.path;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _deliveryProofPath != null
                      ? Colors.green
                      : Colors.grey.shade400,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Icon(
                    _deliveryProofPath != null
                        ? Icons.check_circle
                        : Icons.upload_file,
                    color: _deliveryProofPath != null
                        ? Colors.green
                        : Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _deliveryProofPath != null
                          ? 'تم إرفاق صورة محضر التسليم'
                          : 'إرفاق صورة محضر التسليم',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: _deliveryProofPath != null
                            ? Colors.green
                            : Colors.blue,
                      ),
                    ),
                  ),
                  if (_deliveryProofPath == null)
                    const Icon(Icons.add, color: Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar(AddEntryState state) {
    return AppBar(
      backgroundColor: const Color(0xFF006400),
      foregroundColor: Colors.white,
      title: Text(
        widget.isEditMode ? 'تعديل القيد' : 'إضافة قيد جديد',
        style: const TextStyle(fontFamily: 'Tajawal'),
      ),
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
        const SizedBox(width: 8),
      ],
    );
  }

  // ── Offline banner ──
  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, size: 18, color: AppColors.warning),
          SizedBox(width: 10),
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

  // ── Submit button ──
  Widget _buildSubmitButton(AddEntryState state) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: state.isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006400),
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
                  Icon(
                    widget.isEditMode
                        ? Icons.edit
                        : (_isOnline ? Icons.save : Icons.save_alt),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.isEditMode
                        ? 'حفظ التعديلات'
                        : (_isOnline ? 'حفظ القيد' : 'حفظ محلياً'),
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
