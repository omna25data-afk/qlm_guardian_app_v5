import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/reports_provider.dart';
import 'fees_report_screen.dart';

class ReportsTabWidget extends StatelessWidget {
  const ReportsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ReportsFilterWidget(),
        Expanded(child: FeesReportScreen()),
      ],
    );
  }
}

class ReportsFilterWidget extends ConsumerWidget {
  const ReportsFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(reportsFilterProvider);
    final yearsAsync = ref.watch(availableYearsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'السنة',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: filter.year,
                      isDense: true,
                      items: yearsAsync.when(
                        data: (years) {
                          final uniqueYears = years.toSet().toList();
                          // Ensure the current filter year is in the list
                          if (!uniqueYears.contains(filter.year)) {
                            uniqueYears.add(filter.year);
                          }
                          uniqueYears.sort(
                            (a, b) => b.compareTo(a),
                          ); // Descending

                          return uniqueYears
                              .map(
                                (y) => DropdownMenuItem(
                                  value: y,
                                  child: Text('$y'),
                                ),
                              )
                              .toList();
                        },
                        loading: () => [
                          DropdownMenuItem(
                            value: filter.year,
                            child: Text('${filter.year}'),
                          ),
                        ],
                        error: (_, __) => [
                          DropdownMenuItem(
                            value: filter.year,
                            child: Text('${filter.year}'),
                          ),
                        ],
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(reportsFilterProvider.notifier).state = ref
                              .read(reportsFilterProvider)
                              .copyWith(year: val);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'نوع الفترة',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filter.periodType,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 'annual', child: Text('سنوي')),
                        DropdownMenuItem(
                          value: 'semi_annual',
                          child: Text('نصف سنوي'),
                        ),
                        DropdownMenuItem(
                          value: 'quarterly',
                          child: Text('ربع سنوي'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(reportsFilterProvider.notifier).state = ref
                              .read(reportsFilterProvider)
                              .copyWith(periodType: val, periodValue: null);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (filter.periodType != 'annual') ...[
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'الفترة',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:
                      _getPeriodValues(
                            filter.periodType,
                          )?.any((item) => item.value == filter.periodValue) ==
                          true
                      ? filter.periodValue
                      : null,
                  isDense: true,
                  items: _getPeriodValues(filter.periodType),
                  onChanged: (val) {
                    ref.read(reportsFilterProvider.notifier).state = ref
                        .read(reportsFilterProvider)
                        .copyWith(periodValue: val);
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>>? _getPeriodValues(String type) {
    if (type == 'semi_annual') {
      return const [
        DropdownMenuItem(value: '1', child: Text('النصف الأول')),
        DropdownMenuItem(value: '2', child: Text('النصف الثاني')),
      ];
    } else if (type == 'quarterly') {
      return const [
        DropdownMenuItem(value: 'Q1', child: Text('الربع الأول')),
        DropdownMenuItem(value: 'Q2', child: Text('الربع الثاني')),
        DropdownMenuItem(value: 'Q3', child: Text('الربع الثالث')),
        DropdownMenuItem(value: 'Q4', child: Text('الربع الرابع')),
      ];
    }
    return null;
  }
}
