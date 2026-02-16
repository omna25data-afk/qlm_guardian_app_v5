import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../records/data/models/record_book.dart';

class PremiumRecordBookCard extends StatelessWidget {
  final RecordBook book;
  final VoidCallback onTap;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final VoidCallback onProcedures;
  final VoidCallback onShowEntries;

  const PremiumRecordBookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onOpen,
    required this.onClose,
    required this.onProcedures,
    required this.onShowEntries,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = book.statusColor;
    final isClosed =
        book.statusLabel.contains('مغلق') ||
        book.statusLabel.contains('Closed');

    // Determine Category Logic (Visual)
    Color categoryColor;
    IconData categoryIcon;

    if (book.category == 'documentation_final') {
      categoryColor = AppColors.success; // Green
      categoryIcon = Icons.verified_user_outlined; // or check_circle_outline
    } else if (book.category == 'documentation_recording') {
      categoryColor = Colors.orange; // Orange
      categoryIcon = Icons.edit_note; // or history_edu
    } else {
      // Default to guardian_recording or fallback
      categoryColor = AppColors.primary; // Blue (assuming primary is blue-ish)
      categoryIcon = Icons.person_outline;
    }

    // Derived Data
    final completionPercent = book.usagePercentage / 100.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Category & Type & Status
                _buildHeader(context, statusColor, categoryColor, categoryIcon),

                const Divider(height: 1, color: AppColors.border),

                // 2. Main Info: Title, Writer, Ministry Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title.isNotEmpty
                            ? book.title
                            : 'سجل رقم ${book.number}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Writer Name / Ministry Num
                      Row(
                        children: [
                          _buildIconText(
                            Icons.person_outline,
                            book.writerName.isNotEmpty
                                ? 'الكاتب: ${book.writerName}'
                                : 'الكاتب: غير محدد',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (book.ministryRecordNumber != null)
                            Expanded(
                              child: _buildIconText(
                                Icons.confirmation_number_outlined,
                                'وزاري: ${book.ministryRecordNumber}',
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildIconText(
                              Icons.calendar_today_outlined,
                              'تاريخ الصرف: ${book.issuanceYear} هـ',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نسبة الاستخدام',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Text(
                            '${book.usagePercentage}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: completionPercent,
                          backgroundColor: Colors.grey[100],
                          color: statusColor,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${book.usedPages} من ${book.totalPages} صفحة مستخدمة',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Statistics Grid (Entries) - Always show if there are entries or if it's an active book
                if (book.totalEntries > 0 || book.isActive)
                  Container(
                    color: Colors.grey[50],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          context,
                          'إجمالي القيود',
                          '${book.totalEntries}',
                          AppColors.textPrimary,
                        ),
                        _buildVerticalDivider(),
                        _buildStatItem(
                          context,
                          'موثقة',
                          '${book.completedEntries}',
                          AppColors.success,
                        ),
                        _buildVerticalDivider(),
                        _buildStatItem(
                          context,
                          'قيد العمل',
                          '${book.draftEntries + book.pendingEntries + book.registeredEntries}',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),

                // 5. Actions Footer
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isClosed ? onOpen : onClose,
                          icon: Icon(
                            isClosed ? Icons.lock_open : Icons.lock_outlined,
                            size: 16,
                            color: isClosed
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          label: Text(
                            isClosed ? 'فتح السجل' : 'إغلاق السجل',
                            style: TextStyle(
                              color: isClosed
                                  ? AppColors.success
                                  : AppColors.error,
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isClosed
                                  ? AppColors.success
                                  : AppColors.error.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onShowEntries,
                          icon: const Icon(Icons.list_alt, size: 16),
                          label: const Text(
                            'عرض القيود',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onProcedures,
                          icon: const Icon(Icons.history, size: 16),
                          label: const Text(
                            'الإجراءات',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color statusColor,
    Color categoryColor,
    IconData catIcon,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(catIcon, size: 14, color: categoryColor),
                const SizedBox(width: 4),
                Text(
                  book.categoryLabel ?? 'عام',
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Record Type
          if (book.contractType.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                book.contractType,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          const Spacer(),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              book.statusLabel,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: valueColor,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 24, width: 1, color: Colors.grey[300]);
  }
}
