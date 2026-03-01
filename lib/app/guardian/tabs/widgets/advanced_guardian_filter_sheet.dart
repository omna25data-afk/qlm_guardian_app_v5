import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/registry/presentation/providers/entries_provider.dart';
import '../../../../features/registry/presentation/providers/contract_types_provider.dart';

class AdvancedGuardianFilterSheet extends ConsumerStatefulWidget {
  const AdvancedGuardianFilterSheet({super.key});

  @override
  ConsumerState<AdvancedGuardianFilterSheet> createState() =>
      _AdvancedGuardianFilterSheetState();
}

class _AdvancedGuardianFilterSheetState
    extends ConsumerState<AdvancedGuardianFilterSheet> {
  // Temporary state for the bottom sheet
  List<String> _tempStatuses = [];
  int? _tempContractTypeId;
  DateTime? _tempDateFrom;
  DateTime? _tempDateTo;
  String? _tempDeliveryStatus;

  @override
  void initState() {
    super.initState();
    // Initialize temporary state from current providers
    _tempStatuses = List.from(ref.read(entryStatusesFilterProvider));
    _tempContractTypeId = ref.read(entryContractTypeFilterProvider);
    _tempDateFrom = ref.read(entryDateFromFilterProvider);
    _tempDateTo = ref.read(entryDateToFilterProvider);
    _tempDeliveryStatus = ref.read(entryDeliveryStatusFilterProvider);
  }

  void _applyFilters() {
    ref.read(entryStatusesFilterProvider.notifier).state = _tempStatuses;
    ref.read(entryContractTypeFilterProvider.notifier).state =
        _tempContractTypeId;
    ref.read(entryDateFromFilterProvider.notifier).state = _tempDateFrom;
    ref.read(entryDateToFilterProvider.notifier).state = _tempDateTo;
    ref.read(entryDeliveryStatusFilterProvider.notifier).state =
        _tempDeliveryStatus;
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _tempStatuses = [];
      _tempContractTypeId = null;
      _tempDateFrom = null;
      _tempDateTo = null;
      _tempDeliveryStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contractTypesAsync = ref.watch(contractTypesProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تصفية متقدمة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'مسح الكل',
                  style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Status Filter ───
                  const Text(
                    'حالة القيد',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusChip('موثق', 'documented'),
                      _buildStatusChip('مسودة', 'draft'),
                      _buildStatusChip('مقيدة', 'registered_guardian'),
                      _buildStatusChip('قيد المعالجة', 'pending_documentation'),
                      _buildStatusChip('مرفوض', 'rejected'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── Contract Type Filter ───
                  const Text(
                    'نوع العقد',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  contractTypesAsync.when(
                    data: (types) => DropdownButtonFormField<int>(
                      value: _tempContractTypeId,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text(
                        'الكل',
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                      ),
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text(
                            'الكل',
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                        ),
                        ...types.map(
                          (type) => DropdownMenuItem<int>(
                            value: type.id,
                            child: Text(
                              type.name,
                              style: const TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _tempContractTypeId = val;
                        });
                      },
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text('خطأ: $e'),
                  ),
                  const SizedBox(height: 16),

                  // ─── Delivery Status ───
                  const Text(
                    'حالة التسليم',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDeliveryChip('لم يتم التسليم', 'not_delivered'),
                      _buildDeliveryChip('مسلمة', 'delivered'),
                      _buildDeliveryChip('محفوظة', 'preserved'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── Date Range Filter ───
                  const Text(
                    'تاريخ المحرر',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(context, true),
                          icon: const Icon(Icons.date_range, size: 18),
                          label: Text(
                            _tempDateFrom != null
                                ? '${_tempDateFrom!.year}-${_tempDateFrom!.month}-${_tempDateFrom!.day}'
                                : 'من تاريخ',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(context, false),
                          icon: const Icon(Icons.date_range, size: 18),
                          label: Text(
                            _tempDateTo != null
                                ? '${_tempDateTo!.year}-${_tempDateTo!.month}-${_tempDateTo!.day}'
                                : 'إلى تاريخ',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Apply Button
          ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'تطبيق التصفية',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    final isSelected = _tempStatuses.contains(value);
    return FilterChip(
      label: Text(
        label,
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _tempStatuses.add(value);
          } else {
            _tempStatuses.remove(value);
          }
        });
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildDeliveryChip(String label, String value) {
    final isSelected = _tempDeliveryStatus == value;
    return FilterChip(
      label: Text(
        label,
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _tempDeliveryStatus = selected ? value : null;
        });
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final initialDate = isFromDate
        ? _tempDateFrom ?? DateTime.now()
        : _tempDateTo ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        if (isFromDate) {
          _tempDateFrom = date;
        } else {
          _tempDateTo = date;
        }
      });
    }
  }
}
