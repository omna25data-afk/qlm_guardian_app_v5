import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Contract type icon/color mapping
const Map<int, IconData> _contractIcons = {
  1: Icons.favorite, // زواج
  4: Icons.gavel, // وكالة
  5: Icons.swap_horiz, // تصرف
  6: Icons.account_tree, // قسمة
  7: Icons.heart_broken, // طلاق
  8: Icons.replay, // رجعة
  10: Icons.shopping_cart, // مبيع
};

const Map<int, Color> _contractColors = {
  1: Color(0xFFE91E63), // وردي
  4: Color(0xFF795548), // بني
  5: Color(0xFF009688), // أخضر مزرق
  6: Color(0xFF673AB7), // بنفسجي
  10: Color(0xFFFF9800), // برتقالي
};

class ContractTypeSelector extends StatelessWidget {
  final List<Map<String, dynamic>> contractTypes;
  final int? selectedId;
  final ValueChanged<int> onSelected;

  const ContractTypeSelector({
    super.key,
    required this.contractTypes,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع العقد',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
          ),
          itemCount: contractTypes.length,
          itemBuilder: (context, index) {
            final ct = contractTypes[index];
            final id = ct['id'] as int;
            final name = ct['name']?.toString() ?? '';
            final isSelected = id == selectedId;
            final color = _contractColors[id] ?? AppColors.primary;
            final icon = _contractIcons[id] ?? Icons.description;

            return AnimatedScale(
              scale: isSelected ? 1.0 : 0.95,
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelected(id),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.12)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 24,
                          color: isSelected ? color : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? color : AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
