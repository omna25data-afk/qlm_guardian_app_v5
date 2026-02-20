import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../system/data/models/registry_entry_sections.dart';
import '../../data/repositories/admin_repository.dart';
import '../../../../../core/di/injection.dart';
import '../screens/tabs/all_entries_tab.dart'; // To refresh the provider

class RegistryEntryCorrectionDialog extends ConsumerStatefulWidget {
  final RegistryEntrySections entry;

  const RegistryEntryCorrectionDialog({super.key, required this.entry});

  @override
  ConsumerState<RegistryEntryCorrectionDialog> createState() =>
      _RegistryEntryCorrectionDialogState();
}

class _RegistryEntryCorrectionDialogState
    extends ConsumerState<RegistryEntryCorrectionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstPartyController;
  late TextEditingController _secondPartyController;
  late TextEditingController _feeAmountController;
  late TextEditingController _penaltyAmountController;
  late TextEditingController _supportAmountController;
  late TextEditingController _sustainabilityAmountController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstPartyController = TextEditingController(
      text: widget.entry.basicInfo.firstPartyName,
    );
    _secondPartyController = TextEditingController(
      text: widget.entry.basicInfo.secondPartyName,
    );
    _feeAmountController = TextEditingController(
      text: widget.entry.financialInfo.feeAmount?.toString() ?? '0',
    );
    _penaltyAmountController = TextEditingController(
      text: widget.entry.financialInfo.penaltyAmount?.toString() ?? '0',
    );
    _supportAmountController = TextEditingController(
      text: widget.entry.financialInfo.supportAmount?.toString() ?? '0',
    );
    _sustainabilityAmountController = TextEditingController(
      text: widget.entry.financialInfo.sustainabilityAmount?.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _firstPartyController.dispose();
    _secondPartyController.dispose();
    _feeAmountController.dispose();
    _penaltyAmountController.dispose();
    _supportAmountController.dispose();
    _sustainabilityAmountController.dispose();
    super.dispose();
  }

  Future<void> _submitCorrection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = getIt<AdminRepository>();

      final data = {
        'first_party_name': _firstPartyController.text,
        'second_party_name': _secondPartyController.text,
        'fee_amount': double.tryParse(_feeAmountController.text) ?? 0,
        'penalty_amount': double.tryParse(_penaltyAmountController.text) ?? 0,
        'support_amount': double.tryParse(_supportAmountController.text) ?? 0,
        'sustainability_amount':
            double.tryParse(_sustainabilityAmountController.text) ?? 0,
      };

      await repository.updateRegistryEntry(widget.entry.id, data);

      if (mounted) {
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم تصحيح القيد بنجاح',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the list
        ref.read(allEntriesProvider.notifier).fetchEntries();

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء التصحيح: $e',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مسار تصحيح القيد',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('أطراف العقد'),
                      _buildTextField(
                        controller: _firstPartyController,
                        label: 'الطرف الأول',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _secondPartyController,
                        label: 'الطرف الثاني',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('البيانات المالية'),
                      _buildTextField(
                        controller: _feeAmountController,
                        label: 'رسوم المحرر الأساسية',
                        icon: Icons.money,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _penaltyAmountController,
                        label: 'الغرامة (إن وجدت)',
                        icon: Icons.warning_amber_rounded,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _supportAmountController,
                        label: 'رسوم الدعم',
                        icon: Icons.handshake,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _sustainabilityAmountController,
                        label: 'مساهمة الاستدامة',
                        icon: Icons.eco,
                        isNumber: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitCorrection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'حفظ التعديلات',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'يرجى إدخال رقم صحيح';
        }
        return null;
      },
    );
  }
}
