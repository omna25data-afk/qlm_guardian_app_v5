import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/add_registry_entry_provider.dart';

/// حقل نصي ذكي يتعامل مع إعدادات الحقول الديناميكية (الظهور، التسمية، الإلزامية)
/// يمكن تمرير [externalFilteredFields] لاستخدامها بدلاً من الاعتماد على
/// [addRegistryEntryProvider] — وهذا ضروري لواجهة الأمين الشرعي التي تستخدم provider مختلف.
class ContractTextField extends ConsumerWidget {
  final Map<String, TextEditingController> controllers;
  final String fieldKey;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<Map<String, dynamic>>? fieldsConfig;

  /// حقول مصفاة خارجية — عند تمريرها يتم استخدامها بدلاً من قراءة الـ provider
  final List<Map<String, dynamic>>? externalFilteredFields;

  const ContractTextField({
    super.key,
    required this.controllers,
    required this.fieldKey,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.fieldsConfig,
    this.externalFilteredFields,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // استخدام الحقول الخارجية إذا تم تمريرها، وإلا الاعتماد على الـ provider
    final List<Map<String, dynamic>> autoConfig;
    if (externalFilteredFields != null) {
      autoConfig = externalFilteredFields!;
    } else {
      final state = ref.watch(addRegistryEntryProvider);
      autoConfig = state.filteredFields;
    }

    Map<String, dynamic>? config;
    if (autoConfig.isNotEmpty) {
      try {
        config = autoConfig.firstWhere(
          (f) => f['name'] == fieldKey || f['column_name'] == fieldKey,
        );
      } catch (_) {}
    }

    // Checking visibility
    final bool isVisible =
        config?['is_visible'] == 1 ||
        config?['is_visible'] == true ||
        config?['visible'] == true ||
        config == null;
    if (!isVisible) return const SizedBox.shrink();

    // Getting label
    final String displayLabel =
        config?['field_label'] ?? config?['label'] ?? label;

    // Checking required status
    final bool isRequired =
        config?['is_required'] == 1 ||
        config?['is_required'] == true ||
        config?['required'] == true;

    controllers.putIfAbsent(fieldKey, () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controllers[fieldKey],
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: isRequired
            ? (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'هذا الحقل مطلوب';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: displayLabel + (isRequired ? ' *' : ''),
          labelStyle: const TextStyle(fontFamily: 'Tajawal'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
