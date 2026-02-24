import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
// Removed CustomTextField import
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_assignment_model.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_guardian_model.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_area_model.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_assignments_provider.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_dashboard_provider.dart';

class AddEditAssignmentScreen extends ConsumerStatefulWidget {
  final AdminAssignmentModel? assignment; // Null if Add Mode

  const AddEditAssignmentScreen({super.key, this.assignment});

  @override
  ConsumerState<AddEditAssignmentScreen> createState() =>
      _AddEditAssignmentScreenState();
}

class _AddEditAssignmentScreenState
    extends ConsumerState<AddEditAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _originalGuardianId;
  String? _originalGuardianName;

  int? _assignedGuardianId;
  String? _assignedGuardianName;

  AdminAreaModel? _selectedArea;

  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _reasonController;
  late TextEditingController _notesController;

  String _assignmentType = 'تكليف عمل';
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _assignmentTypes = ['تكليف عمل', 'تكليف مؤقت', 'نقل'];

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController(
      text:
          widget.assignment?.startDate ??
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    _endDateController = TextEditingController(
      text: widget.assignment?.endDate ?? '',
    );
    _reasonController = TextEditingController(
      text: widget.assignment?.reason ?? '',
    );
    _notesController = TextEditingController(
      text: widget.assignment?.notes ?? '',
    );

    if (widget.assignment != null) {
      _originalGuardianId = widget.assignment!.originalGuardianId;
      _assignedGuardianId = widget.assignment!.assignedGuardianId;
      _originalGuardianName = widget.assignment!.guardianName;
      _assignedGuardianName =
          widget.assignment!.guardianName; // assuming they are same for editing
      _assignmentType = widget.assignment!.assignmentType ?? 'تكليف عمل';
      _isActive = widget.assignment!.isActive ?? true;
      // Area is more complex to set initially without fetching, leaving it blank for now
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
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
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_assignedGuardianId == null) {
      _showSnackBar('يجب اختيار الأمين المكلف', isError: true);
      return;
    }
    if (_selectedArea == null) {
      _showSnackBar('يجب اختيار منطقة الاختصاص', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'original_guardian_id': _originalGuardianId,
        'assigned_guardian_id': _assignedGuardianId,
        'region_id': _selectedArea?.id,
        'assignment_type': _assignmentType,
        'start_date': _startDateController.text,
        'end_date': _endDateController.text.isNotEmpty
            ? _endDateController.text
            : null,
        'reason': _reasonController.text,
        'notes': _notesController.text,
        'is_active': _isActive,
      };

      if (widget.assignment == null) {
        final success = await ref
            .read(adminAssignmentsProvider.notifier)
            .createAssignment(data);
        if (success && mounted) {
          Navigator.pop(context);
          _showSnackBar('تم إضافة التكليف بنجاح', isError: false);
        } else if (mounted) {
          _showSnackBar('تعذر إضافة التكليف', isError: true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ميزة التعديل قيد التطوير نظراً لنقص endpoint',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        );
        Navigator.pop(context);
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

  Future<void> _selectGuardian(bool isOriginal) async {
    showDialog(
      context: context,
      builder: (context) => const _GuardianSearchDialog(),
    ).then((guardian) {
      if (guardian is AdminGuardianModel) {
        setState(() {
          if (isOriginal) {
            _originalGuardianId = guardian.id;
            _originalGuardianName = guardian.name;
          } else {
            _assignedGuardianId = guardian.id;
            _assignedGuardianName = guardian.name;
          }
        });
      }
    });
  }

  Future<void> _selectArea() async {
    showDialog(
      context: context,
      builder: (context) => const _AreaSearchDialog(),
    ).then((area) {
      if (area is AdminAreaModel) {
        setState(() {
          _selectedArea = area;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.assignment != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditMode ? 'تعديل التكليف' : 'إضافة تكليف جديد',
          style: const TextStyle(
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
              _buildSectionTitle('أطراف التكليف'),
              const SizedBox(height: 16),

              _buildGuardianSelector(
                title: 'الأمين الأصلي (اختياري)',
                guardianName: _originalGuardianName,
                onTap: () => _selectGuardian(true),
              ),
              const SizedBox(height: 16),

              _buildGuardianSelector(
                title: 'الأمين المكلف (إجباري)',
                guardianName: _assignedGuardianName,
                onTap: () => _selectGuardian(false),
                isMandatory: true,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('منطقة الاختصاص المكلف بها'),
              const SizedBox(height: 16),
              _buildAreaSelector(),
              const SizedBox(height: 24),

              _buildSectionTitle('تفاصيل التكليف'),
              const SizedBox(height: 16),
              _buildTypeDropdown(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _startDateController,
                      label: 'تاريخ البدء',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(_startDateController),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _endDateController,
                      label: 'تاريخ الانتهاء',
                      icon: Icons.event_busy,
                      readOnly: true,
                      onTap: () => _selectDate(_endDateController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _reasonController,
                label: 'سبب التكليف',
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات',
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text(
                  'التكليف ساري المفعول',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                value: _isActive,
                activeColor: AppColors.success,
                onChanged: (val) => setState(() => _isActive = val),
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
                      : Text(
                          isEditMode ? 'حفظ التعديلات' : 'إضافة التكليف',
                          style: const TextStyle(
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

  Widget _buildGuardianSelector({
    required String title,
    String? guardianName,
    required VoidCallback onTap,
    bool isMandatory = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMandatory && guardianName == null
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
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    guardianName ?? 'اختر الأمين...',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: guardianName == null
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
    );
  }

  Widget _buildAreaSelector() {
    return InkWell(
      onTap: _selectArea,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedArea == null
                ? Colors.red.shade300
                : Colors.grey.shade300,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.map, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المنطقة',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedArea?.name ?? 'اختر المنطقة...',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: _selectedArea == null
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
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _assignmentTypes.contains(_assignmentType)
          ? _assignmentType
          : 'تكليف عمل',
      decoration: InputDecoration(
        labelText: 'نوع التكليف',
        labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
        prefixIcon: const Icon(Icons.class_, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _assignmentTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type, style: const TextStyle(fontFamily: 'Tajawal')),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) setState(() => _assignmentType = val);
      },
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
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
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

class _AreaSearchDialog extends ConsumerStatefulWidget {
  const _AreaSearchDialog();
  @override
  ConsumerState<_AreaSearchDialog> createState() => _AreaSearchDialogState();
}

class _AreaSearchDialogState extends ConsumerState<_AreaSearchDialog> {
  List<AdminAreaModel> _areas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final repository = ref.read(adminRepositoryProvider);
      // Fetching all areas for simplicity, ideally should implement a proper search
      final results = await repository.getAreas();
      if (mounted)
        setState(() {
          _areas = results;
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
        'اختر المنطقة',
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _areas.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(
                    '${_areas[i].name} (${_areas[i].type})',
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
                  onTap: () => Navigator.pop(context, _areas[i]),
                ),
              ),
      ),
    );
  }
}
