import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

/// Builds dynamic form fields from API field configurations
class DynamicFieldBuilder extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final bool isLoading;
  final Map<String, TextEditingController> controllers;
  final ValueChanged<MapEntry<String, String>> onFieldChanged;
  final Map<String, dynamic> initialValues;

  const DynamicFieldBuilder({
    super.key,
    required this.fields,
    required this.isLoading,
    required this.controllers,
    required this.onFieldChanged,
    this.initialValues = const {},
  });

  @override
  State<DynamicFieldBuilder> createState() => _DynamicFieldBuilderState();
}

class _DynamicFieldBuilderState extends State<DynamicFieldBuilder> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildShimmer();
    }

    if (widget.fields.isEmpty) {
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
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.fields
              .map((field) => _buildFieldWrapper(context, field))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFieldWrapper(BuildContext context, Map<String, dynamic> field) {
    // 1 -> half width, 2 or full -> full width
    final span = field['column_span']?.toString() ?? 'full';
    final isHalf = span == '1';

    // Calculate width: half screen (minus spacing) or full screen
    final screenWidth = MediaQuery.of(context).size.width;
    // Assuming standard padding is around 16*2 on edges
    final availableWidth = screenWidth - 32;
    final width = isHalf ? (availableWidth - 12) / 2 : availableWidth;

    return SizedBox(width: width, child: _buildField(context, field));
  }

  Widget _buildField(BuildContext context, Map<String, dynamic> field) {
    final fieldName =
        field['column_name'] as String? ?? field['name'] as String? ?? '';
    final fieldLabel =
        field['field_label'] as String? ?? field['label'] as String? ?? '';
    final fieldType =
        field['field_type'] as String? ?? field['type'] as String? ?? 'text';
    final placeholder = field['placeholder'] as String?;
    final helperText = field['helper_text'] as String?;

    // Validation
    final isRequired =
        field['is_required'] == true ||
        field['is_required'] == 1 ||
        field['is_required'] == '1';

    // Ensure controller exists — pre-fill from initialValues if available
    if (!widget.controllers.containsKey(fieldName)) {
      final initialValue = widget.initialValues[fieldName];
      widget.controllers[fieldName] = TextEditingController(
        text: initialValue?.toString() ?? '',
      );
    } else if (widget.controllers[fieldName]!.text.isEmpty) {
      // If controller exists but is empty, try to fill from initialValues
      final initialValue = widget.initialValues[fieldName];
      if (initialValue != null && initialValue.toString().isNotEmpty) {
        widget.controllers[fieldName]!.text = initialValue.toString();
      }
    }

    final controller = widget.controllers[fieldName]!;

    // Common Decoration
    final decoration = InputDecoration(
      labelText: '$fieldLabel${isRequired ? " *" : ""}',
      hintText: placeholder,
      helperText: helperText,
      prefixIcon: Icon(
        _getFieldIcon(fieldType),
        size: 20,
        color: AppColors.primaryLight,
      ),
    );

    // HIDDEN
    if (fieldType == 'hidden') {
      return const SizedBox.shrink();
    }

    // DATE PICKER
    if (fieldType == 'date' || fieldType == 'datetime') {
      final isDateTime = fieldType == 'datetime';
      return TextFormField(
        controller: controller,
        readOnly: true,
        decoration: decoration,
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            DateTime finalDateTime = pickedDate;
            if (isDateTime) {
              if (!context.mounted) return;
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
              }
            }
            final format = isDateTime ? 'yyyy-MM-dd HH:mm:ss' : 'yyyy-MM-dd';
            final formatted = DateFormat(format).format(finalDateTime);
            controller.text = formatted;
            widget.onFieldChanged(MapEntry(fieldName, formatted));
          }
        },
        validator: isRequired
            ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
            : null,
      );
    }

    // TOGGLE / CHECKBOX
    if (fieldType == 'toggle' || fieldType == 'checkbox') {
      // Default to false if empty
      if (controller.text.isEmpty) {
        controller.text = 'false';
        // Post frame callback so we don't trigger setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onFieldChanged(MapEntry(fieldName, 'false'));
        });
      }
      final boolValue = controller.text == 'true' || controller.text == '1';

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$fieldLabel${isRequired ? " *" : ""}',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  if (helperText != null && helperText.isNotEmpty)
                    Text(
                      helperText,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (fieldType == 'toggle')
              Switch(
                value: boolValue,
                activeTrackColor: AppColors.primaryLight.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primaryLight,
                onChanged: (val) {
                  controller.text = val.toString();
                  widget.onFieldChanged(MapEntry(fieldName, val.toString()));
                  setState(
                    () {},
                  ); // Trigger rebuild for this specific widget wrapper due to state change
                },
              )
            else
              Checkbox(
                value: boolValue,
                activeColor: AppColors.primaryLight,
                onChanged: (val) {
                  final newValue = val ?? false;
                  controller.text = newValue.toString();
                  widget.onFieldChanged(
                    MapEntry(fieldName, newValue.toString()),
                  );
                  setState(() {});
                },
              ),
          ],
        ),
      );
    }

    // FILE
    if (fieldType == 'file') {
      return TextFormField(
        controller: controller,
        readOnly: true,
        decoration: decoration.copyWith(
          suffixIcon: IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              // Placeholder for file picking logic.
              // In the future, integrate file_picker here.
              controller.text = 'تم اختيار ملف (محاكاة)';
              widget.onFieldChanged(MapEntry(fieldName, controller.text));
            },
          ),
        ),
        validator: isRequired
            ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
            : null,
      );
    }

    // SELECT (DROPDOWN) AND RELATIONSHIP (fallback to Select for now)
    if (fieldType == 'select' || fieldType == 'relationship') {
      List<String> optionsList = [];
      final rawOptions = field['options'];
      if (rawOptions != null) {
        if (rawOptions is List) {
          optionsList = rawOptions.map((e) => e.toString()).toList();
        } else if (rawOptions is String) {
          try {
            final parsed = jsonDecode(rawOptions);
            if (parsed is List) {
              optionsList = parsed.map((e) => e.toString()).toList();
            }
          } catch (_) {
            // fallback to comma separated
            optionsList = rawOptions.split(',').map((e) => e.trim()).toList();
          }
        }
      }

      if (optionsList.isNotEmpty) {
        return DropdownButtonFormField<String>(
          initialValue:
              controller.text.isNotEmpty &&
                  optionsList.contains(controller.text)
              ? controller.text
              : null,
          decoration: decoration,
          items: optionsList
              .map(
                (str) => DropdownMenuItem<String>(value: str, child: Text(str)),
              )
              .toList(),
          onChanged: (String? val) {
            if (val != null) {
              controller.text = val;
              widget.onFieldChanged(MapEntry(fieldName, val));
            }
          },
          validator: isRequired
              ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
              : null,
        );
      }
    }

    // DEFAULT: Text or Textarea or Number
    return TextFormField(
      controller: controller,
      decoration: decoration,
      onChanged: (val) => widget.onFieldChanged(MapEntry(fieldName, val)),
      keyboardType: _getKeyboardType(fieldType),
      maxLines: fieldType == 'textarea' ? 3 : 1,
      validator: isRequired
          ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
          : null,
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
