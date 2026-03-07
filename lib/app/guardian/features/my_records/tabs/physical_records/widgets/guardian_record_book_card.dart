import 'package:flutter/material.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import 'package:qlm_guardian_app_v5/core/utils/arabic_pluralization.dart';
import '../../../../../../../features/records/data/models/record_book.dart';

class GuardianRecordBookCard extends StatelessWidget {
  final RecordBook book;
  final VoidCallback onTap;

  const GuardianRecordBookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سجل رقم ${book.bookNumber}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'عدد القيود والمحررات: ${ArabicPluralization.formatEntries(book.entriesCount, includeZero: false)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showInfoDialog(context, book),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow(
                Icons.account_balance,
                'رقم السجل بالوزارة',
                book.ministryRecordNumber ?? 'غير محدد',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.description,
                'القالب المستخدم',
                book.templateName ?? 'غير محدد',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.calendar_today,
                'سنة الصرف',
                '${book.issuanceYear} هـ',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.history, 'السنوات', book.years.join('، ')),
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.pages,
                'سعة السجل',
                'استُخدم ${book.usedPages} من ${book.totalPages} صفحة (${book.usagePercentage}%)',
              ),
              const SizedBox(height: 8),
              if (book.usagePercentage >= 100)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'السجل ممتلئ تماماً',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: book.totalPages > 0
                        ? book.usedPages / book.totalPages
                        : 0,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      book.usagePercentage > 80 ? Colors.orange : Colors.green,
                    ),
                    minHeight: 8,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontFamily: 'Tajawal',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context, RecordBook notebook) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'معلومات السجل',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(Icons.book, 'رقم السجل', '${notebook.bookNumber}'),
            _buildInfoItem(
              Icons.list_alt,
              'إجمالي عدد القيود',
              '${ArabicPluralization.formatEntries(notebook.entriesCount, includeZero: false)}',
            ),
            _buildInfoItem(
              Icons.pages,
              'السعة المتبقية',
              'استُخدم ${notebook.usedPages} مدخل من أصل ${notebook.totalPages} صفحة',
            ),
            _buildInfoItem(
              Icons.account_balance,
              'رقم سجل وزارة العدل',
              notebook.ministryRecordNumber ?? 'غير محدد',
            ),
            _buildInfoItem(
              Icons.description,
              'قالب السجل المعتمد',
              notebook.templateName ?? 'غير محدد',
            ),
            _buildInfoItem(
              Icons.calendar_today,
              'سنة الصرف للهيئة',
              '${notebook.issuanceYear} هـ',
            ),
            _buildInfoItem(
              Icons.history,
              'سنوات العمل والقيود',
              notebook.years.join('، '),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
