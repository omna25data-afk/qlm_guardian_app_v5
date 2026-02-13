import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_assignments_provider.dart';
import '../../data/models/admin_assignment_model.dart';

class AssignmentsListTab extends ConsumerStatefulWidget {
  const AssignmentsListTab({super.key});

  @override
  ConsumerState<AssignmentsListTab> createState() => _AssignmentsListTabState();
}

class _AssignmentsListTabState extends ConsumerState<AssignmentsListTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(adminAssignmentsProvider.notifier)
          .fetchAssignments(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAssignmentsProvider);

    return Column(
      children: [
        // List
        Expanded(
          child: state.isLoading && state.assignments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.error != null && state.assignments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(adminAssignmentsProvider.notifier)
                            .fetchAssignments(refresh: true),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : state.assignments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 60,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد تكليفات',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!state.isLoading &&
                        state.hasMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      ref
                          .read(adminAssignmentsProvider.notifier)
                          .fetchAssignments();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => ref
                        .read(adminAssignmentsProvider.notifier)
                        .fetchAssignments(refresh: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount:
                          state.assignments.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.assignments.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final assignment = state.assignments[index];
                        return _buildAssignmentCard(context, assignment);
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAssignmentCard(
    BuildContext context,
    AdminAssignmentModel assignment,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assignment.guardianName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(
                  assignment.status,
                  _getStatusColor(assignment.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.numbers, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'رقم التكليف: ${assignment.id}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'النوع: ${assignment.type}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${assignment.startDate ?? "غير محدد"}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'نشط':
      case 'active':
        return AppColors.success;
      case 'ملغي':
      case 'cancelled':
        return AppColors.error;
      case 'قيد الانتظار':
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.textHint;
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
