import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Parties section of the entry form
/// Allows adding/removing parties involved in the registry entry
class PartiesSection extends StatelessWidget {
  final List<Map<String, String>> parties;
  final ValueChanged<List<Map<String, String>>> onPartiesChanged;

  const PartiesSection({
    super.key,
    required this.parties,
    required this.onPartiesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing parties
        ...parties.asMap().entries.map((mapEntry) {
          final index = mapEntry.key;
          final party = mapEntry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              title: Text(party['name'] ?? 'بدون اسم'),
              subtitle: Text(party['role'] ?? 'طرف'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () {
                  final updated = List<Map<String, String>>.from(parties);
                  updated.removeAt(index);
                  onPartiesChanged(updated);
                },
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // Add party button
        OutlinedButton.icon(
          onPressed: () => _showAddPartyDialog(context),
          icon: const Icon(Icons.person_add_outlined),
          label: const Text('إضافة طرف'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  void _showAddPartyDialog(BuildContext context) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة طرف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'الصفة',
                hintText: 'مثال: طرف أول، وكيل',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final updated = List<Map<String, String>>.from(parties);
                updated.add({
                  'name': nameController.text,
                  'role': roleController.text.isEmpty
                      ? 'طرف'
                      : roleController.text,
                });
                onPartiesChanged(updated);
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
