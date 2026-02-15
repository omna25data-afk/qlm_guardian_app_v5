// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../records/data/models/record_book.dart';
import '../providers/add_registry_entry_provider.dart';

/// Guardian Add Entry Screen — V4-style comprehensive form
/// 3 section cards: Document Data → Dynamic Fields → Delivery Status
class AddEntryScreen extends ConsumerStatefulWidget {
  const AddEntryScreen({super.key});

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSequentialMode = false;

  // ─── Section 1 Controllers ───
  final _bookNumberController = TextEditingController();
  final _pageNumberController = TextEditingController();
  final _entryNumberController = TextEditingController();

  // Dates
  DateTime _documentDateGregorian = DateTime.now();
  String _documentDateHijriText = '';

  // Dynamic form field controllers (keyed by field name)
  final Map<String, TextEditingController> _textControllers = {};

  // ─── Section 3: Delivery ───
  String _deliveryStatus = 'preserved';
  DateTime? _deliveryDate;

  @override
  void dispose() {
    _bookNumberController.dispose();
    _pageNumberController.dispose();
    _entryNumberController.dispose();
    for (var c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}م';

  IconData _getContractIcon(String name) {
    if (name.contains('زواج') || name.contains('نكاح')) return Icons.favorite;
    if (name.contains('طلاق') || name.contains('خلع') || name.contains('فسخ')) {
      return Icons.heart_broken;
    }
    if (name.contains('رجعة')) return Icons.replay;
    if (name.contains('مبيع') || name.contains('بيع')) return Icons.store;
    if (name.contains('وكالة')) return Icons.handshake;
    if (name.contains('تصرفات') || name.contains('تنازل')) return Icons.gavel;
    if (name.contains('تركة') || name.contains('قسمة')) return Icons.pie_chart;
    return Icons.description;
  }

  void _updateBookControllers(RecordBook book) {
    _bookNumberController.text = book.number.toString();
    _entryNumberController.text = (book.totalEntries + 1).toString();
  }

  void _clearBookControllers() {
    _bookNumberController.clear();
    _pageNumberController.clear();
    _entryNumberController.clear();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(addRegistryEntryProvider);
    final notifier = ref.read(addRegistryEntryProvider.notifier);

    if (state.selectedType == null) {
      _showSnackBar('يرجى اختيار نوع العقد', isError: true);
      return;
    }

    // Collect text field values
    final textValues = <String, String>{};
    for (var entry in _textControllers.entries) {
      textValues[entry.key] = entry.value.text;
    }

    final success = await notifier.submitEntry(
      manualBookNumber: _bookNumberController.text,
      manualPageNumber: _pageNumberController.text,
      manualEntryNumber: _entryNumberController.text,
      documentDateGregorian: _documentDateGregorian,
      documentDateHijri: _documentDateHijriText.isNotEmpty
          ? _documentDateHijriText
          : null,
      textFieldValues: textValues,
    );

    if (success && mounted) {
      _showSnackBar('تم إضافة القيد بنجاح', isError: false);

      if (_isSequentialMode) {
        // Increment entry number & clear form data
        final currentEntry = int.tryParse(_entryNumberController.text) ?? 0;
        for (var c in _textControllers.values) {
          c.clear();
        }
        _entryNumberController.text = (currentEntry + 1).toString();
        notifier.resetForNewEntry(nextEntryNumber: currentEntry + 1);
        _showSnackBar(
          'جاهز للقيد التالي رقم ${_entryNumberController.text}',
          isError: false,
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: isError ? AppColors.error : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addRegistryEntryProvider);
    final notifier = ref.read(addRegistryEntryProvider.notifier);

    // Show error snackbar
    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar(state.error!, isError: true);
        notifier.clearError();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة قيد جديد',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
      ),
      body: state.isLoadingTypes
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ══════════ القسم الأول: بيانات الوثيقة ══════════
                    _buildSectionCard(
                      title: 'القسم الأول: بيانات الوثيقة',
                      icon: Icons.description,
                      children: [
                        // Contract Type Dropdown
                        DropdownButtonFormField<int>(
                          value: state.selectedType?.id,
                          decoration: InputDecoration(
                            labelText: 'نوع العقد *',
                            labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.category),
                          ),
                          items: state.contractTypes.map((ct) {
                            return DropdownMenuItem<int>(
                              value: ct.id,
                              child: Row(
                                children: [
                                  Icon(
                                    _getContractIcon(ct.name),
                                    color: AppColors.primary.withValues(
                                      alpha: 0.8,
                                    ),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      ct.name,
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (id) {
                            if (id == null) return;
                            final type = state.contractTypes.firstWhere(
                              (t) => t.id == id,
                            );
                            notifier.selectContractType(type);
                            _clearBookControllers();
                          },
                          validator: (v) =>
                              v == null ? 'يرجى اختيار نوع العقد' : null,
                          isExpanded: true,
                        ),

                        // Subtypes Level 1
                        if (state.isLoadingSubtypes1)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        if (state.subtypes1.isNotEmpty &&
                            !state.isLoadingSubtypes1) ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            key: ValueKey(state.selectedSubtype1 ?? 'sub1'),
                            value: state.selectedSubtype1,
                            items: state.subtypes1
                                .map<DropdownMenuItem<String>>((s) {
                                  return DropdownMenuItem<String>(
                                    value: s['code'].toString(),
                                    child: Text(
                                      s['name'] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (v) => notifier.selectSubtype1(v),
                            decoration: InputDecoration(
                              labelText: 'النوع الفرعي *',
                              labelStyle: const TextStyle(
                                fontFamily: 'Tajawal',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(
                                Icons.subdirectory_arrow_left,
                              ),
                            ),
                            validator: (v) =>
                                v == null ? 'يرجى اختيار النوع الفرعي' : null,
                            isExpanded: true,
                          ),
                        ],

                        // Subtypes Level 2
                        if (state.isLoadingSubtypes2)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        if (state.subtypes2.isNotEmpty &&
                            !state.isLoadingSubtypes2) ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            key: ValueKey(state.selectedSubtype2 ?? 'sub2'),
                            value: state.selectedSubtype2,
                            items: state.subtypes2
                                .map<DropdownMenuItem<String>>((s) {
                                  return DropdownMenuItem<String>(
                                    value: s['code'].toString(),
                                    child: Text(
                                      s['name'] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (v) => notifier.selectSubtype2(v),
                            decoration: InputDecoration(
                              labelText: 'النوع الفرعي الثانوي *',
                              labelStyle: const TextStyle(
                                fontFamily: 'Tajawal',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(
                                Icons.subdirectory_arrow_right,
                              ),
                            ),
                            validator: (v) => v == null
                                ? 'يرجى اختيار النوع الفرعي الثانوي'
                                : null,
                            isExpanded: true,
                          ),
                        ],

                        const SizedBox(height: 16),

                        // ─── Dates: Hijri + Gregorian ───
                        Row(
                          children: [
                            // Hijri Date (text field — no hijri package)
                            Expanded(
                              child: TextFormField(
                                initialValue: _documentDateHijriText,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'تاريخ المحرر (هجري)',
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Tajawal',
                                  ),
                                  hintText: '01/01/1446هـ',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                  ),
                                ),
                                onChanged: (v) => _documentDateHijriText = v,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Gregorian Date (date picker)
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _documentDateGregorian,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(
                                      () => _documentDateGregorian = picked,
                                    );
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'تاريخ المحرر (ميلادي)',
                                    labelStyle: const TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDate(_documentDateGregorian),
                                        style: const TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ─── Record Book Selector ───
                        _buildRecordBookSelector(state, notifier),

                        // Show record book info if selected
                        if (state.selectedRecordBook != null) ...[
                          const SizedBox(height: 16),
                          _buildRecordBookInfo(),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ══════════ القسم الثاني: بيانات المحرر (ديناميكي) ══════════
                    if (state.selectedType != null)
                      _buildSectionCard(
                        title: 'القسم الثاني: بيانات المحرر',
                        icon: Icons.edit_document,
                        children: _buildDynamicFormFields(state),
                      ),

                    const SizedBox(height: 16),

                    // ══════════ القسم الثالث: بيانات التوثيق ══════════
                    _buildSectionCard(
                      title: 'القسم الثالث: بيانات التوثيق',
                      icon: Icons.verified,
                      children: [
                        _buildDeliveryStatusSelector(),
                        if (_deliveryStatus == 'delivered') ...[
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _deliveryDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _deliveryDate = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'تاريخ التسليم',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Tajawal',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                _deliveryDate != null
                                    ? '${_deliveryDate!.year}/${_deliveryDate!.month}/${_deliveryDate!.day}'
                                    : 'اختر التاريخ',
                                style: const TextStyle(fontFamily: 'Tajawal'),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ─── Sequential Mode Toggle ───
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: CheckboxListTile(
                        value: _isSequentialMode,
                        onChanged: (v) =>
                            setState(() => _isSequentialMode = v ?? false),
                        title: const Text(
                          'تفعيل الإدخال المتسلسل (ترقيم تلقائي)',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'سيتم حفظ البيانات والاحتفاظ بالتاريخ وزيادة رقم القيد تلقائياً.',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                        ),
                        activeColor: AppColors.primary,
                        secondary: Icon(
                          Icons.format_list_numbered_rtl,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── Submit Button ───
                    ElevatedButton(
                      onPressed: state.isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'حفظ القيد',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  // ═══════════════════════ Helper Widgets ═══════════════════════

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRecordBookSelector(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    if (state.isLoadingRecordBooks) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.selectedType == null) return const SizedBox.shrink();

    if (state.filteredRecordBooks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'لا توجد سجلات متاحة لهذا النوع.',
          style: TextStyle(color: Colors.red, fontFamily: 'Tajawal'),
        ),
      );
    }

    return DropdownButtonFormField<RecordBook>(
      value: state.selectedRecordBook,
      decoration: InputDecoration(
        labelText: 'السجل المطلوب *',
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.book),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      items: state.filteredRecordBooks.map((book) {
        return DropdownMenuItem<RecordBook>(
          value: book,
          child: Text(
            '${book.contractType} - ${book.title.isNotEmpty ? book.title : 'سجل رقم ${book.number}'}',
            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (val) {
        notifier.selectRecordBook(val);
        if (val != null) _updateBookControllers(val);
      },
      validator: (v) => v == null ? 'يرجى اختيار السجل' : null,
      isExpanded: true,
    );
  }

  Widget _buildRecordBookInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'بيانات القيد في السجل',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEditableRecordField(
                  'رقم القيد',
                  _entryNumberController,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEditableRecordField(
                  'رقم الصفحة',
                  _pageNumberController,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEditableRecordField(
                  'رقم السجل',
                  _bookNumberController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRecordField(
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Dynamic Form Fields Builder ───

  List<Widget> _buildDynamicFormFields(AddRegistryEntryState state) {
    if (state.isLoadingFields) {
      return [const Center(child: CircularProgressIndicator())];
    }

    if (state.filteredFields.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'لا توجد حقول مخصصة لهذا النوع من العقود',
            style: TextStyle(color: Colors.grey[600], fontFamily: 'Tajawal'),
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }

    final List<Widget> fields = [];

    for (var field in state.filteredFields) {
      final fieldName = field['name'] as String? ?? '';
      final fieldLabel = field['label'] as String? ?? '';
      final fieldType = field['type'] as String? ?? 'text';
      final isRequired = field['required'] == true;
      final placeholder = field['placeholder'] as String?;
      final helperText = field['helper_text'] as String?;
      final options = field['options'] as List<dynamic>?;

      // Ensure controller exists
      if ((fieldType == 'text' ||
              fieldType == 'textarea' ||
              fieldType == 'number') &&
          !_textControllers.containsKey(fieldName)) {
        _textControllers[fieldName] = TextEditingController();
      }

      Widget fieldWidget;

      switch (fieldType) {
        case 'text':
          fieldWidget = TextFormField(
            controller: _textControllers[fieldName],
            style: const TextStyle(fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              labelText: '$fieldLabel${isRequired ? " *" : ""}',
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              hintText: placeholder,
              helperText: helperText,
              helperStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: isRequired
                ? (v) => v?.isEmpty == true ? 'هذا الحقل مطلوب' : null
                : null,
          );

        case 'textarea':
          fieldWidget = TextFormField(
            controller: _textControllers[fieldName],
            maxLines: 3,
            style: const TextStyle(fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              labelText: '$fieldLabel${isRequired ? " *" : ""}',
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              hintText: placeholder,
              helperText: helperText,
              helperStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: isRequired
                ? (v) => v?.isEmpty == true ? 'هذا الحقل مطلوب' : null
                : null,
          );

        case 'number':
          fieldWidget = TextFormField(
            controller: _textControllers[fieldName],
            keyboardType: TextInputType.number,
            style: const TextStyle(fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              labelText: '$fieldLabel${isRequired ? " *" : ""}',
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              hintText: placeholder,
              helperText: helperText,
              helperStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: isRequired
                ? (v) => v?.isEmpty == true ? 'هذا الحقل مطلوب' : null
                : null,
          );

        case 'select':
          fieldWidget = DropdownButtonFormField<String>(
            value: state.formData[fieldName] as String?,
            decoration: InputDecoration(
              labelText: '$fieldLabel${isRequired ? " *" : ""}',
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              hintText: placeholder,
              helperText: helperText,
              helperStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: options?.map((opt) {
              return DropdownMenuItem<String>(
                value: opt.toString(),
                child: Text(
                  opt.toString(),
                  style: const TextStyle(fontFamily: 'Tajawal'),
                ),
              );
            }).toList(),
            onChanged: (v) => ref
                .read(addRegistryEntryProvider.notifier)
                .updateFormData(fieldName, v),
            validator: isRequired
                ? (v) => v == null ? 'هذا الحقل مطلوب' : null
                : null,
            isExpanded: true,
          );

        case 'date':
          final dateValue = state.formData[fieldName] as DateTime?;
          fieldWidget = InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: dateValue ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                ref
                    .read(addRegistryEntryProvider.notifier)
                    .updateFormData(fieldName, picked);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: '$fieldLabel${isRequired ? " *" : ""}',
                labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                helperText: helperText,
                helperStyle: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                dateValue != null
                    ? '${dateValue.year}/${dateValue.month}/${dateValue.day}'
                    : (placeholder ?? 'اختر التاريخ'),
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          );

        case 'hidden':
          fieldWidget = const SizedBox.shrink();

        case 'repeater':
          fieldWidget = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.list, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$fieldLabel (قائمة متعددة)',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          );

        default:
          fieldWidget = TextFormField(
            controller: _textControllers[fieldName],
            style: const TextStyle(fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              labelText: fieldLabel,
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              hintText: placeholder,
              helperText: helperText,
              helperStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
      }

      fields.add(fieldWidget);
      fields.add(const SizedBox(height: 16));
    }

    return fields;
  }

  // ─── Delivery Status ───

  Widget _buildDeliveryStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'حالة الوثيقة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatusOption(
                label: 'محفوظة لدينا للتوثيق',
                value: 'preserved',
                icon: Icons.lock,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusOption(
                label: 'مسلمة لصاحب الشأن',
                value: 'delivered',
                icon: Icons.send,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _deliveryStatus == value;
    return InkWell(
      onTap: () => setState(() => _deliveryStatus = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.check_circle : icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Tajawal',
                color: isSelected ? AppColors.primary : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
