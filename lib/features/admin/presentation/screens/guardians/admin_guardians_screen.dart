import 'package:flutter/material.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import 'guardians_list_tab.dart';
import '../../widgets/licenses_list_tab.dart';
import '../../widgets/cards_list_tab.dart';
import '../../widgets/areas_list_tab.dart';
import '../../widgets/assignments_list_tab.dart';
// Removed unused import

class AdminGuardiansScreen extends StatelessWidget {
  const AdminGuardiansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                ),
                tabs: [
                  Tab(text: 'الأمناء'),
                  Tab(text: 'التراخيص'),
                  Tab(text: 'البطائق'),
                  Tab(text: 'المناطق'),
                  Tab(text: 'التكليفات'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  GuardiansListTab(),
                  LicensesListTab(),
                  CardsListTab(),
                  AreasListTab(),
                  AssignmentsListTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
