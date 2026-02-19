import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../admin/presentation/providers/add_entry_provider.dart';
import 'dynamic_field_builder.dart';

/// Contract type party labels
const Map<int, Map<String, String>> contractPartyLabels = {
  1: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'},
  7: {'first': 'اسم الزوج', 'second': 'اسم الزوجة'},
  8: {'first': 'اسم الزوج المراجع', 'second': 'اسم الزوجة'},
  4: {'first': 'اسم الموكل', 'second': 'اسم الوكيل'},
  5: {'first': 'اسم المتصرف', 'second': 'اسم المتصرف إليه'},
  6: {'first': 'اسم المؤرث', 'second': 'أسماء الورثة'},
  10: {'first': 'اسم البائع', 'second': 'اسم المشتري'},
};

class PartiesSection extends ConsumerStatefulWidget {
  final int? selectedContractTypeId;
  final String writerType;
  final int? selectedGuardianId;
  final TextEditingController firstPartyController;
  final TextEditingController secondPartyController;
  final TextEditingController documentHijriDateController;
  final TextEditingController documentGregorianDateController;
  final TextEditingController divorceContractNumberController;
  final TextEditingController returnDateController;
  final Map<String, TextEditingController> dynamicControllers;
  final String? selectedSubtype1;
  final String? selectedSubtype2;
  final ValueChanged<String?> onSubtype1Changed;
  final ValueChanged<String?> onSubtype2Changed;
  final ValueChanged<String> onWriterTypeChanged;
  final ValueChanged<int?> onGuardianChanged;
  final VoidCallback onFeesRecalculate;

  const PartiesSection({
    super.key,
    required this.selectedContractTypeId,
    required this.writerType,
    required this.selectedGuardianId,
    required this.firstPartyController,
    required this.secondPartyController,
    required this.documentHijriDateController,
    required this.documentGregorianDateController,
    required this.divorceContractNumberController,
    required this.returnDateController,
    required this.dynamicControllers,
    required this.selectedSubtype1,
    required this.selectedSubtype2,
    required this.onSubtype1Changed,
    required this.onSubtype2Changed,
    required this.onWriterTypeChanged,
    required this.onGuardianChanged,
    required this.onFeesRecalculate,
  });

  @override
  ConsumerState<PartiesSection> createState() => _PartiesSectionState();
}

class _PartiesSectionState extends ConsumerState<PartiesSection> {
  Future<void> _selectHijriDate(
    BuildContext context,
    TextEditingController hijriCtrl,
    TextEditingController gregCtrl,
  ) async {
    final picked = await showHijriDatePicker(
      context: context,
      initialDate: HijriCalendar.now(),
      firstDate: HijriCalendar()
        ..hYear = 1440
        ..hMonth = 1
        ..hDay = 1,
      lastDate: HijriCalendar()
        ..hYear = 1460
        ..hMonth = 12
        ..hDay = 29,
    );
    if (picked != null) {
      hijriCtrl.text = picked.toString();
      final greg = picked.hijriToGregorian(
        picked.hYear,
        picked.hMonth,
        picked.hDay,
      );
      gregCtrl.text =
          '${greg.year}-${greg.month.toString().padLeft(2, '0')}-${greg.day.toString().padLeft(2, '0')}';
      widget.onFeesRecalculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEntryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Writer Type
        _buildWriterTypeSelector(),
        const SizedBox(height: 16),

        // Guardian Selector (if guardian writer type)
        if (widget.writerType == 'guardian') ...[
          SearchableDropdown(
            items: state.guardians,
            label: 'اسم الأمين',
            value: widget.selectedGuardianId != null
                ? state.guardians.firstWhere(
                    (e) => e['id'] == widget.selectedGuardianId,
                    orElse: () => {},
                  )
                : null,
            itemLabelBuilder: (i) => i['name'],
            onChanged: (v) => widget.onGuardianChanged(v?['id']),
          ),
          const SizedBox(height: 16),
        ],

        // Dynamic subtypes + parties
        if (widget.selectedContractTypeId != null) ...[
          ..._buildSubtypes(state),
          ..._buildPartyFields(),
          ..._buildContractSpecificFields(),
          DynamicFieldBuilder(
            fields: state.filteredFields,
            isLoading: state.isLoadingFields,
            controllers: widget.dynamicControllers,
            onFieldChanged: (entry) {
              ref
                  .read(addEntryProvider.notifier)
                  .updateFormData(entry.key, entry.value);
              if (entry.key == 'sale_price') {
                Future.delayed(Duration.zero, widget.onFeesRecalculate);
              }
            },
          ),
        ],

        // Document Date
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.documentHijriDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'تاريخ المحرر (هـ)',
                  prefixIcon: Icon(Icons.calendar_month, size: 20),
                ),
                onTap: () => _selectHijriDate(
                  context,
                  widget.documentHijriDateController,
                  widget.documentGregorianDateController,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: widget.documentGregorianDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'تاريخ المحرر (م)',
                  prefixIcon: Icon(Icons.date_range, size: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWriterTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الكاتب',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _writerChip('guardian', 'أمين شرعي', Icons.verified_user),
            const SizedBox(width: 8),
            _writerChip('documentation', 'موظف توثيق', Icons.badge),
            const SizedBox(width: 8),
            _writerChip('external', 'كاتب خارجي', Icons.person_outline),
          ],
        ),
      ],
    );
  }

  Widget _writerChip(String value, String label, IconData icon) {
    final isSelected = widget.writerType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onWriterTypeChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSubtypes(AddEntryState state) {
    final widgets = <Widget>[];

    if (state.subtypes1.isNotEmpty) {
      widgets.add(
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes1,
          label: 'النوع الفرعي الأول',
          value: widget.selectedSubtype1 != null
              ? state.subtypes1.firstWhere(
                  (e) =>
                      e['code'] == widget.selectedSubtype1 ||
                      e['id'].toString() == widget.selectedSubtype1,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (i) => i['name'],
          onChanged: (v) {
            final code = v?['code']?.toString() ?? v?['id']?.toString();
            widget.onSubtype1Changed(code);
            ref
                .read(addEntryProvider.notifier)
                .loadSubtypes(widget.selectedContractTypeId!, parentCode: code);
            ref
                .read(addEntryProvider.notifier)
                .filterFields(subtype1: code, subtype2: null);
          },
        ),
      );
      widgets.add(const SizedBox(height: 12));
    }

    if (state.subtypes2.isNotEmpty) {
      widgets.add(
        SearchableDropdown<Map<String, dynamic>>(
          items: state.subtypes2,
          label: 'النوع الفرعي الثانوي',
          value: widget.selectedSubtype2 != null
              ? state.subtypes2.firstWhere(
                  (e) =>
                      e['code'] == widget.selectedSubtype2 ||
                      e['id'].toString() == widget.selectedSubtype2,
                  orElse: () => {},
                )
              : null,
          itemLabelBuilder: (i) => i['name'],
          onChanged: (v) {
            final code = v?['code']?.toString() ?? v?['id']?.toString();
            widget.onSubtype2Changed(code);
            ref
                .read(addEntryProvider.notifier)
                .filterFields(
                  subtype1: widget.selectedSubtype1,
                  subtype2: code,
                );
          },
        ),
      );
      widgets.add(const SizedBox(height: 12));
    }

    return widgets;
  }

  List<Widget> _buildPartyFields() {
    final labels =
        contractPartyLabels[widget.selectedContractTypeId] ??
        {'first': 'الطرف الأول', 'second': 'الطرف الثاني'};

    final isDivision = widget.selectedContractTypeId == 6;

    if (isDivision) {
      return [
        TextFormField(
          controller: widget.firstPartyController,
          decoration: InputDecoration(
            labelText: 'اسم المؤرث',
            prefixIcon: const Icon(Icons.person, size: 20),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: widget.secondPartyController,
          decoration: InputDecoration(
            labelText: 'أسماء الورثة (مفصولين بفاصلة)',
            prefixIcon: const Icon(Icons.people, size: 20),
          ),
          maxLines: 2,
        ),
      ];
    }

    return [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.firstPartyController,
              decoration: InputDecoration(
                labelText: labels['first'],
                prefixIcon: const Icon(Icons.person, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: widget.secondPartyController,
              decoration: InputDecoration(
                labelText: labels['second'],
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildContractSpecificFields() {
    if (widget.selectedContractTypeId == 8) {
      // Return contract
      return [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.divorceContractNumberController,
                decoration: const InputDecoration(
                  labelText: 'رقم عقد الطلاق',
                  prefixIcon: Icon(Icons.numbers, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: widget.returnDateController,
                decoration: const InputDecoration(
                  labelText: 'تاريخ الرجعة',
                  prefixIcon: Icon(Icons.calendar_today, size: 20),
                ),
              ),
            ),
          ],
        ),
      ];
    }
    return [];
  }
}
