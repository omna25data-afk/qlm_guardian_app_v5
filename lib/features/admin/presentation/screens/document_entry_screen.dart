import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../registry/data/models/registry_entry_model.dart';
import '../providers/admin_pending_entries_provider.dart';

class DocumentEntryScreen extends ConsumerStatefulWidget {
  final RegistryEntryModel entry;

  const DocumentEntryScreen({super.key, required this.entry});

  @override
  ConsumerState<DocumentEntryScreen> createState() =>
      _DocumentEntryScreenState();
}

class _DocumentEntryScreenState extends ConsumerState<DocumentEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for "بيانات القلم" (Admin Documentation Data)
  final _docEntryNumberController = TextEditingController();
  final _docRecordNumberController = TextEditingController();
  final _docPageNumberController = TextEditingController();
  final _docBoxNumberController = TextEditingController();
  final _docDocumentNumberController = TextEditingController();
  final _docHijriDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill if some data already exists (though usually it's empty for pending)
    _docEntryNumberController.text =
        widget.entry.docEntryNumber?.toString() ?? '';
    _docRecordNumberController.text =
        widget.entry.docRecordBookNumber?.toString() ?? '';
    _docPageNumberController.text =
        widget.entry.docPageNumber?.toString() ?? '';
    _docBoxNumberController.text = widget.entry.docBoxNumber?.toString() ?? '';
    _docDocumentNumberController.text =
        widget.entry.docDocumentNumber?.toString() ?? '';
    _docHijriDateController.text = widget.entry.docHijriDate ?? '';
  }

  @override
  void dispose() {
    _docEntryNumberController.dispose();
    _docRecordNumberController.dispose();
    _docPageNumberController.dispose();
    _docBoxNumberController.dispose();
    _docDocumentNumberController.dispose();
    _docHijriDateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'doc_entry_number': int.tryParse(_docEntryNumberController.text),
      'doc_record_number': int.tryParse(_docRecordNumberController.text),
      'doc_page_number': int.tryParse(_docPageNumberController.text),
      'doc_box_number': int.tryParse(_docBoxNumberController.text),
      'doc_document_number': int.tryParse(_docDocumentNumberController.text),
      'doc_hijri_date': _docHijriDateController.text,
    };

    final success = await ref
        .read(documentEntryProvider.notifier)
        .documentEntry(widget.entry.id!, data);

    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم توثيق القيد بنجاح')));
      ref
          .read(adminPendingEntriesProvider.notifier)
          .fetchEntries(refresh: true);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentEntryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'توثيق القيد (بيانات القلم)',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entry Summary Card
              _buildEntrySummary(),
              const SizedBox(height: 24),

              Text(
                'بيانات التوثيق الرسمية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _docEntryNumberController,
                label: 'رقم القيد بالقلم',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _docRecordNumberController,
                      label: 'رقم السجل',
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
                      controller: _docBoxNumberController,
                      label: 'رقم الصندوق',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _docDocumentNumberController,
                      label: 'رقم المحرر',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _docHijriDateController,
                label: 'التاريخ الهجري',
                hint: 'مثال: 1445/01/01',
              ),

              const SizedBox(height: 32),

              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: state.isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'إتمام التوثيق',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntrySummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('الطرف الأول', widget.entry.firstPartyName ?? '---'),
          const Divider(),
          _buildSummaryRow(
            'الطرف الثاني',
            widget.entry.secondPartyName ?? '---',
          ),
          const Divider(),
          _buildSummaryRow(
            'نوع العقد',
            widget.entry.contractType?.name ?? '---',
          ),
          const Divider(),
          _buildSummaryRow(
            'تاريخ الأمين',
            widget.entry.guardianHijriDate ?? '---',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}
