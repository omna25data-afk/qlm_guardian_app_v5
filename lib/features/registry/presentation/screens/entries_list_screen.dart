import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/registry_provider.dart';
import 'entry_details_screen.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(registryEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل القيود'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.invalidate(registryEntriesProvider);
            },
          ),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('لا توجد قيود مسجلة'));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      entry.id?.toString() ?? '-',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                  title: Text(entry.subject ?? 'بدون عنوان'),
                  subtitle: Text(entry.status),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EntryDetailsScreen(entry: entry),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add entry screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
