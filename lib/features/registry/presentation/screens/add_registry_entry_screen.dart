import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/form_field_model.dart';
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
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStepper(state.currentStep),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildStepContent(context, state, notifier),
                  ),
                ),
                _buildBottomBar(context, state, notifier),
              ],
            ),
    );
  }

  Widget _buildStepper(int currentStep) {
    final steps = ['نوع العقد', 'البيانات', 'المرفقات', 'مراجعة'];
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
                radius: 12,
                backgroundColor: isActive
                    ? AppColors.primary
                    : Colors.grey.shade300,
                child: Text(
                  '${stepIndex + 1}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex],
                style: GoogleFonts.tajawal(
                  fontSize: 10,
                  color: isActive ? AppColors.textPrimary : AppColors.textHint,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    if (state.error != null) {
      return Center(child: Text('خطأ: ${state.error}'));
    }

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
        return _buildReviewStep(context, state, notifier);
      default:
        return const SizedBox();
    }
  }

  Widget _buildTypeSelectionStep(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    if (state.contractTypes.isEmpty) {
      return const Center(child: Text('جاري تحميل أنواع العقود...'));
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
                  Icons.description_outlined,
                  size: 32,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  type.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormStep(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    return ListView(
      children: [
        _buildSectionTitle('بيانات أساسية'),
        const SizedBox(height: 12),
        // Basic fields that are always needed
        _buildTextField(
          label: 'رقم السجل (اختياري)',
          onChanged: (v) => notifier.updateFormData('register_number', v),
          initialValue: state.formData['register_number'],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'التاريخ الهجري',
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    notifier.updateFormData('hijri_year', int.tryParse(v)),
                initialValue: state.formData['hijri_year']?.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                label: 'الموضوع',
                initialValue:
                    state.formData['subject'] ?? state.selectedType?.name,
                onChanged: (v) => notifier.updateFormData('subject', v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (state.formFields.isNotEmpty) ...[
          _buildSectionTitle('بيانات العقد (${state.selectedType?.name})'),
          const SizedBox(height: 12),
          ...state.formFields.map((field) {
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
    FormFieldModel field,
    Map<String, dynamic> formData,
    AddRegistryEntryNotifier notifier,
  ) {
    switch (field.type) {
      case 'textarea':
        return _buildTextField(
          label: field.label,
          maxLines: 3,
          required: field.required,
          initialValue: formData[field.name]?.toString(),
          onChanged: (v) => notifier.updateFormData(field.name, v),
        );
      case 'number':
        return _buildTextField(
          label: field.label,
          keyboardType: TextInputType.number,
          required: field.required,
          initialValue: formData[field.name]?.toString(),
          onChanged: (v) =>
              notifier.updateFormData(field.name, num.tryParse(v)),
        );
      case 'select':
        return DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: formData[field.name]?.toString(),
          decoration: InputDecoration(
            labelText: field.label + (field.required ? ' *' : ''),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items:
              field.options
                  ?.map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList() ??
              [],
          onChanged: (v) => notifier.updateFormData(field.name, v),
        );
      case 'date':
        // Simple date field for now
        return _buildTextField(
          label: field.label,
          required: field.required,
          hint: 'YYYY-MM-DD',
          initialValue: formData[field.name]?.toString(),
          onChanged: (v) => notifier.updateFormData(field.name, v),
        );
      default:
        return _buildTextField(
          label: field.label,
          required: field.required,
          initialValue: formData[field.name]?.toString(),
          onChanged: (v) => notifier.updateFormData(field.name, v),
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

  Widget _buildAttachmentStep(
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.attachmentPath != null) ...[
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            'تم اختيار الملف',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          Text(
            state.attachmentPath!.split('/').last,
            style: GoogleFonts.tajawal(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => notifier.setAttachment(
              '',
            ), // Clear (need to handle null/empty in notifier properly, assume empty string removes)
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('حذف'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ] else ...[
          const Icon(Icons.cloud_upload_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'يرجى إرفاق صورة العقد أو المستند',
            style: GoogleFonts.tajawal(color: Colors.grey),
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
            label: const Text('اختيار ملف'),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewStep(
    BuildContext context,
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ملخص البيانات'),
        const SizedBox(height: 16),
        _buildReviewItem('نوع العقد', state.selectedType?.name ?? '-'),
        _buildReviewItem('الموضوع', state.formData['subject'] ?? '-'),
        _buildReviewItem(
          'الملف المرفق',
          state.attachmentPath != null ? 'نعم' : 'لا',
        ),
        const Divider(height: 32),
        const Spacer(),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              final success = await notifier.submit();
              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إضافة القيد بنجاح')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('حفظ وإرسال'),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.tajawal(color: Colors.grey)),
          Text(value, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    AddRegistryEntryState state,
    AddRegistryEntryNotifier notifier,
  ) {
    // Hide bottom bar in step 0 (Type Selection) as selection auto-advances
    // Only show back button?
    // Actually standard Wizard has Back/Next.
    // My selection step auto-advances.

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
          if (state.currentStep > 0)
            TextButton(onPressed: notifier.prevStep, child: const Text('رجوع')),
          const Spacer(),
          if (state.currentStep < 3 && state.currentStep > 0)
            ElevatedButton(
              onPressed: notifier.nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('التالي'),
            ),
        ],
      ),
    );
  }
}
