import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tabs/containers/screens/containers_tab.dart';
import '../tabs/entries/screens/guardian_entries_list_screen.dart';

/// شاشة سجلاتي الرئيسية — تبويب في واجهة الأمين الشرعي
/// تحتوي على TabBar يبدل بين:
/// 1. سجلاتي (الحاويات المركزية - السجل العام)
/// 2. قيودي (قائمة جميع القيود)
class MyRecordsScreen extends ConsumerStatefulWidget {
  const MyRecordsScreen({super.key});

  @override
  ConsumerState<MyRecordsScreen> createState() => _MyRecordsScreenState();
}

class _MyRecordsScreenState extends ConsumerState<MyRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Tab Bar
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'سجلاتي'),
              Tab(text: 'قيودي'),
            ],
            indicator: BoxDecoration(
              color: const Color(0xFF006400),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Tajawal',
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'Tajawal',
            ),
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.all(4),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // سجلاتي - الحاويات المركزية (7 أنواع)
              ContainersTab(),
              // قيودي - entries
              GuardianEntriesListScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
