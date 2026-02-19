import 'package:flutter/material.dart';
import '../widgets/admin_entries_list_tab.dart';
import 'admin_add_entry_screen.dart';

class AdminEntriesScreen extends StatelessWidget {
  const AdminEntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة القيود'), centerTitle: true),
      body: const AdminEntriesListTab(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminAddEntryScreen(),
            ),
          );
        },
        tooltip: 'إضافة قيد جديد',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
