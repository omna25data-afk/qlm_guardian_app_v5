import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/field_management_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/form_field_config_model.dart';

class FieldManagementScreen extends ConsumerStatefulWidget {
  const FieldManagementScreen({super.key});

  @override
  ConsumerState<FieldManagementScreen> createState() =>
      _FieldManagementScreenState();
}

class _FieldManagementScreenState extends ConsumerState<FieldManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fieldManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة حقول النظام',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(fieldManagementProvider.notifier).loadFields(),
          ),
        ],
      ),
      body: state.when(
        data: (fieldState) {
          final groupedFields = fieldState.groupedFields;
          final availableContracts = fieldState.availableContracts;
          final availableTables = fieldState.availableTables;

          return Column(
            children: [
              // Filters Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Contract Types Filter
                      DropdownMenu<String>(
                        label: const Text('نوع العقد'),
                        initialSelection: fieldState.activeContract ?? 'All',
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(
                            value: 'All',
                            label: 'الكل (أنواع العقود)',
                          ),
                          ...availableContracts.map(
                            (contract) => DropdownMenuEntry(
                              value: contract,
                              label: contract,
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          ref
                              .read(fieldManagementProvider.notifier)
                              .setFilter(contract: value);
                        },
                        width: 250,
                      ),
                      const SizedBox(width: 16),
                      // Table Schemas Filter
                      DropdownMenu<String>(
                        label: const Text('الجدول'),
                        initialSelection: fieldState.activeTable ?? 'All',
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(
                            value: 'All',
                            label: 'الكل (الجداول)',
                          ),
                          ...availableTables.map(
                            (table) =>
                                DropdownMenuEntry(value: table, label: table),
                          ),
                        ],
                        onSelected: (value) {
                          ref
                              .read(fieldManagementProvider.notifier)
                              .setFilter(table: value);
                        },
                        width: 250,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),

              // Data List Section
              Expanded(
                child: groupedFields.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد حقول متاحة.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: groupedFields.keys.length,
                        itemBuilder: (context, index) {
                          final groupName = groupedFields.keys.elementAt(index);
                          final fields = groupedFields[groupName]!;

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              title: Text(
                                groupName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                              children: fields.map((field) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    field.fieldLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'الاسم البرمجي: ${field.columnName}\nالنوع: ${field.fieldType}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  isThreeLine: true,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (field.isRequired)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'مطلوب',
                                            style: TextStyle(
                                              color: AppColors.error,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      if (!field.isVisible)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            'مخفي',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            _showEditDialog(context, field),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('حدث خطأ: $err', style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: () =>
                    ref.read(fieldManagementProvider.notifier).loadFields(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, FormFieldConfigModel field) {
    final labelController = TextEditingController(text: field.fieldLabel);
    bool isVisible = field.isVisible;
    bool isRequired = field.isRequired;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'تعديل الحقل',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: labelController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الحقل (للعرض)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('مرئي (يظهر للأمين)'),
                      value: isVisible,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => isVisible = val),
                    ),
                    SwitchListTile(
                      title: const Text('إلزامي (مطلوب تعبئته)'),
                      value: isRequired,
                      activeColor: AppColors.error,
                      onChanged: (val) => setState(() => isRequired = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    final success = await ref
                        .read(fieldManagementProvider.notifier)
                        .updateField(field.id, {
                          'field_label': labelController.text,
                          'is_visible': isVisible,
                          'is_required': isRequired,
                        });

                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تحديث الحقل بنجاح')),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('حدث خطأ أثناء التحديث')),
                      );
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
