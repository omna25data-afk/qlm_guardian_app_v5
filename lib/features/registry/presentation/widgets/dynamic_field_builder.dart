import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

/// Builds dynamic form fields from API field configurations
class DynamicFieldBuilder extends StatelessWidget {
  final List<Map<String, dynamic>> fields;
  final bool isLoading;
  final Map<String, TextEditingController> controllers;
  final ValueChanged<MapEntry<String, String>> onFieldChanged;

  const DynamicFieldBuilder({
    super.key,
    required this.fields,
    required this.isLoading,
    required this.controllers,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer();
    }

    if (fields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.dynamic_form, size: 16, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              'حقول إضافية',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...fields.map((field) => _buildField(context, field)),
      ],
    );
  }

  Widget _buildField(BuildContext context, Map<String, dynamic> field) {
    final fieldName = field['name'] as String? ?? '';
    final fieldLabel = field['label'] as String? ?? '';
    final fieldType = field['type'] as String? ?? 'text';
    final isRequired = field['required'] == true;

    // Ensure controller exists
    if (!controllers.containsKey(fieldName)) {
      controllers[fieldName] = TextEditingController();
    }

    final controller = controllers[fieldName]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$fieldLabel${isRequired ? " *" : ""}',
          prefixIcon: Icon(
            _getFieldIcon(fieldType),
            size: 20,
            color: AppColors.primaryLight,
          ),
        ),
        onChanged: (val) => onFieldChanged(MapEntry(fieldName, val)),
        keyboardType: _getKeyboardType(fieldType),
        maxLines: fieldType == 'textarea' ? 3 : 1,
        validator: isRequired
            ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
            : null,
      ),
    );
  }

  IconData _getFieldIcon(String type) {
    return switch (type) {
      'number' => Icons.pin,
      'date' => Icons.calendar_today,
      'textarea' => Icons.notes,
      'select' => Icons.list,
      'toggle' || 'checkbox' => Icons.check_box,
      _ => Icons.text_fields,
    };
  }

  TextInputType _getKeyboardType(String type) {
    return switch (type) {
      'number' => TextInputType.number,
      'date' => TextInputType.datetime,
      _ => TextInputType.text,
    };
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
