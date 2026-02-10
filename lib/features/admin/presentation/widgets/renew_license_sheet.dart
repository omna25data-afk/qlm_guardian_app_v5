import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/admin_guardian_model.dart';
import '../providers/admin_dashboard_provider.dart'; // To get adminRepositoryProvider

class RenewLicenseSheet extends ConsumerStatefulWidget {
  final AdminGuardianModel guardian;

  const RenewLicenseSheet({super.key, required this.guardian});

  @override
  ConsumerState<RenewLicenseSheet> createState() => _RenewLicenseSheetState();
}

class _RenewLicenseSheetState extends ConsumerState<RenewLicenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _renewalDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _receiptNumberController = TextEditingController();
  final _receiptAmountController = TextEditingController();
  final _receiptDateController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _renewalDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
  }

  @override
  void dispose() {
    _renewalDateController.dispose();
    _expiryDateController.dispose();
    _receiptNumberController.dispose();
    _receiptAmountController.dispose();
    _receiptDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'اختر التاريخ',
      cancelText: 'إلغاء',
      confirmText: 'موافق',
    );
    if (picked != null) {
      if (mounted) {
        setState(() {
          controller.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'guardian_id': widget.guardian.id,
        'renewal_date': _renewalDateController.text,
        'expiry_date': _expiryDateController.text,
        'receipt_number': _receiptNumberController.text,
        'receipt_amount': _receiptAmountController.text,
        'receipt_date': _receiptDateController.text,
        'notes': _notesController.text,
      };

      final repository = ref.read(adminRepositoryProvider);
      await repository.submitLicenseRenewal(widget.guardian.id, data);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم تجديد الترخيص بنجاح',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ: $e',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تجديد الترخيص',
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _renewalDateController,
                      label: 'تاريخ التجديد',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(_renewalDateController),
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _expiryDateController,
                      label: 'تاريخ الانتهاء',
                      icon: Icons.event_busy,
                      readOnly: true,
                      onTap: () => _selectDate(_expiryDateController),
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _receiptNumberController,
                      label: 'رقم الإيصال',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _receiptDateController,
                      label: 'تاريخ الإيصال',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(_receiptDateController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _receiptAmountController,
                label: 'المبلغ',
                suffix: 'ر.ي',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات',
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'حفظ التجديد',
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    String? suffix,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.tajawal(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.tajawal(color: Colors.grey, fontSize: 13),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.primary, size: 20)
            : null,
        suffixText: suffix,
        suffixStyle: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
