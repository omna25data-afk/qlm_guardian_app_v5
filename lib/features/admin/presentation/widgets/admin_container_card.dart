import 'package:flutter/material.dart';
import '../../../../../../core/utils/arabic_pluralization.dart';
import '../screens/records/admin_physical_books_screen.dart';

/// بطاقة عرض حاوية (سجل عام) — خاصة بالإدارة
class AdminContainerCard extends StatelessWidget {
  final String typeName;
  final int contractTypeId;
  final int totalEntries;
  final int activeBooks;
  final IconData icon;
  final Color color;

  const AdminContainerCard({
    super.key,
    required this.typeName,
    required this.contractTypeId,
    required this.totalEntries,
    required this.activeBooks,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminPhysicalBooksScreen(
                contractTypeId: contractTypeId,
                contractTypeName: typeName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // أيقونة الحاوية
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // اسم الحاوية والعداد
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildBadge(
                          ArabicPluralization.formatRecords(activeBooks),
                          color.withValues(alpha: 0.1),
                          color,
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          ArabicPluralization.formatEntries(totalEntries),
                          Colors.grey.shade100,
                          Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // سهم الدخول
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
