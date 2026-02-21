import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../records/data/models/record_book.dart';
import '../../data/repositories/admin_repository.dart';
import '../../../../../core/di/injection.dart';
import '../providers/admin_record_books_provider.dart';

class RecordBookCorrectionDialog extends ConsumerStatefulWidget {
  final RecordBook book;

  const RecordBookCorrectionDialog({super.key, required this.book});

  @override
  ConsumerState<RecordBookCorrectionDialog> createState() =>
      _RecordBookCorrectionDialogState();
}

class _RecordBookCorrectionDialogState
    extends ConsumerState<RecordBookCorrectionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bookNumberController;
  late TextEditingController _hijriYearController;
  late TextEditingController _totalPagesController;
  late TextEditingController _ministryRecordNumberController;

  String? _selectedStatus;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bookNumberController = TextEditingController(
      text: widget.book.bookNumber.toString(),
    );
    _hijriYearController = TextEditingController(
      text: widget.book.hijriYear.toString(),
    );
    _totalPagesController = TextEditingController(
      text: widget.book.totalPages.toString(),
    );
    _ministryRecordNumberController = TextEditingController(
      text: widget.book.ministryRecordNumber ?? '',
    );

    // Status can be 'open' or 'closed' based on backend enum
    _selectedStatus = widget.book.status;
  }

  @override
  void dispose() {
    _bookNumberController.dispose();
    _hijriYearController.dispose();
    _totalPagesController.dispose();
    _ministryRecordNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitCorrection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = getIt<AdminRepository>();

      final data = {
        'book_number': int.tryParse(_bookNumberController.text),
        'hijri_year': int.tryParse(_hijriYearController.text),
        'total_pages': int.tryParse(_totalPagesController.text),
        'ministry_record_number': _ministryRecordNumberController.text,
        'status': _selectedStatus,
      };

      await repository.updateRecordBook(widget.book.id, data);

      if (mounted) {
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم تصحيح السجل بنجاح',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the list
        ref.read(adminRecordBooksProvider.notifier).fetchBooks();

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
                    'مسار تصحيح السجل',
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
                      _buildSectionTitle('بيانات السجل الأساسية'),
                      _buildTextField(
                        controller: _bookNumberController,
                        label: 'رقم السجل',
                        icon: Icons.book,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _hijriYearController,
                        label: 'السنة الهجرية',
                        icon: Icons.date_range,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _totalPagesController,
                        label: 'عدد الصفحات',
                        icon: Icons.pages,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _ministryRecordNumberController,
                        label: 'رقم السجل بالوزارة',
                        icon: Icons.numbers,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('حالة السجل'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'حالة السجل',
                          prefixIcon: const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'active',
                            child: Text(
                              'مفتوح / نشط',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'closed',
                            child: Text(
                              'مغلق',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'archived',
                            child: Text(
                              'مؤرشف',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'full',
                            child: Text(
                              'ممتلئ',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'pending_opening',
                            child: Text(
                              'بانتظار الافتتاح',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedStatus = val;
                          });
                        },
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
                          'حفظ تصحيح السجل',
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
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        if (isNumber && int.tryParse(value) == null) {
          return 'يرجى إدخال رقم صحيح';
        }
        return null;
      },
    );
  }
}
