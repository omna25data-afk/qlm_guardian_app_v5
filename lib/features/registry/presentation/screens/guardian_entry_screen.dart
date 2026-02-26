import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../admin/presentation/providers/add_entry_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/contract_type_selector.dart';
import '../widgets/guardian_section.dart';
import '../widgets/form_section_card.dart';
import '../widgets/dynamic_field_builder.dart';

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
  const GuardianEntryScreen({super.key});

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

    // Set default dates
    final todayHijri = HijriCalendar.now();
    final hijriFormatted =
        '${todayHijri.hYear}-${todayHijri.hMonth.toString().padLeft(2, '0')}-${todayHijri.hDay.toString().padLeft(2, '0')}';
    final gregFormatted = DateTime.now().toString().split(' ')[0];
    _documentHijriDateCtrl.text = hijriFormatted;
    _documentGregorianDateCtrl.text = gregFormatted;
    _guardianHijriDateCtrl.text = hijriFormatted;
    _guardianGregorianDateCtrl.text = gregFormatted;

    // Sync guardian date with document date
    _documentHijriDateCtrl.addListener(_syncGuardianDate);
  }

  void _syncGuardianDate() {
    _guardianHijriDateCtrl.text = _documentHijriDateCtrl.text;
    _guardianGregorianDateCtrl.text = _documentGregorianDateCtrl.text;
  }

  @override
  void dispose() {
    _documentHijriDateCtrl.removeListener(_syncGuardianDate);
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
    };

    if (_selectedSubtype1 != null) data['subtype_1'] = _selectedSubtype1;
    if (_selectedSubtype2 != null) data['subtype_2'] = _selectedSubtype2;

    // Contract-specific fields
    if (_selectedContractTypeId == 8) {
      data['divorce_contract_number'] = _divorceContractNumberCtrl.text;
      data['return_date'] = _returnDateCtrl.text;
    }

    data.removeWhere((key, value) => value == null || value == '');

    final success = await ref.read(addEntryProvider.notifier).submitEntry(data);

    if (success && mounted && !_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
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
                      // القسم الأول: نوع العقد وبيانات الأطراف
                      // ══════════════════════════════════════
                      FormSectionCard(
                        title: 'نوع المحرر وبيانات الأطراف',
                        icon: Icons.edit_document,
                        accentColor: AppColors.primary,
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

                            // Document date
                            _buildDocumentDateRow(),

                            const SizedBox(height: 16),

                            // Party fields
                            ..._buildPartyFields(),

                            // Contract-specific fields (divorce/return)
                            ..._buildContractSpecificFields(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ══════════════════════════════════════
                      // القسم الثاني: بيانات القيد/العقد (الحقول الديناميكية)
                      // ══════════════════════════════════════
                      if (_selectedContractTypeId != null &&
                          (state.filteredFields.isNotEmpty ||
                              state.isLoadingFields)) ...[
                        FormSectionCard(
                          title: 'بيانات العقد',
                          icon: Icons.description,
                          accentColor: AppColors.accent,
                          child: DynamicFieldBuilder(
                            fields: state.filteredFields,
                            isLoading: state.isLoadingFields,
                            controllers: _dynamicControllers,
                            onFieldChanged: (entry) {
                              ref
                                  .read(addEntryProvider.notifier)
                                  .updateFormData(entry.key, entry.value);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ══════════════════════════════════════
                      // القسم الثالث: بيانات سجل الأمين
                      // ══════════════════════════════════════
                      FormSectionCard(
                        title: 'بيانات القيد في سجل الأمين',
                        icon: Icons.book,
                        accentColor: const Color(0xFF006400),
                        child: GuardianSection(
                          guardianRecordBookId: _guardianRecordBookId,
                          guardianRecordBooks: state.guardianRecordBooks,
                          recordBookNumberCtrl: _guardianRecordBookNumberCtrl,
                          pageNumberCtrl: _guardianPageNumberCtrl,
                          entryNumberCtrl: _guardianEntryNumberCtrl,
                          hijriDateCtrl: _guardianHijriDateCtrl,
                          gregorianDateCtrl: _guardianGregorianDateCtrl,
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

  // ── Contract type selected ──
  void _onContractTypeSelected(int typeId) {
    setState(() {
      _selectedContractTypeId = typeId;
      _selectedSubtype1 = null;
      _selectedSubtype2 = null;
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
    ];
  }

  // ── Contract-specific fields (divorce/return) ──
  List<Widget> _buildContractSpecificFields() {
    if (_selectedContractTypeId == 8) {
      return [
        const SizedBox(height: 12),
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
      ];
    }
    return [];
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

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar(AddEntryState state) {
    return AppBar(
      title: const Text(
        'إضافة قيد جديد',
        style: TextStyle(fontFamily: 'Tajawal'),
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
