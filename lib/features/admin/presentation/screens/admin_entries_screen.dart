import 'package:flutter/material.dart';
import '../widgets/admin_entries_list_tab.dart';

class AdminEntriesScreen extends StatelessWidget {
  const AdminEntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة القيود'), centerTitle: true),
      body: const AdminEntriesListTab(),
    );
  }
}
