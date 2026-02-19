// ignore_for_file: deprecated_member_use
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../records/data/models/record_book.dart';
import '../providers/add_registry_entry_provider.dart';

class AddRegistryEntryScreen extends ConsumerWidget {
  const AddRegistryEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addRegistryEntryProvider);
    final notifier = ref.read(addRegistryEntryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إضافة قيد جديد',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
      ),
      body: state.isLoading && state.currentStep == 0
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStepper(state.currentStep),
                if (state.error != null && state.currentStep != 0)
                  _buildErrorBanner(state.error!, notifier),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildStepContent(context, ref, state, notifier),
                  ),
                ),
                _buildBottomBar(context, state, notifier),
              ],
            ),
    );
  }

  Widget _buildErrorBanner(String error, AddRegistryEntryNotifier notifier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.errorLight,
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.error,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    final steps = ['نوع العقد', 'البيانات', 'المرفقات', 'دفتر السجل', 'مراجعة'];
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Expanded(
              child: Divider(
                color: index ~/ 2 < currentStep
                    ? AppColors.primary
                    : Colors.grey.shade300,
                thickness: 2,
              ),
            );
          }
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep;
          return Column(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: isActive
                    ? AppColors.primary
                    : Colors.grey.shade300,
                child: Text(
                  '${stepIndex + 1}',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  fontSize: 9,
                  color: isActive ? AppColors.textPrimary : AppColors.textHint,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WidgetRef ref,
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    switch (state.currentStep) {
      case 0:
        return _buildTypeSelectionStep(state, notifier);
      case 1:
        return state.isFormLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildFormStep(state, notifier);
      case 2:
        return _buildAttachmentStep(state, notifier);
      case 3:
        return _buildRecordBookStep(context, ref, state, notifier);
      case 4:
        return _buildReviewStep(context, state, notifier);
      default:
        return const SizedBox();
    }
  }

  // ─── Step 0: Type Selection ───
  Widget _buildTypeSelectionStep(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    if (state.contractTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل أنواع العقود...',
              style: TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: state.contractTypes.length,
      itemBuilder: (context, index) {
        final type = state.contractTypes[index];
        final isSelected = state.selectedType?.id == type.id;
        return InkWell(
          onTap: () => notifier.selectContractType(type),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getTypeIcon(type.name),
                  size: 32,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    type.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getTypeIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('زواج') || lower.contains('نكاح')) return Icons.favorite;
    if (lower.contains('طلاق')) return Icons.heart_broken;
    if (lower.contains('رجعة')) return Icons.replay;
    if (lower.contains('خلع')) return Icons.gavel;
    if (lower.contains('إثبات')) return Icons.verified;
    if (lower.contains('وكالة')) return Icons.assignment_ind;
    if (lower.contains('وصية')) return Icons.description;
    return Icons.description_outlined;
  }

  // ─── Step 1: Form ───
  Widget _buildFormStep(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    return ListView(
      children: [
        _buildSectionTitle('بيانات أساسية'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'الموضوع *',
                initialValue:
                    state.formData['subject'] ?? state.selectedType?.name,
                onChanged: (v) => notifier.updateFormData('subject', v),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                label: 'السنة الهجرية',
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    notifier.updateFormData('hijri_year', int.tryParse(v)),
                initialValue: state.formData['hijri_year']?.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'رقم السجل (اختياري)',
          onChanged: (v) => notifier.updateFormData('register_number', v),
          initialValue: state.formData['register_number'],
        ),

        const SizedBox(height: 24),
        _buildSectionTitle('الأطراف'),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'اسم الطرف الأول *',
          initialValue: state.formData['first_party_name'],
          onChanged: (v) => notifier.updateFormData('first_party_name', v),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'اسم الطرف الثاني',
          initialValue: state.formData['second_party_name'],
          onChanged: (v) => notifier.updateFormData('second_party_name', v),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle('المحتوى'),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'محتوى / ملاحظات (اختياري)',
          maxLines: 3,
          initialValue: state.formData['content'],
          onChanged: (v) => notifier.updateFormData('content', v),
        ),

        if (state.filteredFields.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle('بيانات العقد (${state.selectedType?.name})'),
          const SizedBox(height: 12),
          ...state.filteredFields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDynamicField(field, state.formData, notifier),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildDynamicField(
    Map<String, dynamic> field,
    Map<String, dynamic> formData,
    AddRegistryEntryNotifier notifier,
  ) {
    final type = field['type'];
    final name = field['name'];
    final label = field['label'];
    final required = field['required'] == true;
    final options = field['options'] as List<dynamic>?;

    switch (type) {
      case 'textarea':
        return _buildTextField(
          label: label,
          maxLines: 3,
          required: required,
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, v),
        );
      case 'number':
        return _buildTextField(
          label: label,
          keyboardType: TextInputType.number,
          required: required,
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, num.tryParse(v)),
        );
      case 'select':
        return DropdownButtonFormField<String>(
          value: formData[name]
              ?.toString(), // Use value instead of initialValue for controlled
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
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
        return _buildTextField(
          label: label,
          required: required,
          hint: 'YYYY-MM-DD',
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, v),
        );
      default:
        return _buildTextField(
          label: label,
          required: required,
          initialValue: formData[name]?.toString(),
          onChanged: (v) => notifier.updateFormData(name, v),
        );
    }
  }

  Widget _buildTextField({
    required String label,
    bool required = false,
    String? initialValue,
    ValueChanged<String>? onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        hintText: hint,
        labelStyle: TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  // ─── Step 2: Attachments ───
  Widget _buildAttachmentStep(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.attachmentPath != null &&
              state.attachmentPath!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'تم اختيار الملف',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.insert_drive_file,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      state.attachmentPath!.split(RegExp(r'[/\\]')).last,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                        fontFamily: 'Tajawal',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
                        );
                    if (result != null && result.files.single.path != null) {
                      notifier.setAttachment(result.files.single.path!);
                    }
                  },
                  icon: const Icon(Icons.swap_horiz),
                  label: Text('تغيير', style: TextStyle(fontFamily: 'Tajawal')),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => notifier.setAttachment(''),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  label: Text(
                    'حذف',
                    style: TextStyle(
                      color: AppColors.error,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'إرفاق صورة العقد أو المستند',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'صيغ مدعومة: JPG, PNG, PDF',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
                );
                if (result != null && result.files.single.path != null) {
                  notifier.setAttachment(result.files.single.path!);
                }
              },
              icon: const Icon(Icons.attach_file),
              label: Text(
                'اختيار ملف',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'هذه الخطوة اختيارية، يمكنك التخطي',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Step 3: Record Book Selection ───
  Widget _buildRecordBookStep(
    BuildContext context,
    WidgetRef ref,
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    final books = state.filteredRecordBooks;
    final isLoading = state.isLoadingRecordBooks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ربط بدفتر سجل (اختياري)'),
        const SizedBox(height: 8),
        Text(
          'اختر دفتر السجل الذي تريد ربط القيد به',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : books.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'لا توجد دفاتر سجلات',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يمكنك تخطي هذه الخطوة',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isSelected = state.selectedRecordBookId == book.id;
                    return _buildRecordBookCard(book, isSelected, notifier);
                  },
                ),
        ),
        if (state.selectedRecordBookId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () => notifier.setRecordBookId(null),
              icon: const Icon(Icons.clear, size: 16),
              label: Text(
                'إلغاء الاختيار',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecordBookCard(
    RecordBook book,
    bool isSelected,
    AddRegistryEntryNotifier notifier,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => notifier.setRecordBookId(book.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title.isNotEmpty
                          ? book.title
                          : 'دفتر رقم ${book.number}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    if (book.contractType.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        book.contractType,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Step 4: Review ───
  Widget _buildReviewStep(
    BuildContext context,
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    return ListView(
      children: [
        _buildSectionTitle('ملخص البيانات'),
        const SizedBox(height: 16),
        _buildReviewCard([
          _ReviewRow('نوع العقد', state.selectedType?.name ?? '-'),
          _ReviewRow('الموضوع', state.formData['subject']?.toString() ?? '-'),
          _ReviewRow(
            'السنة الهجرية',
            state.formData['hijri_year']?.toString() ?? '-',
          ),
          _ReviewRow(
            'رقم السجل',
            state.formData['register_number']?.toString() ?? '-',
          ),
        ]),
        const SizedBox(height: 12),
        _buildReviewCard([
          _ReviewRow(
            'الطرف الأول',
            state.formData['first_party_name']?.toString() ?? '-',
          ),
          _ReviewRow(
            'الطرف الثاني',
            state.formData['second_party_name']?.toString() ?? '-',
          ),
        ]),
        const SizedBox(height: 12),
        _buildReviewCard([
          _ReviewRow(
            'المرفق',
            state.attachmentPath != null && state.attachmentPath!.isNotEmpty
                ? state.attachmentPath!.split(RegExp(r'[/\\]')).last
                : 'لا يوجد',
          ),
          _ReviewRow(
            'دفتر السجل',
            state.selectedRecordBookId != null
                ? 'مربوط (#${state.selectedRecordBookId})'
                : 'غير مربوط',
          ),
        ]),
        if (state.formData['content'] != null &&
            state.formData['content'].toString().isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildReviewCard([
            _ReviewRow('الملاحظات', state.formData['content'].toString()),
          ]),
        ],
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    final success = await notifier.submitEntry(
                      manualBookNumber: null,
                      manualPageNumber: null,
                      manualEntryNumber: null,
                      documentDateGregorian:
                          DateTime.now(), // TODO: Get from form
                      documentDateHijri: null,
                      textFieldValues: {},
                    );
                    if (success && context.mounted) {
                      _showSuccessDialog(context);
                    }
                  },
            icon: state.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(
              state.isLoading ? 'جاري الحفظ...' : 'حفظ وإرسال',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReviewCard(List<_ReviewRow> rows) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: rows.asMap().entries.map((entry) {
            final isLast = entry.key == rows.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.value.label,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          entry.value.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: 'Tajawal',
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast) Divider(color: Colors.grey.shade100, height: 1),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'تم بنجاح!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تم إضافة القيد بنجاح وحفظه',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Go back
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('حسناً', style: TextStyle(fontFamily: 'Tajawal')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Tajawal',
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    if (state.currentStep == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          TextButton.icon(
            onPressed: state.currentStep > 0 ? notifier.prevStep : null,
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            label: Text('رجوع', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          const Spacer(),
          // Show next button for steps 1-3 (not on review step 4)
          if (state.currentStep < 4)
            ElevatedButton.icon(
              onPressed: notifier.nextStep,
              icon: Text('التالي', style: TextStyle(fontFamily: 'Tajawal')),
              label: const Icon(Icons.arrow_forward_ios, size: 14),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewRow {
  final String label;
  final String value;
  const _ReviewRow(this.label, this.value);
}
