import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_guardian_model.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_cards_provider.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_dashboard_provider.dart';

class AddEditCardScreen extends ConsumerStatefulWidget {
  const AddEditCardScreen({super.key});

  @override
  ConsumerState<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends ConsumerState<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedGuardianId;
  String? _selectedGuardianName;

  late TextEditingController _renewalDateController;
  late TextEditingController _expiryDateController;
  late TextEditingController _receiptNumberController;
  late TextEditingController _receiptAmountController;
  late TextEditingController _receiptDateController;
  late TextEditingController _notesController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _renewalDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    _expiryDateController = TextEditingController();
    _receiptNumberController = TextEditingController();
    _receiptAmountController = TextEditingController();
    _receiptDateController = TextEditingController();
    _notesController = TextEditingController();
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
      lastDate: DateTime(2075),
    );
    if (picked != null) {
      if (mounted)
        setState(
          () => controller.text = DateFormat('yyyy-MM-dd').format(picked),
        );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGuardianId == null) {
      _showSnackBar('يجب اختيار الأمين أولاً', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'guardian_id': _selectedGuardianId,
        'renewal_date': _renewalDateController.text,
        'expiry_date': _expiryDateController.text,
        'receipt_number': _receiptNumberController.text,
        'receipt_amount': _receiptAmountController.text,
        'receipt_date': _receiptDateController.text,
        'notes': _notesController.text,
      };

      final success = await ref
          .read(adminCardsProvider.notifier)
          .renewCard(_selectedGuardianId!, data);

      if (success && mounted) {
        Navigator.pop(context);
        _showSnackBar('تم تجديد البطاقة بنجاح', isError: false);
      } else if (mounted) {
        _showSnackBar('تعذر تجديد البطاقة', isError: true);
      }
    } catch (e) {
      if (mounted) _showSnackBar('خطأ: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  Future<void> _selectGuardian() async {
    showDialog(
      context: context,
      builder: (context) => const _GuardianSearchDialog(),
    ).then((guardian) {
      if (guardian is AdminGuardianModel) {
        setState(() {
          _selectedGuardianId = guardian.id;
          _selectedGuardianName = guardian.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'تجديد بطاقة مستخدم',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('صاحب البطاقة'),
              const SizedBox(height: 16),

              InkWell(
                onTap: _selectGuardian,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGuardianId == null
                          ? Colors.red.shade300
                          : Colors.grey.shade300,
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_search, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الأمين',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedGuardianName ?? 'اختر الأمين...',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                color: _selectedGuardianName == null
                                    ? Colors.grey
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('بيانات التجديد'),
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
                      validator: (val) =>
                          val == null || val.isEmpty ? 'مطلوب' : null,
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
                      validator: (val) =>
                          val == null || val.isEmpty ? 'مطلوب' : null,
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات',
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'حفظ التجديد',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
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
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Tajawal',
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
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontFamily: 'Tajawal',
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.primary, size: 20)
            : null,
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

// Reuse the search dialog from assignment screen (should ideally be shared)
class _GuardianSearchDialog extends ConsumerStatefulWidget {
  const _GuardianSearchDialog();
  @override
  ConsumerState<_GuardianSearchDialog> createState() =>
      _GuardianSearchDialogState();
}

class _GuardianSearchDialogState extends ConsumerState<_GuardianSearchDialog> {
  List<AdminGuardianModel> _guardians = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final repository = ref.read(adminRepositoryProvider);
      final results = await repository.getActiveGuardians();
      if (mounted)
        setState(() {
          _guardians = results;
          _isLoading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'اختر الأمين',
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _guardians.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(
                    _guardians[i].name,
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
                  onTap: () => Navigator.pop(context, _guardians[i]),
                ),
              ),
      ),
    );
  }
}
