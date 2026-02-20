import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'reports_dashboard_screen.dart';
import 'guardian_statistics_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقارير والإحصائيات'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.analytics_outlined),
                text: 'إحصائيات الأمناء',
              ),
              Tab(icon: Icon(Icons.list_alt_outlined), text: 'تقارير الرسوم'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab 1: Statistics
            GuardianStatisticsScreen(),
            // Tab 2: Reports Tab (Refactored)
            ReportsTabWidget(),
          ],
        ),
      ),
    );
  }
}
