import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
// Removed CustomTextField import
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_area_model.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_areas_provider.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/providers/admin_dashboard_provider.dart';

class AddEditAreaScreen extends ConsumerStatefulWidget {
  final AdminAreaModel? area; // If null, it's Add Mode

  const AddEditAreaScreen({super.key, this.area});

  @override
  ConsumerState<AddEditAreaScreen> createState() => _AddEditAreaScreenState();
}

class _AddEditAreaScreenState extends ConsumerState<AddEditAreaScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  String _selectedType = 'محافظة';
  int? _selectedParentId;
  String? _selectedParentName;
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _areaTypes = ['محافظة', 'مديرية', 'عزلة', 'قرية', 'محل'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.area?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.area?.description ?? '',
    );

    if (widget.area != null) {
      _selectedType = widget.area!.type;
      _selectedParentId = widget.area!.parentId;
      _selectedParentName = widget.area!.parentName;
      _isActive = widget.area!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'type': _selectedType,
        if (_selectedParentId != null) 'parent_id': _selectedParentId,
        'description': _descriptionController.text,
        'is_active': _isActive,
      };

      if (widget.area == null) {
        // Create
        final success = await ref
            .read(adminAreasProvider.notifier)
            .createArea(data);
        if (success && mounted) {
          Navigator.pop(context);
          _showSnackBar('تم إضافة المنطقة بنجاح', isError: false);
        } else if (mounted) {
          _showSnackBar('تعذر إضافة المنطقة', isError: true);
        }
      } else {
        // Update (Not fully implemented in backend maybe, assuming standard PUT)
        // await ref.read(adminRepositoryProvider).updateArea(widget.area!.id, data);
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

  // --- Parent Area Selection Dialog ---
  Future<void> _selectParentArea() async {
    final parentType = _getParentType(_selectedType);
    if (parentType == null) {
      _showSnackBar('لا يوجد مستوى أعلى لهذا النوع', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return _ParentAreaSearchDialog(targetType: parentType);
      },
    ).then((selectedArea) {
      if (selectedArea is AdminAreaModel) {
        setState(() {
          _selectedParentId = selectedArea.id;
          _selectedParentName = selectedArea.name;
        });
      }
    });
  }

  String? _getParentType(String type) {
    if (type == 'محل') return 'قرية';
    if (type == 'قرية') return 'عزلة';
    if (type == 'عزلة') return 'مديرية';
    if (type == 'مديرية') return 'محافظة';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.area != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditMode ? 'تعديل المنطقة' : 'إضافة منطقة جديدة',
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
              _buildSectionTitle('البيانات الأساسية'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'اسم المنطقة',
                icon: Icons.map,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم المنطقة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTypeDropdown(),
              const SizedBox(height: 16),
              if (_selectedType != 'محافظة') _buildParentSelector(),
              const SizedBox(height: 24),

              _buildSectionTitle('تفاصيل إضافية'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'وصف إضافي (اختياري)',
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              SwitchListTile(
                title: const Text(
                  'حالة المنطقة (مفعلة)',
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
                          isEditMode ? 'حفظ التعديلات' : 'إضافة المنطقة',
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

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _areaTypes.contains(_selectedType) ? _selectedType : 'محافظة',
      decoration: InputDecoration(
        labelText: 'نوع المنطقة',
        labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
        prefixIcon: const Icon(Icons.category, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
      ),
      items: _areaTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type, style: const TextStyle(fontFamily: 'Tajawal')),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedType = val;
            _selectedParentId = null;
            _selectedParentName = null;
          });
        }
      },
    );
  }

  Widget _buildParentSelector() {
    return InkWell(
      onTap: _selectParentArea,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.grey.withOpacity(0.05),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_tree, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المنطقة الأعلى (${_getParentType(_selectedType)})',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedParentName ?? 'اختر ...',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: _selectedParentName == null
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

class _ParentAreaSearchDialog extends ConsumerStatefulWidget {
  final String targetType;
  const _ParentAreaSearchDialog({required this.targetType});

  @override
  ConsumerState<_ParentAreaSearchDialog> createState() =>
      _ParentAreaSearchDialogState();
}

class _ParentAreaSearchDialogState
    extends ConsumerState<_ParentAreaSearchDialog> {
  List<AdminAreaModel> _areas = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    try {
      final repository = ref.read(adminRepositoryProvider);
      final results = await repository.getAreas(type: widget.targetType);
      if (mounted) {
        setState(() {
          _areas = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'اختر ${widget.targetType}',
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : _areas.isEmpty
            ? const Center(
                child: Text(
                  'لا توجد بيانات',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              )
            : ListView.builder(
                itemCount: _areas.length,
                itemBuilder: (context, index) {
                  final area = _areas[index];
                  return ListTile(
                    title: Text(
                      area.name,
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                    onTap: () => Navigator.pop(context, area),
                  );
                },
              ),
      ),
    );
  }
}
